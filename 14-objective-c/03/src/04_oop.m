// ООП: классы, свойства, инициализаторы, наследование, полиморфизм.
#import <Foundation/Foundation.h>

// [interface]
@interface Animal : NSObject                       // интерфейс (обычно в .h)
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic) NSUInteger age;
+ (instancetype)animalWithName:(NSString *)name;   // фабричный метод класса
- (instancetype)initWithName:(NSString *)name;     // назначенный инициализатор
- (NSString *)sound;
- (NSString *)speak;
@end
// [/interface]

// [impl]
@implementation Animal                             // реализация (обычно в .m)
+ (instancetype)animalWithName:(NSString *)name { return [[self alloc] initWithName:name]; }

- (instancetype)initWithName:(NSString *)name {
    self = [super init];                           // сначала инициализируем родителя
    if (self) {
        _name = [name copy];                       // в init — прямо в ivar
    }
    return self;
}
- (NSString *)sound { return @"..."; }
- (NSString *)speak {
    return [NSString stringWithFormat:@"%@ the %@ says %@", self.name, [self class], [self sound]];
}
- (NSString *)description { return [NSString stringWithFormat:@"<%@ %@, %lu y>",
                                    [self class], _name, (unsigned long)_age]; }
@end
// [/impl]

// [inherit]
@interface Dog : Animal
@end
@implementation Dog
- (NSString *)sound { return @"Woof"; }           // переопределение
@end

@interface Puppy : Dog
@end
@implementation Puppy
- (NSString *)sound {
    return [[super sound] lowercaseString];       // вызов реализации родителя
}
@end

@interface Cat : Animal
@end
@implementation Cat
- (NSString *)sound { return @"Meow"; }
@end
// [/inherit]

int main(void) {
    @autoreleasepool {
        // [use]
        NSArray<Animal *> *zoo = @[[Dog animalWithName:@"Rex"],
                                   [Cat animalWithName:@"Tom"],
                                   [Puppy animalWithName:@"Bim"]];
        for (Animal *a in zoo) NSLog(@"%@", [a speak]);    // полиморфизм: позднее связывание

        Animal *bim = zoo[2];
        bim.age = 1;                       // точечный синтаксис = [bim setAge:1]
        [bim setAge:[bim age] + 1];        // то же самое сообщениями
        NSLog(@"%@", bim);
        NSLog(@"isKindOf Dog: %d, isMemberOf Dog: %d, superclass: %@",
              [bim isKindOfClass:[Dog class]], [bim isMemberOfClass:[Dog class]],
              [[bim class] superclass]);
        // [/use]
    }
    return 0;
}
