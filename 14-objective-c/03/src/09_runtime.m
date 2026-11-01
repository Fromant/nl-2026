// Рантайм Objective-C: интроспекция, isa и метаклассы, IMP, динамическое добавление методов,
// перенаправление сообщений, подмена методов (swizzling).
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface Greeter : NSObject
@property (nonatomic, copy) NSString *name;
- (NSString *)hello;
@end
@implementation Greeter
- (NSString *)hello { return @"hello"; }
@end

// [resolve]
static NSString *dynamicBye(id self, SEL _cmd) {        // обычная C-функция = IMP
    return [NSString stringWithFormat:@"bye from %s", sel_getName(_cmd)];
}

@interface Dynamic : NSObject
@end
@implementation Dynamic
+ (BOOL)resolveInstanceMethod:(SEL)sel {               // 1-й шанс: добавить метод «на лету»
    if (sel_isEqual(sel, NSSelectorFromString(@"bye"))) {
        class_addMethod(self, sel, (IMP)dynamicBye, "@@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}
- (id)forwardingTargetForSelector:(SEL)sel {          // 2-й шанс: переадресовать
    if (sel_isEqual(sel, @selector(uppercaseString))) return @"forwarded";
    return [super forwardingTargetForSelector:sel];
}
@end
// [/resolve]

// [swizzle]
@implementation Greeter (Swizzle)
- (NSString *)loudHello {
    return [[self loudHello] uppercaseString];          // после обмена — вызов оригинала!
}
@end
// [/swizzle]

int main(void) {
    @autoreleasepool {
        // [introspect]
        unsigned count = 0;
        Method *methods = class_copyMethodList([Greeter class], &count);
        NSMutableArray *names = [NSMutableArray array];
        for (unsigned i = 0; i < count; i++)
            [names addObject:NSStringFromSelector(method_getName(methods[i]))];
        free(methods);
        NSLog(@"methods: %@", [[names sortedArrayUsingSelector:@selector(compare:)]
                               componentsJoinedByString:@", "]);

        Ivar *ivars = class_copyIvarList([Greeter class], &count);
        NSLog(@"ivar[0]: %s", ivar_getName(ivars[0]));     // _name — сгенерирован @property
        free(ivars);
        // [/introspect]

        // [isa]
        Greeter *g = [Greeter new];
        Class cls  = object_getClass(g);                    // isa объекта -> класс
        Class meta = object_getClass(cls);                  // isa класса -> метакласс
        NSLog(@"%s -> %s (meta: %d) -> super %s", class_getName(cls), class_getName(meta),
              class_isMetaClass(meta), class_getName(class_getSuperclass(cls)));
        // [/isa]

        // [imp]
        SEL sel = @selector(hello);
        IMP imp = [g methodForSelector:sel];                // адрес реализации
        NSString *(*fn)(id, SEL) = (NSString *(*)(id, SEL))imp;
        NSLog(@"direct IMP call: %@", fn(g, sel));          // без objc_msgSend
        // [/imp]

        // [dynamic]
        id d = [Dynamic new];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        NSLog(@"%@", [d performSelector:NSSelectorFromString(@"bye")]);
#pragma clang diagnostic pop
        NSLog(@"%@", [d uppercaseString]);
        // [/dynamic]

        // [swizzleuse]
        Method orig = class_getInstanceMethod([Greeter class], @selector(hello));
        Method loud = class_getInstanceMethod([Greeter class], @selector(loudHello));
        method_exchangeImplementations(orig, loud);
        NSLog(@"after swizzling: %@", [g hello]);
        // [/swizzleuse]
    }
    return 0;
}
