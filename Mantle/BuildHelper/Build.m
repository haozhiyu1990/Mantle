//
//  Build.m
//  Mantle
//
//  Created by haozhiyu on 2017/2/16.
//  Copyright © 2017年 haozhiyu. All rights reserved.
//

#import "Build.h"
#import "BuildHelper.h"
#import "Logo.h"

@implementation Build

- (id)init {
    self = [super init];
    if ( self )
    {
        char	buff[256] = { 0 };
        char *	result = getcwd( buff, 256 - 1 );
        
        if ( result )
        {
            self.workingDirectory = [NSString stringWithUTF8String:buff];
        }
        
        self.arguments = [NSMutableArray array];
    }
    return self;
}

- (void)argc:(int)argc argv:(const char * [])argv {
    
    [self logo];
    
    if ( 0 == argc )
        return;
    
    NSString * exec = [NSString stringWithUTF8String:argv[0]];
    
    self.execPath = [exec stringByDeletingLastPathComponent];
    self.execName = [exec lastPathComponent];
    self.arguments = [NSMutableArray array];
    
    for ( NSUInteger i = 1; i < argc; ++i )
    {
        NSString * arg = [NSString stringWithUTF8String:argv[i]];
        
        [_arguments addObject:arg];
    }
    
    if (self.arguments.count != 0) {
        if (![self.arguments containsObject:@"build"]) {
            [self helper];
            [Logo shareInstance].RED().LINE(@"操作格式有误");
            return;
        }
        for (NSString * string in self.arguments) {
            if ([string isEqualToString:@"build"]) {
                [self build];
            }
        }
    } else {
        [self helper];
        [Logo shareInstance].RED().LINE(@"操作格式有误");
    }
}

- (void)helper {
    [Logo shareInstance].GREEN().LINE(nil);
    [Logo shareInstance].GREEN().LINE(nil);
    [Logo shareInstance].GREEN().LINE(@"./mantle build xxx.json   xxx 是文件名，也是生成的类名");
    [Logo shareInstance].GREEN().LINE(@".json 文件的格式应该如下：");
    [Logo shareInstance].GREEN().LINE(@"{");
    [Logo shareInstance].GREEN().LINE(@"  \"model\": {");
    [Logo shareInstance].GREEN().LINE(@"    \"key1\": \"value1\",     // NSString ");
    [Logo shareInstance].GREEN().LINE(@"    \"key2\": 100,     // NSNumber ");
    [Logo shareInstance].GREEN().LINE(@"    \"key3\": true,     // BOOL ");
    [Logo shareInstance].GREEN().LINE(@"    \"key4\": \"{Class1}\",     // NSDictionary 返回的字典，是另一个类，");
    [Logo shareInstance].GREEN().LINE(@"                  {}里写类的类名，在class下写出该类对应的属性    类名建议驼峰命名");
    [Logo shareInstance].GREEN().LINE(@"    \"key5\": [\"{Class2}\"],     // NSArray 返回的数组，数组里的每个元素是一个类，");
    [Logo shareInstance].GREEN().LINE(@"                  {}里写类的类名，在class下写出该类对应的属性    类名建议驼峰命名");
    [Logo shareInstance].GREEN().LINE(@"    \"...\": \"...\"");
    [Logo shareInstance].GREEN().LINE(@"  },");
    [Logo shareInstance].GREEN().LINE(@"  \"class\": {");
    [Logo shareInstance].GREEN().LINE(@"    \"Class1\": {");
    [Logo shareInstance].GREEN().LINE(@"      \"key1\": \"value1\",     // NSString ");
    [Logo shareInstance].GREEN().LINE(@"      \"key2\": 100,     // NSNumber ");
    [Logo shareInstance].GREEN().LINE(@"      \"key3\": true,     // BOOL ");
    [Logo shareInstance].GREEN().LINE(@"      \"key4\": \"{Class3}\",");
    [Logo shareInstance].GREEN().LINE(@"      \"...\": \"...\"");
    [Logo shareInstance].GREEN().LINE(@"    },");
    [Logo shareInstance].GREEN().LINE(@"    \"Class2\": {");
    [Logo shareInstance].GREEN().LINE(@"      \"key1\": \"value1\",     // NSString ");
    [Logo shareInstance].GREEN().LINE(@"      \"key2\": 100,     // NSNumber ");
    [Logo shareInstance].GREEN().LINE(@"      \"key3\": true,     // BOOL ");
    [Logo shareInstance].GREEN().LINE(@"      \"...\": \"...\"");
    [Logo shareInstance].GREEN().LINE(@"    },");
    [Logo shareInstance].GREEN().LINE(@"    \"Class3\": {");
    [Logo shareInstance].GREEN().LINE(@"      \"key1\": \"value1\",     // NSString ");
    [Logo shareInstance].GREEN().LINE(@"      \"key2\": 100,     // NSNumber ");
    [Logo shareInstance].GREEN().LINE(@"      \"key3\": true,     // BOOL ");
    [Logo shareInstance].GREEN().LINE(@"      \"...\": \"...\"");
    [Logo shareInstance].GREEN().LINE(@"    }");
    [Logo shareInstance].GREEN().LINE(@"  }");
    [Logo shareInstance].GREEN().LINE(@"}");
    [Logo shareInstance].GREEN().LINE(nil);
    [Logo shareInstance].GREEN().LINE(@"操作格式应如上：");
    [Logo shareInstance].GREEN().LINE(nil);
}

