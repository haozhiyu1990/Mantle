//
//  BuildHelper.h
//  Mantle
//
//  Created by haozhiyu on 2017/2/16.
//  Copyright © 2017年 haozhiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuildHelper : NSObject

@property (copy, nonatomic)     NSString        * inputPath;
@property (copy, nonatomic)     NSString        * inputFile;
@property (copy, nonatomic)     NSString        * outputPath;

- (BOOL)generate;

@end
