// Коллекции Foundation: NSArray, NSSet, NSDictionary, NSOrderedSet, NSCountedSet + C-массивы.
#import <Foundation/Foundation.h>

int main(void) {
    @autoreleasepool {
        // [carray]
        int primes[5] = {2, 3, 5, 7, 11};            // C-массив: фиксированный размер,
        size_t len = sizeof(primes) / sizeof(primes[0]);   // только примитивы,
        printf("C array: len=%zu last=%d\n", len, primes[len - 1]);  // без проверки границ
        // [/carray]

        // [array]
        NSArray<NSString *> *langs = @[@"Swift", @"C", @"Objective-C", @"Go"];
        NSLog(@"count=%lu first=%@ [2]=%@", (unsigned long)langs.count, langs.firstObject, langs[2]);
        NSLog(@"contains Go: %d, index of C: %lu", [langs containsObject:@"Go"],
              (unsigned long)[langs indexOfObject:@"C"]);
        NSArray *sorted = [langs sortedArrayUsingSelector:@selector(compare:)];
        NSArray *byLen  = [langs sortedArrayUsingComparator:^NSComparisonResult(NSString *a, NSString *b) {
            return [@(a.length) compare:@(b.length)];
        }];
        NSLog(@"sorted: %@", [sorted componentsJoinedByString:@", "]);
        NSLog(@"by length: %@", [byLen componentsJoinedByString:@", "]);
        NSLog(@"slice: %@", [[langs subarrayWithRange:NSMakeRange(1, 2)] componentsJoinedByString:@", "]);
        // [/array]

        // [mutable]
        NSMutableArray<NSNumber *> *nums = [NSMutableArray arrayWithArray:@[@3, @1, @2]];
        [nums addObject:@5];
        [nums insertObject:@0 atIndex:0];
        [nums removeObject:@1];
        nums[1] = @30;                               // замена по индексу
        [nums sortUsingSelector:@selector(compare:)];
        NSLog(@"nums: %@  sum=%@", [nums componentsJoinedByString:@" "],
              [nums valueForKeyPath:@"@sum.self"]);  // KVC-операторы коллекций
        // [/mutable]

        // [set]
        NSSet *a = [NSSet setWithArray:@[@1, @2, @3, @3]];        // дубликаты исчезнут
        NSMutableSet *u = [a mutableCopy];
        [u unionSet:[NSSet setWithObjects:@3, @4, nil]];
        NSMutableSet *inter = [a mutableCopy];
        [inter intersectSet:[NSSet setWithObjects:@2, @3, @9, nil]];
        NSLog(@"a=%lu items, union=%lu, intersect has 2: %d", (unsigned long)a.count,
              (unsigned long)u.count, [inter containsObject:@2]);

        NSCountedSet *words = [[NSCountedSet alloc] initWithArray:
                               @[@"to", @"be", @"or", @"not", @"to", @"be"]];
        NSLog(@"'to' x%lu, 'or' x%lu", (unsigned long)[words countForObject:@"to"],
              (unsigned long)[words countForObject:@"or"]);

        NSOrderedSet *ordered = [NSOrderedSet orderedSetWithArray:@[@"b", @"a", @"b", @"c"]];
        NSLog(@"ordered set: %@", [ordered.array componentsJoinedByString:@""]);
        // [/set]

        // [dict]
        NSMutableDictionary<NSString *, NSNumber *> *stock = [@{@"apple": @5} mutableCopy];
        stock[@"pear"] = @2;                                       // добавить / заменить
        [stock setObject:@7 forKey:@"apple"];
        [stock removeObjectForKey:@"pear"];
        stock[@"kiwi"] = @0;
        NSLog(@"apple=%@ missing=%@", stock[@"apple"], stock[@"banana"]);   // nil
        for (NSString *k in [stock keysSortedByValueUsingSelector:@selector(compare:)])
            NSLog(@"  %@: %@", k, stock[k]);
        // [/dict]

        // [nil]
        // nil в коллекцию положить нельзя -> используем NSNull
        NSArray *withHole = @[@"x", [NSNull null], @"z"];
        NSLog(@"[1] is NSNull: %d", withHole[1] == [NSNull null]);

        // структуры — через NSValue
        NSValue *r = [NSValue valueWithRange:NSMakeRange(10, 3)];
        NSLog(@"range from NSValue: %@", NSStringFromRange(r.rangeValue));
        // [/nil]

        // [immutable]
        NSMutableArray *source = [NSMutableArray arrayWithObject:@"one"];
        NSArray *snapshot = [source copy];          // неизменяемая копия
        [source addObject:@"two"];
        NSLog(@"source=%lu snapshot=%lu", (unsigned long)source.count, (unsigned long)snapshot.count);
        // [/immutable]
    }
    return 0;
}
