// Специфика языка: отправка сообщений, nil, селекторы, динамическая типизация, KVC/KVO.
#import <Foundation/Foundation.h>

@interface Robot : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSInteger battery;
- (NSString *)greet:(NSString *)who;
@end
@implementation Robot
- (NSString *)greet:(NSString *)who { return [NSString stringWithFormat:@"%@ greets %@", _name, who]; }
@end

// [kvoobs]
@interface Monitor : NSObject
@end
@implementation Monitor
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)obj
                        change:(NSDictionary *)change context:(void *)ctx {
    NSLog(@"KVO: %@ %@ -> %@", keyPath, change[NSKeyValueChangeOldKey],
          change[NSKeyValueChangeNewKey]);
}
@end
// [/kvoobs]

int main(void) {
    @autoreleasepool {
        // [nil]
        Robot *nobody = nil;
        NSString *r = [nobody greet:@"you"];    // сообщение nil — не ошибка: вернёт nil/0
        NSInteger b = nobody.battery;
        NSLog(@"nil result: %@, %ld", r, (long)b);
        // [/nil]

        // [selector]
        Robot *robo = [Robot new];
        robo.name = @"R2";
        SEL sel = NSSelectorFromString(@"greet:");             // имя метода как данные
        if ([robo respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"   // ARC не знает, что вернёт sel
            NSString *res = [robo performSelector:sel withObject:@"C3PO"];
#pragma clang diagnostic pop
            NSLog(@"%@", res);
        }
        id any = robo;                                          // динамическая типизация:
        NSLog(@"%@", [any greet:@"id"]);                        // проверка — в рантайме
        @try { [any count]; } @catch (NSException *e) { NSLog(@"%@", e.reason); }
        // [/selector]

        // [invocation]
        NSMethodSignature *sig = [robo methodSignatureForSelector:@selector(greet:)];
        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
        inv.target = robo;
        inv.selector = @selector(greet:);
        NSString *arg = @"invocation";
        [inv setArgument:&arg atIndex:2];                       // 0 = self, 1 = _cmd
        [inv invoke];                                           // вызов-как-объект
        __unsafe_unretained NSString *ret;
        [inv getReturnValue:&ret];
        NSLog(@"%@", ret);
        // [/invocation]

        // [kvc]
        [robo setValue:@"BB-8" forKey:@"name"];                 // доступ по строковому ключу
        [robo setValue:@(87) forKey:@"battery"];                // автоупаковка NSNumber
        NSLog(@"KVC: %@ %@", [robo valueForKey:@"name"], [robo valueForKey:@"battery"]);
        // [/kvc]

        // [kvo]
        Monitor *mon = [Monitor new];
        [robo addObserver:mon forKeyPath:@"battery"
                  options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                  context:NULL];
        robo.battery = 50;                                      // наблюдатель узнает сам
        robo.battery = 10;
        [robo removeObserver:mon forKeyPath:@"battery"];
        // [/kvo]
    }
    return 0;
}
