#import "PanelController.h"
#import "StatusItemView.h"
#import "MenubarController.h"
#import "ApplicationDelegate.h"

#define OPEN_DURATION .15
#define CLOSE_DURATION .1

#define POPUP_HEIGHT 163
#define PANEL_WIDTH 320
#define MENU_ANIMATION_DURATION .1

#pragma mark -

@implementation PanelController

@synthesize delegate = _delegate;

#pragma mark -

- (id)initWithDelegate:(id<PanelControllerDelegate>)delegate
{
    self = [super initWithWindowNibName:@"Panel"];
    if (self != nil)
    {
        _delegate = delegate;
    }
    return self;
}

- (void)dealloc
{
    
}

#pragma mark -

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Make a fully skinned panel
    NSPanel *panel = (id)[self window];
    [panel setAcceptsMouseMovedEvents:YES];
    [panel setLevel:NSPopUpMenuWindowLevel];
    [panel setOpaque:NO];
    [panel setBackgroundColor:[NSColor clearColor]];
}

#pragma mark - Public accessors

- (BOOL)hasActivePanel
{
    return _hasActivePanel;
}

- (void)setHasActivePanel:(BOOL)flag
{
    if (_hasActivePanel != flag)
    {
        _hasActivePanel = flag;
        
        if (_hasActivePanel)
        {
            [self openPanel];
        }
        else
        {
            [self closePanel];
        }
    }
}

#pragma mark - NSWindowDelegate

- (void)windowWillClose:(NSNotification *)notification
{
    self.hasActivePanel = NO;
}

- (void)windowDidResignKey:(NSNotification *)notification;
{
    if ([[self window] isVisible])
    {
        self.hasActivePanel = NO;
    }
}

- (void)windowDidResize:(NSNotification *)notification
{
    
}

#pragma mark - Keyboard

- (void)cancelOperation:(id)sender
{
    self.hasActivePanel = NO;
}


#pragma mark - Public methods

- (NSRect)statusRectForWindow:(NSWindow *)window
{
    NSRect screenRect = [[[NSScreen screens] objectAtIndex:0] frame];
    NSRect statusRect = NSZeroRect;
    
    StatusItemView *statusItemView = nil;
    if ([self.delegate respondsToSelector:@selector(statusItemViewForPanelController:)])
    {
        statusItemView = [self.delegate statusItemViewForPanelController:self];
    }
    
    if (statusItemView)
    {
        statusRect = statusItemView.globalRect;
        statusRect.origin.y = NSMinY(statusRect) - NSHeight(statusRect);
    }
    else
    {
        statusRect.size = NSMakeSize(STATUS_ITEM_VIEW_WIDTH, [[NSStatusBar systemStatusBar] thickness]);
        statusRect.origin.x = roundf((NSWidth(screenRect) - NSWidth(statusRect)) / 2);
        statusRect.origin.y = NSHeight(screenRect) - NSHeight(statusRect) * 2;
    }
    return statusRect;
}

- (void)openPanel
{
    //Open panel
    NSWindow *panel = [self window];
    
    NSRect screenRect = [[[NSScreen screens] objectAtIndex:0] frame];
    NSRect statusRect = [self statusRectForWindow:panel];

    NSRect panelRect = [panel frame];
    panelRect.size.width = PANEL_WIDTH;
    panelRect.size.height = POPUP_HEIGHT;
    panelRect.origin.x = roundf(NSMidX(statusRect) - NSWidth(panelRect) / 2);
    panelRect.origin.y = NSMaxY(statusRect) - NSHeight(panelRect);
    
    [NSApp activateIgnoringOtherApps:NO];
    [panel setAlphaValue:0];
    [panel setFrame:statusRect display:YES];
    [panel makeKeyAndOrderFront:nil];
    
    NSTimeInterval openDuration = OPEN_DURATION;
    
    NSEvent *currentEvent = [NSApp currentEvent];
    if ([currentEvent type] == NSLeftMouseDown)
    {
        NSUInteger clearFlags = ([currentEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask);
        BOOL shiftPressed = (clearFlags == NSShiftKeyMask);
        BOOL shiftOptionPressed = (clearFlags == (NSShiftKeyMask | NSAlternateKeyMask));
        if (shiftPressed || shiftOptionPressed)
        {
            openDuration *= 10;
            
            if (shiftOptionPressed)
                NSLog(@"Icon is at %@\n\tMenu is on screen %@\n\tWill be animated to %@",
                      NSStringFromRect(statusRect), NSStringFromRect(screenRect), NSStringFromRect(panelRect));
        }
    }
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:openDuration];
    [[panel animator] setFrame:panelRect display:YES];
    [[panel animator] setAlphaValue:1];
    [NSAnimationContext endGrouping];
    //Update rank
    ApplicationDelegate* d = _delegate;
    [d.rankModal update];
}

