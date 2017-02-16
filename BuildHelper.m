//
//  BuildHelper.m
//  Mantle
//
//  Created by haozhiyu on 2017/2/16.
//  Copyright © 2017年 haozhiyu. All rights reserved.
//

#import "BuildHelper.h"
#import "BuildProtocol.h"
#import "NSDate+HzyExtension.h"

@implementation BuildHelper

- (BOOL)generate {
    
    NSString *	date = [[NSDate date] stringWithDateFormat:@"yyyyMMdd_hhmmss"];

    NSString *	fileName = nil;
    NSString *	inputFullPath = nil;
    NSString *	inputExtension = nil;
    NSString *	outputPath = nil;
    NSString *	outputFullPath = nil;
    NSString *	outputFileH = nil;
    NSString *	outputFileM = nil;

    inputFullPath = [NSString stringWithFormat:@"%@/%@", self.inputPath, self.inputFile];
    inputFullPath = [inputFullPath stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    inputExtension = [NSString stringWithFormat:@".%@", [inputFullPath pathExtension]];
    fileName = [self.inputFile stringByDeletingPathExtension];
    
    outputPath = [NSString stringWithFormat:@"%@/%@", self.outputPath ? self.outputPath : self.inputPath, date];
    [self touch:[NSString stringWithFormat:@"%@", outputPath]];
    outputFullPath = [NSString stringWithFormat:@"%@/%@%@", outputPath, [fileName capitalizedString], inputExtension];
    outputFullPath = [outputFullPath stringByReplacingOccurrencesOfString:@"//" withString:@"/"];

    outputFileH = [outputFullPath stringByReplacingOccurrencesOfString:inputExtension withString:@".h"];
    outputFileM = [outputFullPath stringByReplacingOccurrencesOfString:inputExtension withString:@".m"];
    
    NSString * content = [NSString stringWithContentsOfFile:inputFullPath encoding:NSUTF8StringEncoding error:NULL];
    if ( nil == content || 0 == content.length ) {
        return NO;
    }
    
    BuildProtocol * protocol = [[BuildProtocol alloc] init];

    protocol.fileName = [[outputFullPath lastPathComponent] stringByDeletingPathExtension];

    BOOL succeed = [protocol parseString:content];
    if (!succeed) {
        return NO;
    }

    NSString * h = [protocol h];
    NSString * m = [protocol m];

    [h writeToFile:outputFileH atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    [m writeToFile:outputFileM atomically:YES encoding:NSUTF8StringEncoding error:NULL];

    
    return YES;
}

- (BOOL)touch:(NSString *)path {
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:path] )
    {
        return [[NSFileManager defaultManager] createDirectoryAtPath:path
                                         withIntermediateDirectories:YES
                                                          attributes:nil
                                                               error:NULL];
    }
    return YES;
}

@end
