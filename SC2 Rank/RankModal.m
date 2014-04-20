//
//  RankModal.m
//  Starcraft 2 Rank
//
//  Created by Coen on 19/04/14.
//
//

#import "RankModal.h"
#import "ApplicationDelegate.h"
#import "PanelController.h"

@implementation RankModal

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.data setLength:0];
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    [self.data appendData:data];
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    NSLog(@"Connection failed");
    currentConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    currentConnection = nil;
    NSString *text = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    self.data = nil;
    [self parse:text];
}

- (void)parse: (NSString*)text
{
    //Get bonus pool
    NSRange   searchedRange = NSMakeRange(0, text.length);
    NSString *pattern = @"Bonus Pool: <span>(\\d+)</span>";
    
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern: pattern options:0 error:nil];
    NSArray* matches = [regex matchesInString:text options:0 range: searchedRange];
    NSString* bonusPool = [text substringWithRange:[[matches objectAtIndex:0]rangeAtIndex:1]];
    NSLog(@"Bonus pool: %@", bonusPool);
    //Get leage
    pattern = @"<title>.*?\\s([A-Z][a-z]+)\\s-";
    regex = [NSRegularExpression regularExpressionWithPattern: pattern options:0 error:nil];
    matches = [regex matchesInString:text options:0 range: searchedRange];
    NSString* leage = [text substringWithRange:[[matches objectAtIndex:0]rangeAtIndex:1]];
    //Get rank info
    pattern = @"id=\"current-rank\">\\s+<td[\\s\\S]*?td>\\s+<td.*?>(\\d+).*<[\\s\\S]*?class=\"race-(.*?)\"[\\s\\S]*?>\\s+(.*?\\s.*?|.*?)\\s+[\\s\\S]*?<td.*?>(\\d+)[\\s\\S]*?\">(\\d+)<[\\s\\S]*?\">(\\d+)";
    regex = [NSRegularExpression regularExpressionWithPattern: pattern options:0 error:nil];
    matches = [regex matchesInString:text options:0 range: searchedRange];
    //Parsed values, put in dictionary
    NSDictionary* rank = [NSDictionary dictionaryWithObjectsAndKeys:
                          bonusPool, @"bonus",
                          leage, @"leage",
                          [text substringWithRange:[[matches objectAtIndex:0]rangeAtIndex:1]], @"place",
                          [text substringWithRange:[[matches objectAtIndex:0]rangeAtIndex:2]], @"race",
                          [text substringWithRange:[[matches objectAtIndex:0]rangeAtIndex:3]], @"player",
                          [text substringWithRange:[[matches objectAtIndex:0]rangeAtIndex:4]], @"points",
                          [text substringWithRange:[[matches objectAtIndex:0]rangeAtIndex:5]], @"wins",
                          [text substringWithRange:[[matches objectAtIndex:0]rangeAtIndex:6]], @"lost",
                          nil];
    //Update layout
    ApplicationDelegate* del = [[NSApplication sharedApplication] delegate];
    [del.panelController updateLayout:rank];
};

- (void) update // Make request
{
    ApplicationDelegate* del = [[NSApplication sharedApplication] delegate];
    //Make ladder url
    NSString *url = [NSString stringWithFormat:@"%@ladder/leages", [del.settings getUrl]];
    //Request data
    NSLog(@"Requesting info from %@",url);
    //NSString url =
    NSURL *rUrl = [NSURL URLWithString:url];
    NSURLRequest *rRequest = [NSURLRequest requestWithURL:rUrl];
    //Check if there is a current connection, if so disconnect
    if( currentConnection)
    {
        [currentConnection cancel];
        currentConnection = nil;
    }
    //Make request
    currentConnection = [[NSURLConnection alloc]   initWithRequest:rRequest delegate:self];
    self.data = [NSMutableData data];
}
@end
