#import "MenubarController.h"
#import "PanelController.h"
#import "SettingsController.h"
#import "SettingsModal.h"
#import "RankModal.h"

@interface ApplicationDelegate : NSObject

@property (nonatomic, strong) MenubarController *menubarController;
@property (nonatomic, strong, readonly) PanelController *panelController;
@property (nonatomic, strong) SettingsController *settingsController;
@property (nonatomic) SettingsModal *settings;
@property (nonatomic) RankModal *rankModal;

- (IBAction)togglePanel:(id)sender;
@end
