// Обобщённые типы (lightweight generics, с Xcode 7 / clang 2015).
#import <Foundation/Foundation.h>

// [decl]
@interface Stack<__covariant ObjectType> : NSObject     // параметр типа
@property (nonatomic, readonly) NSUInteger count;
- (void)push:(ObjectType)object;
- (nullable ObjectType)pop;
- (nullable ObjectType)peek;
@end
// [/decl]

// [impl]
@implementation Stack {
    NSMutableArray *_items;          // в реализации ObjectType недоступен -> id
}
- (instancetype)init {
    if ((self = [super init])) _items = [NSMutableArray array];
    return self;
}
- (NSUInteger)count { return _items.count; }
- (void)push:(id)object { [_items addObject:object]; }
- (id)pop {
    id last = _items.lastObject;
    if (last) [_items removeLastObject];
    return last;
}
- (id)peek { return _items.lastObject; }
@end
// [/impl]

// [bound]
@interface Registry<KeyType : id<NSCopying>, ValueType> : NSObject   // ограничение
- (void)setValue:(ValueType)value forKey:(KeyType)key;
- (nullable ValueType)valueForKey:(KeyType)key;
@end

@implementation Registry {
    NSMutableDictionary *_storage;
}
- (instancetype)init {
    if ((self = [super init])) _storage = [NSMutableDictionary dictionary];
    return self;
}
- (void)setValue:(id)value forKey:(id)key { _storage[key] = value; }
- (id)valueForKey:(id)key { return _storage[key]; }
@end
// [/bound]

int main(void) {
    @autoreleasepool {
        // [use]
        Stack<NSString *> *names = [Stack new];       // инстанцирование
        [names push:@"Brad"];
        [names push:@"Tom"];
        NSString *top = [names pop];                  // без приведения типа
        NSLog(@"pop=%@ count=%lu", top, (unsigned long)names.count);
        // [names push:@42];  // warning: incompatible pointer types sending 'NSNumber *'

        Stack<NSString *> *mutableNames = [Stack new];
        Stack<NSObject *> *objects = mutableNames;    // __covariant: так можно
        NSLog(@"covariant ok: %lu", (unsigned long)objects.count);

        Registry<NSString *, NSNumber *> *ages = [Registry new];
        [ages setValue:@39 forKey:@"Brad"];
        NSLog(@"Brad: %@", [ages valueForKey:@"Brad"]);
        // [/use]

        // [erasure]
        NSArray<NSString *> *strings = @[@"a", @"b"];
        NSMutableArray *raw = [strings mutableCopy];   // generics стираются:
        [raw addObject:@123];                          // рантайм ничего не проверяет
        NSArray<NSString *> *again = raw;
        for (id x in again) NSLog(@"%@ is %@", x, [x class]);
        // [/erasure]

        // [kindof]
        NSArray<__kindof NSString *> *labels = @[[@"mutable" mutableCopy]];
        NSMutableString *first = labels.firstObject;   // __kindof: подклассы без каста
        [first appendString:@"!"];
        NSLog(@"%@", first);
        // [/kindof]
    }
    return 0;
}
