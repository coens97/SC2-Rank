//
//  SettingsController.h
//  Starcraft 2 Rank
//
//  Created by Coen on 19/04/14.
//
//

#import <Cocoa/Cocoa.h>

@interface SettingsController : NSWindowController
@property NSObject* delegate;
- (id)initWithDelegate:(NSObject*)delegate;

@property (nonatomic, retain) IBOutlet NSTextField *btUrl;
@property (nonatomic, retain) IBOutlet NSButton *checkStartup;

- (IBAction) pressedSave:(id)sender;
- (IBAction)toggleLaunchAtStartup:(id)sender;
@end
