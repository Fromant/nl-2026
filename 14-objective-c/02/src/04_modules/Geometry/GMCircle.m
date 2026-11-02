#import "GMCircle.h"
#import "GMPoint.h"             // а здесь нужен полный интерфейс

@implementation GMCircle
- (instancetype)initWithCenter:(GMPoint *)center radius:(double)radius {
    if ((self = [super init])) { _center = center; _radius = radius; }
    return self;
}
- (double)area { return M_PI * _radius * _radius; }
- (BOOL)containsPoint:(GMPoint *)point { return [_center distanceTo:point] <= _radius; }
@end
