// Области видимости.
#import <Foundation/Foundation.h>

// [globals]
int        globalCounter = 0;  // глобальная: доступна из других .m через extern
static int fileCounter   = 0;  // static на уровне файла: видна только в этом .m

void tick(void) {
    static int calls = 0;      // static внутри функции: живёт всю программу,
    calls++;                   // но видна только здесь
    fileCounter++;
    globalCounter++;
    printf("calls=%d file=%d global=%d\n", calls, fileCounter, globalCounter);
}
// [/globals]

// [ivars]
@interface Account : NSObject {
@public    NSString *owner;    // доступно всем через ->
@protected double    balance;  // по умолчанию: класс и наследники
@private   NSString *pin;      // только этот класс
}
- (void)deposit:(double)sum;
@end

@implementation Account
- (void)deposit:(double)sum {
    balance += sum;            // ivar виден внутри методов без self->
    pin = @"0000";
    NSLog(@"%@: balance=%.0f", owner, balance);
}
@end
// [/ivars]

int main(void) {
    @autoreleasepool {
        tick(); tick();

        // [blocks]
        int x = 1;
        {
            int x = 2;                       // затеняет внешнюю x
            printf("inner x=%d\n", x);
        }
        printf("outer x=%d\n", x);

        for (int k = 0; k < 3; k++) {        // k существует только в цикле
            int sq = k * k;
            if (k == 2) printf("last sq=%d\n", sq);
        }
        // printf("%d", k);                  // ошибка: use of undeclared identifier 'k'
        // [/blocks]

        // [ivaruse]
        Account *acc = [Account new];
        acc->owner = @"Ilya";                // @public — можно
        [acc deposit:100];
        // acc->pin = @"1234";
        // ^ ошибка: instance variable 'pin' is private
        // [/ivaruse]
    }
    return 0;
}
