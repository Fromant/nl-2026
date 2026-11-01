// Исключения: @try / @catch / @finally / @throw.
#import <Foundation/Foundation.h>

// [custom]
@interface ValidationException : NSException       // своё исключение
+ (instancetype)exceptionWithField:(NSString *)field;
@end

@implementation ValidationException
+ (instancetype)exceptionWithField:(NSString *)field {
    return [[self alloc] initWithName:@"ValidationException"
                               reason:[NSString stringWithFormat:@"bad field '%@'", field]
                             userInfo:@{@"field": field}];
}
@end
// [/custom]

// [validate]
void validateAge(NSInteger age) {
    if (age < 0) @throw [ValidationException exceptionWithField:@"age"];
    if (age > 150)
        [NSException raise:NSInvalidArgumentException format:@"age %ld?!", (long)age];
}
// [/validate]

// [handler]
void onUncaught(NSException *e) {                   // последний рубеж
    fprintf(stderr, "UNCAUGHT: %s\n", e.reason.UTF8String);
}
// [/handler]

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        NSSetUncaughtExceptionHandler(onUncaught);

        // [trycatch]
        NSArray *values = @[@10, @-5, @200];
        for (NSNumber *v in values) {
            @try {
                validateAge(v.integerValue);
                NSLog(@"%@: ok", v);
            } @catch (ValidationException *e) {     // от частного к общему
                NSLog(@"%@: validation, field=%@", v, e.userInfo[@"field"]);
            } @catch (NSException *e) {
                NSLog(@"%@: %@ - %@", v, e.name, e.reason);
            } @finally {
                NSLog(@"%@: finally", v);           // выполняется всегда
            }
        }
        // [/trycatch]

        // [rethrow]
        @try {
            @try {
                [@[] objectAtIndex:3];              // выход за границы
            } @catch (NSException *e) {
                NSLog(@"inner: %@, rethrow", e.name);
                @throw;                             // пробросить дальше
            }
        } @catch (id anything) {                    // можно ловить любой объект
            NSLog(@"outer caught %@", [anything name]);
        }
        // [/rethrow]

        // [uncaught]
        if (argc > 1) [NSException raise:@"Fatal" format:@"nobody catches me"];
        // [/uncaught]
    }
    return 0;
}
