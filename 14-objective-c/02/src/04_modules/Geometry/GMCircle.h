// [header]
#import <Foundation/Foundation.h>
#import "GMDefines.h"

@class GMPoint;                 // предварительное объявление вместо #import

GM_EXPORT
@interface GMCircle : NSObject
@property (nonatomic, strong, readonly) GMPoint *center;
@property (nonatomic, readonly) double radius;
- (instancetype)initWithCenter:(GMPoint *)center radius:(double)radius;
- (double)area;
- (BOOL)containsPoint:(GMPoint *)point;
@end
// [/header]
