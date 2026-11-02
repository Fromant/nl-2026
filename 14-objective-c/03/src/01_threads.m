// Потоки NSThread и синхронизация: гонка данных, @synchronized, NSLock, NSCondition.
#import <Foundation/Foundation.h>

static const int kThreads = 4, kIters = 200000;

// [race]
@interface Counter : NSObject
@property (nonatomic) long unsafeValue;            // nonatomic — без защиты
@property (nonatomic) long syncValue;
@property (nonatomic) long lockValue;
@end
@implementation Counter {
    NSLock *_lock;
}
- (instancetype)init { if ((self = [super init])) _lock = [NSLock new]; return self; }

- (void)work {
    for (int i = 0; i < kIters; i++) {
        self.unsafeValue++;                           // read-modify-write: гонка!
        @synchronized (self) { self.syncValue++; }    // монитор на объекте
        [_lock lock];  self.lockValue++;  [_lock unlock];
    }
}
@end
// [/race]

int main(void) {
    @autoreleasepool {
        // [threads]
        Counter *c = [Counter new];
        NSMutableArray<NSThread *> *threads = [NSMutableArray array];
        for (int t = 0; t < kThreads; t++) {
            NSThread *th = [[NSThread alloc] initWithTarget:c selector:@selector(work) object:nil];
            [threads addObject:th];
            [th start];
        }
        for (NSThread *th in threads)                 // простое ожидание завершения
            while (!th.isFinished) [NSThread sleepForTimeInterval:0.01];

        NSLog(@"expected %d", kThreads * kIters);
        NSLog(@"unsafe=%ld sync=%ld lock=%ld", c.unsafeValue, c.syncValue, c.lockValue);
        // [/threads]

        // [condition]
        NSCondition *cond = [NSCondition new];
        NSMutableArray *queue = [NSMutableArray array];

        [NSThread detachNewThreadWithBlock:^{             // производитель
            for (int i = 1; i <= 3; i++) {
                [cond lock];
                [queue addObject:@(i)];
                [cond signal];                            // разбудить потребителя
                [cond unlock];
            }
        }];

        for (int got = 0; got < 3; got++) {               // потребитель (главный поток)
            [cond lock];
            while (queue.count == 0) [cond wait];         // ждём, отпуская мьютекс
            NSNumber *item = queue.firstObject;
            [queue removeObjectAtIndex:0];
            [cond unlock];
            NSLog(@"consumed %@", item);
        }
        // [/condition]
    }
    return 0;
}
