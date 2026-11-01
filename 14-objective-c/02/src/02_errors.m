// NSError — «обычные» ожидаемые ошибки. Исключения — для ошибок программиста.
#import <Foundation/Foundation.h>

// [domain]
static NSString *const ConfigErrorDomain = @"ConfigErrorDomain";
typedef NS_ENUM(NSInteger, ConfigError) {
    ConfigErrorMissing = 1,
    ConfigErrorInvalid = 2,
};
// [/domain]

// [load]
NSDictionary *loadConfig(NSString *path, NSError **error) {
    NSError *ioError = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:path
                                                                           error:&ioError];
    if (attrs == nil) {                                  // проверяем РЕЗУЛЬТАТ, не error
        if (error) *error = [NSError errorWithDomain:ConfigErrorDomain
                                                code:ConfigErrorMissing
                                            userInfo:@{
            NSLocalizedDescriptionKey: [NSString stringWithFormat:@"no config at %@", path],
            NSUnderlyingErrorKey: ioError }];            // цепочка причин
        return nil;
    }
    NSString *text = [NSString stringWithContentsOfFile:path
                                               encoding:NSUTF8StringEncoding error:NULL];
    if (text.length == 0) {
        if (error) *error = [NSError errorWithDomain:ConfigErrorDomain
                                                code:ConfigErrorInvalid userInfo:nil];
        return nil;
    }
    return @{@"raw": text};
}
// [/load]

int main(void) {
    @autoreleasepool {
        // [use]
        NSError *err = nil;
        NSDictionary *cfg = loadConfig(@"/no/such/file.conf", &err);
        if (!cfg) {
            NSLog(@"domain=%@ code=%ld", err.domain, (long)err.code);
            NSLog(@"message: %@", err.localizedDescription);
            NSError *cause = err.userInfo[NSUnderlyingErrorKey];
            NSLog(@"cause: %@ / %ld", cause.domain, (long)cause.code);
        }

        cfg = loadConfig(@"/etc/hostname", NULL);         // ошибка не интересна — NULL
        NSLog(@"loaded: %d", cfg != nil);
        // [/use]
    }
    return 0;
}
