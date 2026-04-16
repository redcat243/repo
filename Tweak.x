#import <UIKit/UIKit.h>
#import <objc/runtime.h>

// 1. Tell the compiler exactly what these classes can do
@interface SBAwayController : NSObject
+ (id)sharedAwayController;
- (void)unlockWithSound:(BOOL)sound;
@end

// 2. We define SBAwayView as a UIView so the compiler knows it has '.bounds'
@interface SBAwayView : UIView
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
    // We use %c() instead of objc_getClass because it is the "Theos way" 
    // and avoids the "undeclared function" error.
    [[%c(SBAwayController) sharedAwayController] unlockWithSound:YES];
}
@end

// --- The Actual Hook ---
%hook SBAwayView
- (void)layoutSubviews {
    %orig;
    
    if (![self viewWithTag:8080]) {
        // Since we declared SBAwayView as a UIView above, 
        // 'self.bounds' will now work perfectly!
        MyCustomPatternView *pv = [[MyCustomPatternView alloc] initWithFrame:self.bounds];
        [self addSubview:pv];
    }
}
%end
