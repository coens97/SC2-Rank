#import "StatusItemView.h"

@class PanelController;

@protocol PanelControllerDelegate <NSObject>

@optional

- (StatusItemView *)statusItemViewForPanelController:(PanelController *)controller;

@end

#pragma mark -

@interface PanelController : NSWindowController <NSWindowDelegate>
{
    BOOL _hasActivePanel;
    id<PanelControllerDelegate> _delegate;
}

@property (nonatomic) BOOL hasActivePanel;
@property (nonatomic) id<PanelControllerDelegate> delegate;

- (id)initWithDelegate:(id<PanelControllerDelegate>)delegate;

- (void)openPanel;
- (void)closePanel;

- (IBAction) pressedSettings:(id)sender;
- (void) updateLayout:(NSDictionary*)data;
//Layout
@property (nonatomic, retain) IBOutlet NSTextField *playerName;
@property (nonatomic, retain) IBOutlet NSTextField *points;
@property (nonatomic, retain) IBOutlet NSTextField *bonus;
@property (nonatomic, retain) IBOutlet NSTextField *place;
@property (nonatomic, retain) IBOutlet NSTextField *winLost;
@property (nonatomic, retain) IBOutlet NSImageView *leageImage;
@property (nonatomic, retain) IBOutlet NSImageView *bg;
@end
