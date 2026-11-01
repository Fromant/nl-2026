// Преобразование и приведение типов.
#import <Foundation/Foundation.h>

int main(void) {
    @autoreleasepool {
        // [implicit]
        int      i  = 7;
        double   d  = i;            // неявное расширение int -> double
        double   pi = 3.99;
        int      t  = (int)pi;      // явное приведение: дробная часть отбрасывается
        int      big = 300;
        char     c  = (char)big;    // сужение: 300 mod 256 = 44
        unsigned u  = (unsigned)-1; // 4294967295
        printf("d=%.1f t=%d c=%d u=%u\n", d, t, c, u);
        printf("7/2=%d  (double)7/2=%.1f\n", 7 / 2, (double)7 / 2);
        // [/implicit]

        // [boxing]
        NSNumber *boxed = @(i);                 // упаковка C-значения в объект
        NSNumber *expr  = @(pi * 2);
        int    back  = boxed.intValue;          // распаковка
        double back2 = [expr doubleValue];

        int       parsed = [@"123" intValue];   // строка -> число
        double    dd     = [@"2.5" doubleValue];
        NSInteger bad    = [@"abc" integerValue]; // 0, без всякой ошибки!
        NSString *s1 = [NSString stringWithFormat:@"%d", 42];  // число -> строка
        NSString *s2 = boxed.stringValue;
        NSLog(@"%d %.2f %d %.1f %ld '%@' '%@'", back, back2, parsed, dd, (long)bad, s1, s2);
        // [/boxing]

        // [objcast]
        id obj = @"I am a string";

        if ([obj isKindOfClass:[NSString class]]) {      // проверка во время выполнения
            NSString *str = (NSString *)obj;             // приведение — только для компилятора
            NSLog(@"length=%lu", (unsigned long)str.length);
        }

        NSArray *wrong = (NSArray *)obj;   // компилятор поверит на слово...
        @try {
            NSLog(@"count=%lu", (unsigned long)[wrong count]);
        } @catch (NSException *e) {
            NSLog(@"runtime: %@", e.name);  // ...а рантайм — нет
        }
        // [/objcast]
    }
    return 0;
}
