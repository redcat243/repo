#import <UIKit/UIKit.h>

// Declarations for the compiler
@interface SBAwayController : NSObject
+ (id)sharedAwayController;
- (void)unlockWithSound:(BOOL)sound;
@end

@interface MyCustomPatternView : UIView
@property (nonatomic, retain) NSMutableArray *touchedDots;
@end

@implementation MyCustomPatternView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.tag = 8080;
        self.touchedDots = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // Basic logic: Any touch ends = unlock (for testing)
    // You can add your 1-2-3 pattern logic back here later!
    [[objc_getClass("SBAwayController") sharedAwayController] unlockWithSound:YES];
}
@end

// The actual Hook
%hook SBAwayView
- (void)layoutSubviews {
    %orig;
    if (![self viewWithTag:8080]) {
        MyCustomPatternView *pv = [[MyCustomPatternView alloc] initWithFrame:self.bounds];
        [self addSubview:pv];
    }
}
%end
