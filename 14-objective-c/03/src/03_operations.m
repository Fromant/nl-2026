// NSOperationQueue: высокоуровневые задачи с зависимостями.
#import <Foundation/Foundation.h>

int main(void) {
    @autoreleasepool {
        // [ops]
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.maxConcurrentOperationCount = 2;                  // ограничение параллелизма

        NSBlockOperation *download = [NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"download");
        }];
        NSBlockOperation *parse = [NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"parse");
        }];
        NSBlockOperation *save = [NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"save");
        }];
        [parse addDependency:download];                         // граф зависимостей
        [save addDependency:parse];

        [queue addOperations:@[save, parse, download] waitUntilFinished:YES];
        NSLog(@"pipeline done");
        // [/ops]

        // [cancel]
        NSBlockOperation *slow = [NSBlockOperation new];
        __weak NSBlockOperation *weakSlow = slow;
        [slow addExecutionBlock:^{
            for (int i = 0; i < 100; i++) {
                if (weakSlow.isCancelled) { NSLog(@"cancelled at step %d", i); return; }
                usleep(10000);
            }
        }];
        [queue addOperation:slow];
        usleep(50000);
        [slow cancel];                                          // кооперативная отмена
        [queue waitUntilAllOperationsAreFinished];
        // [/cancel]
    }
    return 0;
}
