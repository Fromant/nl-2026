// [impl]
#import "GMPoint.h"

NSString *const GMGeometryVersion = @"1.0";

static double sq(double v) { return v * v; }     // static: не виден вне файла

@interface GMPoint ()                            // расширение класса = приватная часть
@property (nonatomic, readwrite) double x;
@property (nonatomic, readwrite) double y;
@end

@implementation GMPoint
+ (instancetype)pointWithX:(double)x y:(double)y {
    GMPoint *p = [[self alloc] init];
    p.x = x; p.y = y;                            // внутри модуля — можно писать
    return p;
}
- (double)distanceTo:(GMPoint *)o { return sqrt(sq(self.x - o.x) + sq(self.y - o.y)); }
- (id)copyWithZone:(NSZone *)zone { return self; }   // неизменяемый объект
- (NSString *)description { return [NSString stringWithFormat:@"(%g, %g)", self.x, self.y]; }
@end
// [/impl]
