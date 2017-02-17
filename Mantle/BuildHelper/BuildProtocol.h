//
//  BuildProtocol.h
//  Mantle
//
//  Created by haozhiyu on 2017/2/16.
//  Copyright © 2017年 haozhiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuildProtocol : NSObject

@property (copy, nonatomic) NSString * fileName;
@property (nonatomic, strong) NSMutableArray *classNameArr;
@property (nonatomic, strong) NSMutableDictionary *classDic;

- (BOOL)parseString:(NSString *)content;
- (NSString *)h;
- (NSString *)m;

@end
