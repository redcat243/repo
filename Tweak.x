#import <UIKit/UIKit.h>
#import <objc/runtime.h>

extern "C" id objc_getClass(const char *name);

@interface SBAwayView : UIView
// Defining this as a UIView fixes the "property 'bounds' cannot be found" error
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
    // %c() is the Logos way to get a Class. It's better than objc_getClass here.
    [[objc_getClass("SBAwayController") performSelector:@selector(sharedAwayController)] performSelector:@selector(unlockWithSound:) withObject:(id)YES];
}
@end

// --- The Hook ---
%hook SBAwayView

- (void)layoutSubviews {
    %orig;

    // Now that we told the compiler SBAwayView is a UIView, self.bounds works!
    if (![self viewWithTag:8080]) {
        MyCustomPatternView *pv = [[MyCustomPatternView alloc] initWithFrame:self.bounds];
        [self addSubview:pv];
    }
}

%end
