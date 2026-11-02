// Рекурсия: функции, методы, мемоизация, рекурсивный блок.
#import <Foundation/Foundation.h>

// [cfact]
unsigned long long factorial(unsigned n) {
    return n <= 1 ? 1 : n * factorial(n - 1);
}

void hanoi(int n, char from, char to, char via, int *moves) {
    if (n == 0) return;
    hanoi(n - 1, from, via, to, moves);
    (*moves)++;                                // переносим диск n: from -> to
    hanoi(n - 1, via, to, from, moves);
}
// [/cfact]

// [memo]
@interface Fib : NSObject
- (NSNumber *)fib:(NSUInteger)n;
@end

@implementation Fib {
    NSMutableDictionary<NSNumber *, NSNumber *> *_cache;
}
- (instancetype)init {
    if ((self = [super init])) _cache = [NSMutableDictionary dictionary];
    return self;
}
- (NSNumber *)fib:(NSUInteger)n {
    if (n < 2) return @(n);
    NSNumber *hit = _cache[@(n)];
    if (hit) return hit;                       // уже считали
    NSNumber *r = @([self fib:n - 1].unsignedLongLongValue +
                    [self fib:n - 2].unsignedLongLongValue);
    _cache[@(n)] = r;
    return r;
}
@end
// [/memo]

int main(void) {
    @autoreleasepool {
        int moves = 0;
        hanoi(10, 'A', 'C', 'B', &moves);
        printf("20! = %llu, hanoi(10) moves = %d\n", factorial(20), moves);
        NSLog(@"fib(90) = %@", [[Fib new] fib:90]);

        // [block]
        // Рекурсивный блок: ссылка на самого себя через __block + __weak,
        // иначе блок захватит сам себя сильной ссылкой (цикл удержания).
        __block __weak unsigned long (^weakGcd)(unsigned long, unsigned long);
        unsigned long (^gcd)(unsigned long, unsigned long) =
            ^unsigned long(unsigned long a, unsigned long b) {
                return b == 0 ? a : weakGcd(b, a % b);
            };
        weakGcd = gcd;
        NSLog(@"gcd(1071, 462) = %lu", gcd(1071, 462));
        // [/block]
    }
    return 0;
}
