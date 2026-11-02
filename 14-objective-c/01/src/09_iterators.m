// Итераторы: for-in (fast enumeration), NSEnumerator, перебор блоками, свой итератор.
#import <Foundation/Foundation.h>

// [range]
@interface Range : NSEnumerator          // свой итератор = наследник NSEnumerator
- (instancetype)initFrom:(NSInteger)from to:(NSInteger)to step:(NSInteger)step;
@end

@implementation Range {
    NSInteger _cur, _to, _step;
}
- (instancetype)initFrom:(NSInteger)from to:(NSInteger)to step:(NSInteger)step {
    if ((self = [super init])) { _cur = from; _to = to; _step = step; }
    return self;
}
- (id)nextObject {                       // nil = «элементы закончились»
    if (_cur >= _to) return nil;
    NSNumber *n = @(_cur);
    _cur += _step;
    return n;
}
@end
// [/range]

int main(void) {
    @autoreleasepool {
        // [forin]
        NSArray *langs = @[@"C", @"Smalltalk", @"Objective-C"];
        for (NSString *s in langs) printf("%s ", s.UTF8String);       // fast enumeration
        printf("\n");

        NSDictionary *years = @{@"C": @1972, @"Smalltalk": @1980};
        for (NSString *key in [years.allKeys sortedArrayUsingSelector:@selector(compare:)])
            NSLog(@"%@ -> %@", key, years[key]);                      // по словарю — ключи

        NSEnumerator *rev = [langs reverseObjectEnumerator];          // явный итератор
        id obj;
        while ((obj = [rev nextObject])) printf("%s ", [obj UTF8String]);
        printf("\n");
        // [/forin]

        // [blocks]
        [langs enumerateObjectsUsingBlock:^(NSString *s, NSUInteger idx, BOOL *stop) {
            NSLog(@"%lu: %@", (unsigned long)idx, s);
            if (idx == 1) *stop = YES;                                // аналог break
        }];
        [years enumerateKeysAndObjectsUsingBlock:^(id k, id v, BOOL *stop) {
            if ([v intValue] < 1975) NSLog(@"old: %@", k);
        }];
        // [/blocks]

        // [custom]
        for (NSNumber *n in [[Range alloc] initFrom:0 to:10 step:3])
            printf("%ld ", (long)n.integerValue);                     // 0 3 6 9
        printf("\n");
        // [/custom]

        // [mutation]
        NSMutableArray *nums = [@[@1, @2, @3] mutableCopy];
        @try {
            for (NSNumber *x in nums) [nums addObject:x];             // менять нельзя!
        } @catch (NSException *e) {
            NSLog(@"%@", e.name);
        }
        // [/mutation]
    }
    return 0;
}
