// Функциональный стиль: блоки как значения, map/filter/reduce, композиция, NSPredicate.
#import <Foundation/Foundation.h>

// [fp]
@interface NSArray<ObjectType> (FP)
- (NSArray *)map:(id (^)(ObjectType x))f;
- (NSArray<ObjectType> *)filter:(BOOL (^)(ObjectType x))pred;
- (id)reduce:(id)initial with:(id (^)(id acc, ObjectType x))f;
@end

@implementation NSArray (FP)
- (NSArray *)map:(id (^)(id))f {
    NSMutableArray *out = [NSMutableArray arrayWithCapacity:self.count];
    for (id x in self) [out addObject:f(x)];
    return [out copy];                          // наружу — неизменяемый результат
}
- (NSArray *)filter:(BOOL (^)(id))pred {
    return [self objectsAtIndexes:[self indexesOfObjectsPassingTest:
            ^BOOL(id x, NSUInteger i, BOOL *stop) { return pred(x); }]];
}
- (id)reduce:(id)acc with:(id (^)(id, id))f {
    for (id x in self) acc = f(acc, x);
    return acc;
}
@end
// [/fp]

// [compose]
typedef id (^Fn)(id);
Fn compose(Fn f, Fn g) { return ^id(id x) { return g(f(x)); }; }   // g ∘ f

Fn adder(NSInteger n) {                          // каррирование: функция возвращает функцию
    return ^id(NSNumber *x) { return @(x.integerValue + n); };
}
// [/compose]

int main(void) {
    @autoreleasepool {
        // [use]
        NSArray<NSNumber *> *nums = @[@1, @2, @3, @4, @5, @6];

        NSArray *squares = [nums map:^id(NSNumber *x) { return @(x.intValue * x.intValue); }];
        NSArray *evens   = [nums filter:^BOOL(NSNumber *x) { return x.intValue % 2 == 0; }];
        NSNumber *sum    = [nums reduce:@0 with:^id(NSNumber *acc, NSNumber *x) {
            return @(acc.intValue + x.intValue);
        }];
        NSLog(@"squares=%@ evens=%@ sum=%@", [squares componentsJoinedByString:@","],
              [evens componentsJoinedByString:@","], sum);

        Fn inc = adder(1), dbl = ^id(NSNumber *x) { return @(x.intValue * 2); };
        Fn incThenDouble = compose(inc, dbl);
        NSLog(@"(5+1)*2 = %@", incThenDouble(@5));

        NSArray *pipeline = [[[nums filter:^BOOL(NSNumber *x) { return x.intValue > 2; }]
                              map:incThenDouble]
                             map:^id(NSNumber *x) { return x.stringValue; }];
        NSLog(@"pipeline: %@", [pipeline componentsJoinedByString:@" "]);
        // [/use]

        // [builtin]
        NSArray *people = @[@{@"name": @"Ann", @"age": @31}, @{@"name": @"Bob", @"age": @17},
                            @{@"name": @"Eve", @"age": @45}];
        NSPredicate *adults = [NSPredicate predicateWithFormat:@"age >= 18"];
        NSArray *names = [[people filteredArrayUsingPredicate:adults] valueForKey:@"name"];
        NSLog(@"adults: %@", [names componentsJoinedByString:@", "]);
        NSLog(@"max age=%@ avg=%@", [people valueForKeyPath:@"@max.age"],
              [people valueForKeyPath:@"@avg.age"]);
        // [/builtin]
    }
    return 0;
}
