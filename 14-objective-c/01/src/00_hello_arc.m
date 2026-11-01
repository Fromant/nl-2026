// Та же программа в современном стиле (ARC + @autoreleasepool). Нужен clang.
// [hello_arc]
#import <Foundation/Foundation.h>

int main(int argc, const char *argv[]) {
    @autoreleasepool {                        // ARC: release писать не нужно
        NSArray *langs = @[@"C", @"Smalltalk"];  // литерал массива
        NSLog(@"Objective-C = %@", [langs componentsJoinedByString:@" + "]);
    }
    return 0;
}
// [/hello_arc]
