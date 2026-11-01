// Категории и расширения классов: добавляем методы в чужие классы без наследования.
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

// [category]
@interface NSString (Demo)                     // категория Demo для системного NSString
- (NSString *)reversed;
- (BOOL)isPalindrome;
@end

@implementation NSString (Demo)
- (NSString *)reversed {
    NSMutableString *r = [NSMutableString stringWithCapacity:self.length];
    for (NSInteger i = (NSInteger)self.length - 1; i >= 0; i--)
        [r appendFormat:@"%C", [self characterAtIndex:(NSUInteger)i]];
    return r;
}
- (BOOL)isPalindrome {
    NSString *clean = [[self lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [clean isEqualToString:[clean reversed]];
}
@end
// [/category]

// [assoc]
@interface NSObject (Tag)
@property (nonatomic, copy) NSString *tag;     // в категории нельзя добавить ivar...
@end

@implementation NSObject (Tag)
static char kTagKey;
- (NSString *)tag { return objc_getAssociatedObject(self, &kTagKey); }
- (void)setTag:(NSString *)tag {               // ...но можно «прицепить» объект
    objc_setAssociatedObject(self, &kTagKey, tag, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
// [/assoc]

// [extension]
@interface Wallet : NSObject
@property (nonatomic, readonly) double money;  // снаружи — только чтение
- (void)earn:(double)x;
@end

@interface Wallet ()                           // расширение класса (анонимная категория)
@property (nonatomic, readwrite) double money; // внутри — запись
@property (nonatomic) NSUInteger operations;   // скрытое свойство
@end

@implementation Wallet
- (void)earn:(double)x { self.money += x; self.operations++; }
@end
// [/extension]

int main(void) {
    @autoreleasepool {
        // [use]
        NSLog(@"%@ | %d | %d", [@"stressed" reversed],
              [@"Never odd or even" isPalindrome], [@"Objective-C" isPalindrome]);

        NSArray *arr = @[@1];
        arr.tag = @"important";
        NSLog(@"tag = %@", arr.tag);

        Wallet *w = [Wallet new];
        [w earn:10]; [w earn:5];
        NSLog(@"money=%.0f", w.money);           // w.money = 0;  -> ошибка компиляции
        // [/use]
    }
    return 0;
}
