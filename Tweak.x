#import <UIKit/UIKit.h>

// Path where we save the pattern
#define kSettingsPath @"/var/mobile/Library/Preferences/com.redcat243.androidpattern.plist"

// States
static NSString *savedPattern = nil;
static NSString *firstDraw = nil;
static BOOL isConfirming = NO;

%hook SBLockScreenViewController // Or the specific iOS 6 view controller you are using

- (void)viewDidLoad {
    %orig;
    
    // Load existing pattern if it exists
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:kSettingsPath];
    savedPattern = [dict objectForKey:@"Pattern"];
    
    if (!savedPattern) {
        // STATE 0: No pattern set
        // Set your UI text to: "Draw a pattern to start"
    }
}

// This is a pseudo-function representing when the user finishes a gesture
- (void)onPatternCompleted:(NSString *)drawnPattern {
    
    if (!savedPattern) {
        if (!isConfirming) {
            // STATE 1: First draw finished
            firstDraw = [drawnPattern copy];
            isConfirming = YES;
            // Update UI: "Draw again to confirm"
        } else {
            // STATE 2: Checking confirmation
            if ([drawnPattern isEqualToString:firstDraw]) {
                // MATCH! Save it.
                NSMutableDictionary *saveDict = [NSMutableDictionary dictionary];
                [saveDict setObject:drawnPattern forKey:@"Pattern"];
                [saveDict writeToFile:kSettingsPath atomically:YES];
                
                savedPattern = [drawnPattern copy];
                isConfirming = NO;
                // Update UI: "Pattern Saved!"
                // Unlock the device
            } else {
                // MISMATCH! Reset.
                isConfirming = NO;
                firstDraw = nil;
                // Update UI: "Didn't match. Try again."
            }
        }
    } else {
        // STATE 3: Normal Mode
        if ([drawnPattern isEqualToString:savedPattern]) {
            // Unlock device
        } else {
            // "Wrong Pattern"
        }
    }
}
%end