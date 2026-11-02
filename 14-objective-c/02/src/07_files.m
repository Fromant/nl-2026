// Работа с файлами: NSString/NSData, NSFileManager, NSFileHandle, JSON.
#import <Foundation/Foundation.h>

int main(void) {
    @autoreleasepool {
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *dir  = [NSTemporaryDirectory() stringByAppendingPathComponent:@"objc-demo"];
        NSString *path = [dir stringByAppendingPathComponent:@"notes.txt"];
        NSError *err = nil;

        // [write]
        [fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&err];

        NSString *text = @"first line\nsecond line\n";
        BOOL ok = [text writeToFile:path atomically:YES
                           encoding:NSUTF8StringEncoding error:&err];   // весь файл сразу
        NSLog(@"written: %d", ok);

        NSFileHandle *fh = [NSFileHandle fileHandleForWritingAtPath:path];
        [fh seekToEndOfFile];                                           // дозапись
        [fh writeData:[@"third line\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [fh closeFile];
        // [/write]

        // [read]
        NSString *content = [NSString stringWithContentsOfFile:path
                                                      encoding:NSUTF8StringEncoding error:&err];
        NSArray *lines = [content componentsSeparatedByCharactersInSet:
                          [NSCharacterSet newlineCharacterSet]];
        NSUInteger n = 0;
        for (NSString *line in lines) {
            if (line.length == 0) continue;
            NSLog(@"%lu: %@", (unsigned long)++n, line);
        }

        NSData *bytes = [NSData dataWithContentsOfFile:path];            // двоичный доступ
        NSLog(@"size=%lu bytes", (unsigned long)bytes.length);
        // [/read]

        // [fm]
        NSDictionary *attrs = [fm attributesOfItemAtPath:path error:&err];
        NSLog(@"exists=%d size=%@", [fm fileExistsAtPath:path], attrs[NSFileSize]);

        NSString *copyPath = [dir stringByAppendingPathComponent:@"copy.txt"];
        [fm removeItemAtPath:copyPath error:NULL];
        [fm copyItemAtPath:path toPath:copyPath error:&err];
        NSArray *files = [[fm contentsOfDirectoryAtPath:dir error:&err]
                          sortedArrayUsingSelector:@selector(compare:)];
        NSLog(@"dir: %@", [files componentsJoinedByString:@", "]);
        // [/fm]

        // [json]
        NSDictionary *cfg = @{@"name": @"demo", @"version": @2, @"tags": @[@"objc", @"linux"]};
        NSData *json = [NSJSONSerialization dataWithJSONObject:cfg options:0 error:&err];
        NSString *jsonPath = [dir stringByAppendingPathComponent:@"cfg.json"];
        [json writeToFile:jsonPath atomically:YES];

        NSDictionary *back = [NSJSONSerialization
            JSONObjectWithData:[NSData dataWithContentsOfFile:jsonPath] options:0 error:&err];
        NSLog(@"json: name=%@ tags=%@", back[@"name"], [back[@"tags"] componentsJoinedByString:@"+"]);
        // [/json]

        // [error]
        NSDictionary *none = [fm attributesOfItemAtPath:@"/nope.txt" error:&err];
        if (!none) NSLog(@"failed: %@ (%@ %ld)", err.localizedDescription,
                         err.domain, (long)err.code);
        // [/error]

        [fm removeItemAtPath:dir error:NULL];       // уборка
    }
    return 0;
}
