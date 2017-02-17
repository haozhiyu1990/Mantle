//
//  NSDate+HzyExtension.m
//  Mantle
//
//  Created by haozhiyu on 2017/2/17.
//  Copyright © 2017年 haozhiyu. All rights reserved.
//

#import "NSDate+HzyExtension.h"

@implementation NSDate (HzyExtension)

- (NSString *)stringWithDateFormat:(NSString *)format {
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:self];
    
}

@end
