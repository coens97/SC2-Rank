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

- (IBAction) pressedSave:(id)sender;
@end
