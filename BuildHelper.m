//
//  BuildHelper.m
//  Mantle
//
//  Created by haozhiyu on 2017/2/16.
//  Copyright © 2017年 haozhiyu. All rights reserved.
//

#import "BuildHelper.h"
#import "BuildProtocol.h"

@implementation BuildHelper

- (BOOL)generate {
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd_hhmmss"];
    NSString *	date = [dateFormatter stringFromDate:[NSDate date]];

    NSString *	inputFullPath = nil;
    NSString *	inputExtension = nil;
    NSString *	outputPath = nil;
    NSString *	outputFullPath = nil;
    NSString *	outputFileH = nil;
    NSString *	outputFileM = nil;

    
    inputFullPath = [NSString stringWithFormat:@"%@/%@", self.inputPath, self.inputFile];
    inputFullPath = [inputFullPath stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    inputExtension = [NSString stringWithFormat:@".%@", [inputFullPath pathExtension]];
    
    outputPath = [NSString stringWithFormat:@"%@/%@", self.outputPath ? self.outputPath : self.inputPath, date];
    [self touch:[NSString stringWithFormat:@"%@", outputPath]];
    outputFullPath = [NSString stringWithFormat:@"%@/%@", outputPath, self.inputFile];
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
