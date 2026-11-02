// Типы данных и операции над ними.
#import <Foundation/Foundation.h>

int main(void) {
    @autoreleasepool {
        // [primitives]
        char       c   = 'A';
        int        i   = 42;
        long long  big = 9000000000LL;
        float      f   = 3.14f;
        double     d   = 2.718281828;
        BOOL       ok  = YES;          // YES/NO; на x86-64 Linux = signed char
        NSInteger  ni  = -7;           // long на 64-битных платформах
        NSUInteger nu  = 7;            // unsigned long
        CGFloat    cg  = 1.5;          // double на 64 бит

        printf("%c %d %lld %.2f %.3f %d %ld %lu %.1f\n",
               c, i, big, f, d, ok, (long)ni, (unsigned long)nu, cg);
        printf("sizeof: int=%zu long=%zu NSInteger=%zu BOOL=%zu id=%zu\n",
               sizeof(int), sizeof(long), sizeof(NSInteger), sizeof(BOOL), sizeof(id));
        // [/primitives]

        // [objects]
        NSString     *s    = @"Objective-C";               // строковый литерал
        NSNumber     *n    = @42;                          // «упакованное» число
        NSNumber     *flag = @YES;
        NSArray      *arr  = @[@1, @"two", @3.0];          // разнотипный массив
        NSDictionary *dict = @{@"lang": s, @"year": @1984};
        id    anything = s;            // id — указатель на любой объект
        anything = n;                  // ... можно переприсвоить объект другого класса
        Class cls  = [s class];        // класс — тоже объект
        SEL   sel  = @selector(length);// селектор — «имя метода»

        NSLog(@"%@ %@ %@ %@ year=%@", n, flag, arr[1], dict[@"lang"], dict[@"year"]);
        NSLog(@"anything=%@ class=%@ selector=%@",
              anything, cls, NSStringFromSelector(sel));
        // [/objects]

        // [ops]
        int a = 17, b = 5;
        printf("%d %d %d %d %d\n", a + b, a - b, a * b, a / b, a % b); // целочисленное деление
        printf("%.2f\n", (double)a / b);
        printf("and=%d or=%d xor=%d shl=%d shr=%d not=%d\n",
               a & b, a | b, a ^ b, a << 2, a >> 1, ~a);
        printf("logic: %d %d %d\n", a > b && b > 0, !(a == b), a != b);

        unsigned char byte = 255;
        byte++;                                   // переполнение беззнакового: 0
        int x = 5;
        x += 3; x *= 2; x--;                      // составные операции
        printf("byte=%u x=%d\n", byte, x);
        // [/ops]

        // [strings]
        NSString *hello = @"Hello";
        NSString *full  = [hello stringByAppendingString:@", world"];
        NSLog(@"%@ | len=%lu | upper=%@", full, (unsigned long)full.length,
              [full uppercaseString]);
        NSLog(@"hasPrefix=%d  find 'world' at %lu", [full hasPrefix:@"Hell"],
              (unsigned long)[full rangeOfString:@"world"].location);

        NSString *copy = [NSString stringWithFormat:@"%@", hello];
        NSLog(@"isEqual=%d  ==%d", [hello isEqualToString:copy], hello == copy);

        NSMutableString *ms = [NSMutableString stringWithString:@"abc"];
        [ms appendString:@"def"];
        [ms insertString:@"-" atIndex:3];
        NSLog(@"mutable: %@", ms);
        // [/strings]

        // [numbers]
        NSNumber *p = @10, *q = @3;
        NSNumber *sum = @(p.intValue + q.intValue);  // у NSNumber нет оператора +
        NSLog(@"sum=%@ compare=%ld equal=%d", sum, (long)[p compare:q],
              [p isEqualToNumber:@10]);
        // [/numbers]
    }
    return 0;
}
