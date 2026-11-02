// Во что компилируется отправка сообщения. Посмотреть самим:
//   clang $(gnustep-config --objc-flags) -fobjc-arc -S -emit-llvm -O1 11_compiled.m -o - | grep -A3 'define.*callIt'
//   clang $(gnustep-config --objc-flags) -fobjc-arc -O1 -c 11_compiled.m && objdump -dr 11_compiled.o
#import <Foundation/Foundation.h>

// [source]
NSUInteger callIt(NSString *s) {
    return [s length];       // -> objc_msgSend(s, @selector(length))
}
// [/source]

int main(void) {
    @autoreleasepool {
        NSLog(@"length = %lu", (unsigned long)callIt(@"native code"));
    }
    return 0;
}
