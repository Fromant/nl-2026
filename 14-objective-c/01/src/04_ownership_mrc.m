// Ручной подсчёт ссылок (MRC). Собирается с -fno-objc-arc.
#import <Foundation/Foundation.h>

@interface Item : NSObject
@end
@implementation Item
- (void)dealloc {
    printf("Item dealloc\n");
    [super dealloc];                 // при MRC — обязательно
}
@end

int main(void) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    // [mrc]
    Item *it = [[Item alloc] init];  // alloc -> мы владеем, retainCount = 1
    [it retain];                     // ещё один владелец: 2
    printf("rc=%lu\n", (unsigned long)[it retainCount]);
    [it release];                    // 1
    [it release];                    // 0 -> dealloc
    it = nil;

    // Правило: владеем тем, что получили через alloc/new/copy/mutableCopy/retain
    NSString *s = [NSString stringWithFormat:@"%d", 5]; // не владеем (autorelease)
    Item *tmp = [[[Item alloc] init] autorelease];      // отдадим пулу
    printf("before drain: %s\n", [s UTF8String]);
    // [/mrc]
    (void)tmp;

    [pool drain];                    // здесь освобождаются autorelease-объекты
    printf("after drain\n");
    return 0;
}
