// То же, но через модули clang (@import). Собирается: make app_modules
// [import]
@import Geometry;               // модуль: заголовки разбираются один раз и кэшируются
#import <Foundation/Foundation.h>

int main(void) {
    @autoreleasepool {
        GMPoint *p = [GMPoint pointWithX:1 y:1];
        NSLog(@"@import works: %@, v%@", p, GMGeometryVersion);
    }
    return 0;
}
// [/import]
