// Консольный ввод-вывод. Пример запуска:
//   printf "3\n5\nabc\n10\n" | ./08_console
#import <Foundation/Foundation.h>
#include <stdio.h>

int main(void) {
    @autoreleasepool {
        // [out]
        printf("printf -> stdout\n");                         // C stdio
        fprintf(stderr, "fprintf -> stderr\n");
        NSLog(@"NSLog -> stderr (+timestamp)");               // для отладки

        NSFileHandle *out = [NSFileHandle fileHandleWithStandardOutput];
        [out writeData:[@"NSFileHandle -> stdout\n" dataUsingEncoding:NSUTF8StringEncoding]];
        // [/out]
        fflush(stdout);

        // [in]
        char buf[256];
        long sum = 0;
        int count = 0;
        printf("Enter numbers (Ctrl+D to finish):\n");
        while (fgets(buf, sizeof buf, stdin)) {               // строка за строкой
            NSString *line = [[NSString stringWithUTF8String:buf]
                stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSScanner *sc = [NSScanner scannerWithString:line];
            NSInteger value;
            if ([sc scanInteger:&value] && sc.isAtEnd) {      // строгий разбор числа
                sum += value; count++;
            } else {
                fprintf(stderr, "skip: '%s'\n", line.UTF8String);
            }
        }
        printf("count=%d sum=%ld\n", count, sum);
        // [/in]
    }
    return 0;
}
