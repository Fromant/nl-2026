// Что ARC делает за нас: сеттер свойства и dealloc при ручном управлении (MRC).
// Собирается с -fno-objc-arc.
#import <Foundation/Foundation.h>

// [setter]
@interface Box : NSObject {
    NSString *_label;
}
- (void)setLabel:(NSString *)label;
- (NSString *)label;
@end

@implementation Box
- (void)setLabel:(NSString *)label {
    if (_label != label) {
        [label retain];                 // сначала захватить новое значение
        [_label release];               // потом отпустить старое
        _label = label;
    }
}
- (NSString *)label { return [[_label retain] autorelease]; }
- (void)dealloc {
    printf("Box dealloc, releasing label\n");
    [_label release];                   // освободить всё, чем владеем
    [super dealloc];
}
@end
// [/setter]

int main(void) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    // [use]
    Box *box = [[Box alloc] init];
    NSString *s = [[NSString alloc] initWithFormat:@"label-%d", 1];
    box.label = s;
    printf("retainCount(s) = %lu\n", (unsigned long)[s retainCount]);   // 2: мы + box
    [s release];
    [box release];                      // -> dealloc -> release label
    // [/use]
    [pool drain];
    return 0;
}
