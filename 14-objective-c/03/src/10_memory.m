// Управление памятью при ARC: циклы удержания, weak, блоки, autoreleasepool.
#import <Foundation/Foundation.h>

// [cycle]
@interface Node : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) Node *next;          // strong -> strong = цикл
@property (nonatomic, weak)   Node *parent;        // weak разрывает цикл
@property (nonatomic, copy)   void (^onEvent)(void);
@end
@implementation Node
+ (instancetype)named:(NSString *)n { Node *x = [Node new]; x.name = n; return x; }
- (void)dealloc { NSLog(@"dealloc %@", _name); }
@end
// [/cycle]

int main(void) {
    @autoreleasepool {
        // [leak]
        @autoreleasepool {
            Node *a = [Node named:@"A"], *b = [Node named:@"B"];
            a.next = b;
            b.next = a;                    // A <-> B: счётчики никогда не обнулятся
        }
        NSLog(@"A and B leaked (no dealloc above)");
        // [/leak]

        // [weakfix]
        @autoreleasepool {
            Node *parent = [Node named:@"Parent"], *child = [Node named:@"Child"];
            parent.next = child;
            child.parent = parent;         // обратная ссылка — weak
        }
        NSLog(@"parent/child freed");
        // [/weakfix]

        // [blockcycle]
        @autoreleasepool {
            Node *n = [Node named:@"WithBlock"];
            __weak Node *weakN = n;
            n.onEvent = ^{                  // self/n внутри блока — только через weak
                Node *strongN = weakN;      // «weak-strong dance»
                NSLog(@"event in %@", strongN.name);
            };
            n.onEvent();
        }
        // [/blockcycle]

        // [pool]
        for (int batch = 0; batch < 3; batch++) {
            @autoreleasepool {              // временные объекты освобождаются каждую итерацию,
                for (int i = 0; i < 10000; i++) {      // а не в конце программы
                    NSString *tmp = [NSString stringWithFormat:@"item-%d", i];
                    (void)tmp;
                }
            }
        }
        NSLog(@"pool loop done");
        // [/pool]
    }
    return 0;
}
