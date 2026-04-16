#import <UIKit/UIKit.h>
#import <objc/runtime.h>

// --- Forward Declarations ---
@interface SBAwayController : NSObject
+ (id)sharedAwayController;
- (void)unlockWithSound:(BOOL)sound;
@end

@interface SBAwayView : UIView
@end

@interface MyCustomPatternView : UIView
@property (nonatomic, retain) NSMutableArray *touchedDots;
@end

// --- Implementation ---
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
    // %c is the magic Logos way to handle objc_getClass safely
    [[%c(SBAwayController) sharedAwayController] unlockWithSound:YES];
}
@end

// --- The Hook ---
%hook SBAwayView

- (void)layoutSubviews {
    %orig;

    if (![self viewWithTag:8080]) {
        MyCustomPatternView *pv = [[MyCustomPatternView alloc] initWithFrame:self.bounds];
        [self addSubview:pv];
    }
}

%end
