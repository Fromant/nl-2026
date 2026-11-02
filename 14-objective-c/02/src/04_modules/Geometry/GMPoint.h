// [header]
#import <Foundation/Foundation.h>
#import "GMDefines.h"

NS_ASSUME_NONNULL_BEGIN

GM_EXPORT extern NSString *const GMGeometryVersion;   // публичная константа

GM_EXPORT
@interface GMPoint : NSObject <NSCopying>             // префикс GM вместо namespace
@property (nonatomic, readonly) double x;
@property (nonatomic, readonly) double y;
+ (instancetype)pointWithX:(double)x y:(double)y;
- (double)distanceTo:(GMPoint *)other;
@end

NS_ASSUME_NONNULL_END
// [/header]
