// Grand Central Dispatch (libdispatch): очереди, группы, dispatch_apply, семафоры, барьеры.
#import <Foundation/Foundation.h>
#include <dispatch/dispatch.h>

// [once]
@interface Config : NSObject
+ (instancetype)shared;
@end
@implementation Config
+ (instancetype)shared {                       // потокобезопасный синглтон
    static Config *instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ instance = [Config new]; NSLog(@"Config created once"); });
    return instance;
}
@end
// [/once]

int main(void) {
    @autoreleasepool {
        // [group]
        dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_t group = dispatch_group_create();
        __block long a = 0, b = 0;

        dispatch_group_async(group, global, ^{ for (long i = 1; i <= 1000; i++) a += i; });
        dispatch_group_async(group, global, ^{ for (long i = 1; i <= 2000; i++) b += i; });

        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);     // join
        NSLog(@"a=%ld b=%ld", a, b);
        // [/group]

        // [apply]
        const size_t N = 8;
        long *partial = calloc(N, sizeof(long));
        dispatch_apply(N, global, ^(size_t chunk) {            // параллельный for
            for (long i = (long)chunk * 1000000; i < (long)(chunk + 1) * 1000000; i++)
                partial[chunk] += i % 7;
        });
        long total = 0;
        for (size_t k = 0; k < N; k++) total += partial[k];
        free(partial);
        NSLog(@"dispatch_apply total=%ld", total);
        // [/apply]

        // [serial]
        dispatch_queue_t serial = dispatch_queue_create("demo.serial", DISPATCH_QUEUE_SERIAL);
        NSMutableArray *log = [NSMutableArray array];          // доступ только через очередь
        dispatch_apply(5, global, ^(size_t i) {
            dispatch_sync(serial, ^{ [log addObject:@(i)]; });  // без гонки
        });
        NSLog(@"serial queue: %lu items", (unsigned long)log.count);
        // [/serial]

        // [barrier]
        dispatch_queue_t rw = dispatch_queue_create("demo.rw", DISPATCH_QUEUE_CONCURRENT);
        NSMutableDictionary *cache = [NSMutableDictionary dictionary];
        dispatch_barrier_async(rw, ^{ cache[@"k"] = @"v"; });  // запись — эксклюзивно
        __block id value;
        dispatch_sync(rw, ^{ value = cache[@"k"]; });           // чтения — параллельно
        NSLog(@"read after barrier: %@", value);
        // [/barrier]

        // [sema]
        dispatch_semaphore_t slots = dispatch_semaphore_create(2);   // не более 2 одновременно
        dispatch_group_t g2 = dispatch_group_create();
        __block int active = 0, peak = 0;
        dispatch_queue_t guard = dispatch_queue_create("demo.guard", DISPATCH_QUEUE_SERIAL);
        for (int i = 0; i < 6; i++) {
            dispatch_group_async(g2, global, ^{
                dispatch_semaphore_wait(slots, DISPATCH_TIME_FOREVER);
                dispatch_sync(guard, ^{ active++; if (active > peak) peak = active; });
                usleep(20000);
                dispatch_sync(guard, ^{ active--; });
                dispatch_semaphore_signal(slots);
            });
        }
        dispatch_group_wait(g2, DISPATCH_TIME_FOREVER);
        NSLog(@"peak concurrency = %d", peak);
        // [/sema]

        [Config shared]; [Config shared];
    }
    return 0;
}
