// Владение объектами и передача владения при ARC.
#import <Foundation/Foundation.h>

// [person]
@interface Person : NSObject
@property (nonatomic, copy)   NSString *name;   // своя копия строки
@property (nonatomic, strong) Person   *friend; // владеет объектом (+1)
@property (nonatomic, weak)   Person   *boss;   // не владеет, обнуляется сам
- (instancetype)initWithName:(NSString *)name;
@end

@implementation Person
- (instancetype)initWithName:(NSString *)name {
    if ((self = [super init])) {
        _name = [name copy];
        NSLog(@"+ %@", _name);
    }
    return self;
}
- (void)dealloc { NSLog(@"- %@ (dealloc)", _name); }   // [super dealloc] при ARC не пишут
@end
// [/person]

// [factory]
Person *makePerson(NSString *name) {
    Person *p = [[Person alloc] initWithName:name];
    return p;                        // владение передаётся вызывающему
}
// [/factory]

int main(void) {
    @autoreleasepool {
        // [strongweak]
        Person *boss = [[Person alloc] initWithName:@"Boss"];
        Person *emp  = [[Person alloc] initWithName:@"Emp"];
        emp.boss = boss;             // weak: счётчик ссылок не меняется
        boss = nil;                  // последняя strong-ссылка -> dealloc
        NSLog(@"emp.boss = %@", emp.boss);   // (null): weak обнулилась
        // [/strongweak]

        // [copy]
        NSMutableString *m = [NSMutableString stringWithString:@"Ann"];
        Person *ann = [[Person alloc] initWithName:m];
        [m appendString:@"a"];
        NSLog(@"name=%@, source=%@", ann.name, m);   // копия не изменилась
        // [/copy]

        // [transfer]
        @autoreleasepool {
            Person *owner1 = makePerson(@"Data");
            Person *owner2 = owner1;     // теперь два владельца
            owner1 = nil;                // объект жив: его держит owner2
            NSLog(@"still alive: %@", owner2.name);
        }                                // конец области — последний release
        NSLog(@"after scope");
        // [/transfer]
    }
    return 0;
}