- (void)logo {
    [Logo shareInstance].GREEN().LINE(nil);
    [Logo shareInstance].GREEN().LINE(nil);
    [Logo shareInstance].GREEN().LINE(@"     __     __        _______         __    __");
    [Logo shareInstance].GREEN().LINE(@"    /\\ \\   /\\ \\      /\\_____ \\       /\\ \\  / /");
    [Logo shareInstance].GREEN().LINE(@"    \\ \\ \\__\\_\\ \\     \\/____/ /       \\ \\ \\/ /");
    [Logo shareInstance].GREEN().LINE(@"     \\ \\  _____ \\         / /         \\ \\/ /");
    [Logo shareInstance].GREEN().LINE(@"      \\ \\ \\__/ \\ \\       / /_____      \\/ /");
    [Logo shareInstance].GREEN().LINE(@"       \\ \\_\\  \\ \\_\\     /\\_______\\     / /");
    [Logo shareInstance].GREEN().LINE(@"        \\/_/   \\/_/     \\/_______/    /\\/");
    [Logo shareInstance].GREEN().LINE(@"                                      \\/");
    [Logo shareInstance].GREEN().LINE(nil);
    [Logo shareInstance].GREEN().LINE(nil);
}

- (void)build {
    NSString * inputPath = [self fileArgumentAtIndex:1];
    NSString * outputPath = [self pathArgumentAtIndex:1];

    if (inputPath == nil) {
        [Logo shareInstance].RED().LINE(@"请传入文件名");
        return;
    }
    
    if (inputPath == nil) {
        [Logo shareInstance].RED().LINE(@"请传入文件名");
        return;
    }
    
    BuildHelper *helper = [[BuildHelper alloc] init];
    helper.inputPath = [inputPath stringByDeletingLastPathComponent];
    helper.inputFile = [inputPath lastPathComponent];
    helper.outputPath = outputPath;

    BOOL succ = [helper generate];
    if (!succ) {
        [self helper];
        [Logo shareInstance].RED().LINE(@"文件有误");
    } else {
        [Logo shareInstance].RED().LINE(@"成功！！！");
    }
}

- (NSString *)fileArgumentAtIndex:(NSUInteger)index
{
    if ( index >= self.arguments.count )
        return nil;
    
    NSString * fullPath = [self.arguments objectAtIndex:index];
    NSString * resultPath = [self pathArgumentAtIndex:index];
    NSString * resultFile = [fullPath lastPathComponent];
    
    return [resultPath stringByAppendingString:resultFile];
}

- (NSString *)pathArgumentAtIndex:(NSUInteger)index
{
    if ( index >= self.arguments.count )
        return nil;
    
    NSString * currentPath = self.workingDirectory;
    NSString * fullPath = [self.arguments objectAtIndex:index];
    
    if ( NO == [currentPath hasSuffix:@"/"] )
    {
        currentPath = [currentPath stringByAppendingString:@"/"];
    }
    
    if ( NSNotFound == [fullPath rangeOfString:@"/"].location )
    {
        fullPath = [NSString stringWithFormat:@"./%@", fullPath];
    }
    
    NSString * resultFile = [fullPath lastPathComponent];
    NSString * resultPath = fullPath;
    
    resultPath = [resultPath stringByReplacingOccurrencesOfString:resultFile withString:@""];
    resultPath = [resultPath stringByReplacingOccurrencesOfString:@"~" withString:NSHomeDirectory()];
    resultPath = [resultPath stringByReplacingOccurrencesOfString:@"./" withString:currentPath];
    resultPath = [resultPath stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    resultPath = resultPath;
    
    return resultPath;
}

@end
