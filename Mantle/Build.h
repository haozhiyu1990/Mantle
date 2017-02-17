//
//  Build.h
//  Mantle
//
//  Created by haozhiyu on 2017/2/16.
//  Copyright © 2017年 haozhiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Build : NSObject

@property (copy, nonatomic)     NSString        * workingDirectory;
@property (copy, nonatomic)     NSString        * execPath;
@property (copy, nonatomic)     NSString        * execName;
@property (strong, nonatomic)   NSMutableArray  * arguments;

- (void)argc:(int)argc argv:(const char * [])argv;

@end
