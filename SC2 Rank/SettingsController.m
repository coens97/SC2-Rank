//
//  SettingsController.m
//  Starcraft 2 Rank
//
//  Created by Coen on 19/04/14.
//
//

#import "SettingsController.h"
#import "ApplicationDelegate.h"
#import "SettingsModal.h"

@interface SettingsController ()

@end

@implementation SettingsController

- (id)initWithDelegate:(NSObject*)delegate
{
    self = [super initWithWindowNibName:@"SettingsController"];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    ApplicationDelegate* del = _delegate;
    //Fill in saved values
    _btUrl.stringValue = [del.settings getUrl];
}
- (IBAction) pressedSave:(id)sender
{
    NSLog(@"Save");
    ApplicationDelegate* del = _delegate;
    //Save settings
    [del.settings setUrl:_btUrl.stringValue];
    //Update rank
    [del.rankModal update];
    //Close window
    [self.window close];
}
@end
