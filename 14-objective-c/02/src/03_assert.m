// Встроенные средства отладки: assert, NSAssert, NSParameterAssert, макросы места в коде.
//   ./03_assert        — NSAssert-ы (бросают исключения, их можно поймать)
//   ./03_assert c      — классический assert() из C: аварийно завершает программу
// Отключение: -DNDEBUG (для assert) и -DNS_BLOCK_ASSERTIONS (для NSAssert).
#import <Foundation/Foundation.h>
#include <assert.h>

// [debuglog]
#define TRACE(fmt, ...) NSLog(@"%s:%d %s " fmt, __FILE__, __LINE__, __func__, ##__VA_ARGS__)
// [/debuglog]

// [nsassert]
@interface BankAccount : NSObject
@property (nonatomic) double balance;
- (void)withdraw:(double)sum;
@end

@implementation BankAccount
- (void)withdraw:(double)sum {
    NSParameterAssert(sum > 0);                           // проверка аргумента
    NSAssert(sum <= self.balance, @"not enough money: %.2f > %.2f", sum, self.balance);
    self.balance -= sum;
}
@end
// [/nsassert]

// [cassert]
double safeSqrtArg(double x) {
    NSCAssert(x >= 0, @"negative: %f", x);   // NSCAssert — для C-функций
    return x;
}
// [/cassert]

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        TRACE(@"start, argc=%d", argc);

        if (argc > 1 && argv[1][0] == 'c') {
            // [abort]
            int *ptr = NULL;
            assert(ptr != NULL && "pointer must not be NULL");  // abort() + сообщение
            // [/abort]
        }

        // [use]
        BankAccount *acc = [BankAccount new];
        acc.balance = 100;
        [acc withdraw:30];
        NSLog(@"balance=%.0f", acc.balance);

        @try {
            [acc withdraw:500];
        } @catch (NSException *e) {
            NSLog(@"%@: %@", e.name, e.reason);
        }
        @try {
            [acc withdraw:-1];
        } @catch (NSException *e) {
            NSLog(@"%@: %@", e.name, e.reason);
        }
        // [/use]
        @try { safeSqrtArg(-4); } @catch (NSException *e) { NSLog(@"C: %@", e.reason); }
    }
    return 0;
}
