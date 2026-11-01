// Протоколы: контракты, опциональные методы, делегирование.
#import <Foundation/Foundation.h>

// [protocol]
@protocol Shape <NSObject>              // протокол наследует протокол NSObject
@required
- (double)area;
@optional
- (NSString *)name;
@end
// [/protocol]

// [conform]
@interface Square : NSObject <Shape>
@property double side;
@end
@implementation Square
- (double)area { return self.side * self.side; }
- (NSString *)name { return @"square"; }
@end

@interface Circle : NSObject <Shape, NSCopying>   // несколько протоколов
@property double r;
@end
@implementation Circle
- (double)area { return M_PI * self.r * self.r; }  // name не реализован — он @optional
- (id)copyWithZone:(NSZone *)zone { Circle *c = [Circle new]; c.r = self.r; return c; }
@end
// [/conform]

// [delegate]
// [delegateproto]
@class Downloader;
@protocol DownloaderDelegate <NSObject>
- (void)downloader:(Downloader *)d didFinishWithBytes:(NSUInteger)bytes;
@optional
- (void)downloader:(Downloader *)d progress:(double)p;
@end

@interface Downloader : NSObject
@property (nonatomic, weak) id<DownloaderDelegate> delegate;   // weak: нет цикла
- (void)start;
@end

@implementation Downloader
- (void)start {
    for (int i = 1; i <= 2; i++)
        if ([self.delegate respondsToSelector:@selector(downloader:progress:)])
            [self.delegate downloader:self progress:i / 2.0];
    [self.delegate downloader:self didFinishWithBytes:1024];
}
@end

// [/delegateproto]

// [delegateapp]
@interface App : NSObject <DownloaderDelegate>
@end
@implementation App
- (void)downloader:(Downloader *)d progress:(double)p {
    NSLog(@"progress %.0f%%", p * 100);
}
- (void)downloader:(Downloader *)d didFinishWithBytes:(NSUInteger)n {
    NSLog(@"done: %lu B", (unsigned long)n);
}
@end
// [/delegateapp]
// [/delegate]

// [poly]
double totalArea(NSArray<id<Shape>> *shapes) {     // работаем с протоколом, не с классом
    double sum = 0;
    for (id<Shape> s in shapes) sum += [s area];
    return sum;
}
// [/poly]

int main(void) {
    @autoreleasepool {
        // [use]
        Square *sq = [Square new]; sq.side = 2;
        Circle *ci = [Circle new]; ci.r = 1;
        NSArray<id<Shape>> *shapes = @[sq, ci];

        for (id<Shape> s in shapes) {
            NSString *name = [s respondsToSelector:@selector(name)] ? [s name] : @"unnamed";
            NSLog(@"%@: %.2f", name, [s area]);
        }
        NSLog(@"total=%.2f, circle conforms to NSCopying: %d", totalArea(shapes),
              [ci conformsToProtocol:@protocol(NSCopying)]);

        App *app = [App new];
        Downloader *dl = [Downloader new];
        dl.delegate = app;
        [dl start];
        // [/use]
    }
    return 0;
}
