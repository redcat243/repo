#import <Foundation/Foundation.h>
#include <objc/runtime.h>
#include <objc/message.h>

// Substrate definition
#ifdef __cplusplus
extern "C" {
#endif
    void MSHookMessageEx(Class _class, SEL sel, IMP imp, IMP *result);
#ifdef __cplusplus
}
#endif

// Helper to send messages without UIKit headers
#define msg ((id (*)(id, SEL, ...))objc_msgSend)

// Geometry structs (since we can't find CoreGraphics)
typedef struct { double x; double y; } MyPoint;
typedef struct { double w; double h; } MySize;
typedef struct { MyPoint o; MySize s; } MyRect;

@interface MyCustomPatternView : NSObject {
    id _touchedDots;
}
@property (nonatomic, retain) id touchedDots;
@end

@implementation MyCustomPatternView
@synthesize touchedDots = _touchedDots;

- (id)init {
    self = [super init];
    if (self) {
        _touchedDots = [msg(objc_getClass("NSMutableArray"), sel_registerName("alloc")) init];
    }
    return self;
}

- (void)touchesEnded:(id)touches withEvent:(id)event {
    id controller = msg(objc_getClass("SBAwayController"), sel_registerName("sharedAwayController"));
    ((void (*)(id, SEL, BOOL))objc_msgSend)(controller, sel_registerName("unlockWithSound:"), YES);
}
@end

static void (*orig_layoutSubviews)(id, SEL);
void hooked_layoutSubviews(id self, SEL _cmd) {
    orig_layoutSubviews(self, _cmd);
    
    if (!msg(self, sel_registerName("viewWithTag:"), 8080)) {
        MyCustomPatternView *pv = [[MyCustomPatternView alloc] init];
        ((void (*)(id, SEL, long))objc_msgSend)(pv, sel_registerName("setTag:"), 8080);
        msg(self, sel_registerName("addSubview:"), pv);
    }
}

__attribute__((constructor)) static void init() {
    Class target = objc_getClass("SBAwayView");
    if (target) {
        MSHookMessageEx(target, sel_registerName("layoutSubviews"), (IMP)hooked_layoutSubviews, (IMP *)&orig_layoutSubviews);
    }
}