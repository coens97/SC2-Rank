//
//  SettingsModal.m
//  Starcraft 2 Rank
//
//  Created by Coen on 19/04/14.
//
//

#import "SettingsModal.h"

@implementation SettingsModal
- (NSString*) getUrl
{
    NSString* val = @"";
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    val = [standardUserDefaults stringForKey:@"url"];
    if (val == NULL) val = @"";
    return val;
}

- (void)setUrl:(NSString*)value
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if (standardUserDefaults)
    {
		[standardUserDefaults setObject:value forKey:@"url"];
		[standardUserDefaults synchronize];
	}
}

@end
