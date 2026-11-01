// Функции и методы: входные и выходные данные.
#import <Foundation/Foundation.h>
#include <stdarg.h>

// [cfunc]
int add(int a, int b) { return a + b; }              // передача по значению

void swap(int *a, int *b) {                          // выходные параметры через указатели
    int t = *a; *a = *b; *b = t;
}

typedef struct { int min; int max; } MinMax;          // «несколько результатов» = struct
MinMax minmax(const int *arr, size_t n) {
    MinMax r = { arr[0], arr[0] };
    for (size_t k = 1; k < n; k++) {
        if (arr[k] < r.min) r.min = arr[k];
        if (arr[k] > r.max) r.max = arr[k];
    }
    return r;
}
// [/cfunc]

// [varargs]
double average(int count, ...) {                     // переменное число аргументов
    va_list ap;
    va_start(ap, count);
    double sum = 0;
    for (int k = 0; k < count; k++) sum += va_arg(ap, int);
    va_end(ap);
    return count ? sum / count : 0;
}
// [/varargs]

// [methods]
@interface Calc : NSObject
+ (NSInteger)sumOf:(NSInteger)a and:(NSInteger)b;            // метод класса (+)
- (double)power:(double)base exponent:(int)e;                // метод экземпляра (-)
- (BOOL)divide:(double)a by:(double)b
        result:(double *)result error:(NSError **)error;     // результат + ошибка
- (NSDictionary *)statsFor:(NSArray<NSNumber *> *)values;    // объект-«кортеж»
@end
// [/methods]

@implementation Calc
+ (NSInteger)sumOf:(NSInteger)a and:(NSInteger)b { return a + b; }

- (double)power:(double)base exponent:(int)e {
    double r = 1;
    for (int k = 0; k < e; k++) r *= base;
    return r;
}

// [divide]
- (BOOL)divide:(double)a by:(double)b result:(double *)result error:(NSError **)error {
    if (b == 0) {
        if (error) {
            *error = [NSError errorWithDomain:@"CalcDomain" code:1
                       userInfo:@{NSLocalizedDescriptionKey: @"division by zero"}];
        }
        return NO;
    }
    if (result) *result = a / b;
    return YES;
}
// [/divide]

- (NSDictionary *)statsFor:(NSArray<NSNumber *> *)values {
    double sum = 0;
    for (NSNumber *v in values) sum += v.doubleValue;
    return @{@"count": @(values.count), @"sum": @(sum)};
}
@end

int main(void) {
    @autoreleasepool {
        // [ccall]
        int x = 1, y = 2;
        swap(&x, &y);
        int data[] = {4, -2, 9, 0};
        MinMax mm = minmax(data, 4);
        printf("add=%d swap: x=%d y=%d min=%d max=%d avg=%.2f\n",
               add(2, 3), x, y, mm.min, mm.max, average(3, 1, 2, 4));
        // [/ccall]

        // [mcall]
        Calc *calc = [[Calc alloc] init];
        NSLog(@"sum=%ld pow=%.0f", (long)[Calc sumOf:2 and:3],
              [calc power:2 exponent:10]);

        double q = 0;
        NSError *err = nil;
        if ([calc divide:1 by:4 result:&q error:&err]) NSLog(@"1/4=%.2f", q);
        if (![calc divide:1 by:0 result:&q error:&err])
            NSLog(@"error: %@ (code %ld)", err.localizedDescription, (long)err.code);

        NSDictionary *st = [calc statsFor:@[@1, @2, @3.5]];
        NSLog(@"count=%@ sum=%@", st[@"count"], st[@"sum"]);
        // [/mcall]
    }
    return 0;
}
