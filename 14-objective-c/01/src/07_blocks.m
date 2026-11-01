// Замыкания: блоки (blocks) — расширение clang для C/Objective-C.
#import <Foundation/Foundation.h>

// [factory]
typedef NSInteger (^Counter)(void);

Counter makeCounter(NSInteger start, NSInteger step) {
    __block NSInteger value = start;     // переменная переживёт вызов функции
    return ^NSInteger {
        NSInteger current = value;
        value += step;
        return current;
    };
}
// [/factory]

// [hof]
NSArray *map(NSArray *src, id (^f)(id)) {              // блок как параметр
    NSMutableArray *out = [NSMutableArray arrayWithCapacity:src.count];
    for (id x in src) [out addObject:f(x)];
    return out;
}
// [/hof]

int main(void) {
    @autoreleasepool {
        // [syntax]
        int (^square)(int) = ^int(int x) { return x * x; };   // тип ^(аргументы)
        typedef NSString *(^Formatter)(NSString *);
        Formatter shout = ^(NSString *s) {                    // тип результата выводится
            return [s.uppercaseString stringByAppendingString:@"!"];
        };
        void (^hello)(void) = ^{ NSLog(@"no args, no result"); };
        hello();
        NSLog(@"%d %@", square(7), shout(@"blocks"));
        // [/syntax]

        // [capture]
        int base = 10;
        int (^addBase)(int) = ^(int x) { return x + base; };  // захват ПО ЗНАЧЕНИЮ
        base = 100;
        printf("addBase(1) = %d\n", addBase(1));               // 11, не 101

        __block int counter = 0;                               // захват ПО ССЫЛКЕ
        void (^inc)(void) = ^{ counter++; };
        inc(); inc(); inc();
        printf("counter = %d\n", counter);                     // 3

        NSMutableArray *log = [NSMutableArray array];          // объект захвачен strong-ссылкой,
        void (^logIt)(NSString *) = ^(NSString *m) { [log addObject:m]; }; // менять его можно
        logIt(@"a"); logIt(@"b");
        NSLog(@"log = %@", [log componentsJoinedByString:@","]);
        // [/capture]

        // [use]
        // [usecounter]
        Counter byTwo = makeCounter(0, 2), byTen = makeCounter(100, 10);
        NSInteger a = byTwo(), b = byTwo(), c = byTwo();
        NSLog(@"%ld %ld %ld | %ld", (long)a, (long)b, (long)c, (long)byTen());
        // [/usecounter]

        // [usemap]
        NSArray *words = map(@[@"one", @"two"], ^id(id w) { return [w capitalizedString]; });
        NSLog(@"%@", [words componentsJoinedByString:@" "]);
        // [/usemap]
        // [/use]
    }
    return 0;
}
