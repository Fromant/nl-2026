// Минимальная программа. Собирается и clang+libobjc2, и gcc (gobjc), и в онлайн-компиляторах.
// [hello]
#import <Foundation/Foundation.h>

int main(int argc, const char *argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSString *lang = @"Objective-C";
    NSLog(@"Hello, %@!", lang);            // stderr + дата/время/pid
    printf("argc = %d\n", argc);           // обычный C тоже работает

    [pool drain];
    return 0;
}
// [/hello]
