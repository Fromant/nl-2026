// [main]
#import <Foundation/Foundation.h>
#import "Geometry.h"            // #import = #include, но не больше одного раза

int main(void) {
    @autoreleasepool {
        GMPoint  *a = [GMPoint pointWithX:0 y:0];
        GMPoint  *b = [GMPoint pointWithX:3 y:4];
        GMCircle *c = [[GMCircle alloc] initWithCenter:a radius:5];

        NSLog(@"Geometry v%@", GMGeometryVersion);
        NSLog(@"|%@ - %@| = %.1f", a, b, [a distanceTo:b]);
        NSLog(@"area=%.2f contains b: %d", [c area], [c containsPoint:b]);
        // b.x = 10;            // ошибка: свойство readonly снаружи модуля
    }
    return 0;
}
// [/main]