- (void)closePanel
{
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:CLOSE_DURATION];
    [[[self window] animator] setAlphaValue:0];
    [NSAnimationContext endGrouping];
    
    dispatch_after(dispatch_walltime(NULL, NSEC_PER_SEC * CLOSE_DURATION * 2), dispatch_get_main_queue(), ^{
        
        [self.window orderOut:nil];
    });
}

- (IBAction) pressedSettings:(id)sender
{
    //Get delegate
    ApplicationDelegate* d = _delegate;
    //Show settinggs
    [d.settingsController showWindow:self];
}
- (void) updateLayout:(NSDictionary*)data
{
    NSLog(@"Update layout");
    //Update labels
    self.playerName.stringValue = [data valueForKey:@"player"];
    self.bonus.stringValue = [data valueForKey:@"bonus"];
    self.points.stringValue = [data valueForKey:@"points"];
    self.winLost.stringValue = [NSString stringWithFormat:@"%@/%@", [data valueForKey:@"wins"], [data valueForKey:@"lost"]];
    self.place.stringValue = [NSString stringWithFormat:@"#%@", [data valueForKey: @"place"]];
    //Update background
    if([[data valueForKey:@"race"] isEqualToString:@"terran"])
    {
        [self.bg setImage:[NSImage imageNamed:@"terran.png"]];
    }
    else if([[data valueForKey:@"race"] isEqualToString:@"zerg"])
    {
        [self.bg setImage:[NSImage imageNamed:@"zerg.png"]];
    }
    else if([[data valueForKey:@"race"] isEqualToString:@"protoss"])
    {
        [self.bg setImage:[NSImage imageNamed:@"protoss.png"]];
    }
    else
    {
        [self.bg setImage:[NSImage imageNamed:@"random.png"]];
    }
    /***
     * Update leage
    ***/
    int frameX = 0, frameY = 0;
    //Select leage
    NSString* leage = [data valueForKey:@"leage"];
    if([leage  isEqual: @"Bronze"])
    {
        frameX = 1;
    }
    else if([leage  isEqual: @"Silver"])
    {
        frameX = 2;
    }
    else if([leage  isEqual: @"Gold"])
    {
        frameX = 3;
    }
    else if([leage  isEqual: @"Diamond"])
    {
        frameX = 4;
    }
    else if([leage  isEqual: @"Platinum"])
    {
        frameX = 5;
    }
    else if([leage  isEqual: @"Master"])
    {
        frameX = 6;
    }
    else if([leage  isEqual: @"Grandmaster"])
    {
        frameX = 7;
    }
    //Select leage badge
    NSInteger place = [[data valueForKey:@"place"] integerValue];
    if([leage isEqual: @"Grandmaster"])//Grandmaster is bigger devision
    {
        if(place <= 16){
            frameY = 0;
        }
        else if(place <= 50)
        {
            frameY = 1;
        }
        else if(place <= 100)
        {
            frameY = 2;
        }
        else
        {
            frameY = 3;
        }
    }
    else
    {
        if(place <= 8){
            frameY = 0;
        }
        else if(place <= 25)
        {
            frameY = 1;
        }
        else if(place <= 50)
        {
            frameY = 2;
        }
        else
        {
            frameY = 3;
        }
    }
    
    //Change frame
    CGRect theFrame = self.leageImage.frame;
    theFrame.origin.x = -105 * frameX;
    theFrame.origin.y = -105 * frameY;
    self.leageImage.frame = theFrame;
}
@end
