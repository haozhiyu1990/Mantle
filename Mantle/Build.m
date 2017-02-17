//
//  Build.m
//  Mantle
//
//  Created by haozhiyu on 2017/2/16.
//  Copyright © 2017年 haozhiyu. All rights reserved.
//

#import "Build.h"
#import "BuildHelper.h"

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
    
    [self build];
}

- (void)build {
    NSString * inputPath = [self fileArgumentAtIndex:1];
    NSString * outputPath = [self pathArgumentAtIndex:1];

    BuildHelper *helper = [[BuildHelper alloc] init];
    helper.inputPath = [inputPath stringByDeletingLastPathComponent];
    helper.inputFile = [inputPath lastPathComponent];
    helper.outputPath = outputPath;

    BOOL succ = [helper generate];
    if (!succ) {
        fprintf( stderr , "文件有误\n");
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
