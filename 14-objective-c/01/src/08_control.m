// Условные конструкции и циклы.
#import <Foundation/Foundation.h>

// [enum]
typedef NS_ENUM(NSInteger, Weekday) {   // типизированное перечисление
    WeekdayMon = 1, WeekdayTue, WeekdayWed, WeekdayThu, WeekdayFri,
    WeekdaySat, WeekdaySun
};
// [/enum]

NSString *describe(Weekday d) {
    // [switch]
    switch (d) {
        case WeekdaySat:
        case WeekdaySun:                 // «проваливание» (fallthrough) без break
            return @"weekend";
        case WeekdayFri:
            return @"almost weekend";
        default:
            return @"workday";
    }
    // [/switch]
}

int main(void) {
    @autoreleasepool {
        // [if]
        int t = 23;
        if (t < 0) {
            NSLog(@"freezing");
        } else if (t < 20) {
            NSLog(@"cool");
        } else {
            NSLog(@"warm");
        }
        NSString *kind  = (t % 2 == 0) ? @"even" : @"odd";   // тернарный оператор
        NSString *name  = nil;
        NSString *shown = name ?: @"anonymous";            // GNU-расширение «?:»
        NSLog(@"%@ %@ | %@ | %@", kind, shown, describe(WeekdaySun), describe(WeekdayTue));
        if (name == nil && !name) NSLog(@"nil is false");    // nil, 0, NO — «ложь»
        // [/if]

        // [loops]
        for (int i = 0; i < 5; i++) {         // классический for
            if (i == 1) continue;             // пропустить итерацию
            if (i == 4) break;                // выйти из цикла
            printf("for i=%d\n", i);
        }

        int n = 3;
        while (n > 0) printf("while n=%d\n", n--);

        int attempts = 0;
        do {                                  // тело выполнится хотя бы раз
            attempts++;
        } while (attempts < 0);
        printf("do-while attempts=%d\n", attempts);
        // [/loops]
    }
    return 0;
}
