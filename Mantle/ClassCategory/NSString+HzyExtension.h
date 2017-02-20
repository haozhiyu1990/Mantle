//
//  NSString+HzyExtension.h
//  Mantle
//
//  Created by haozhiyu on 2017/2/16.
//  Copyright © 2017年 haozhiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -

typedef NSString *			(^NSStringAppendBlock)( id format, ... );
typedef NSString *			(^NSStringReplaceBlock)( NSString * string, NSString * string2 );

typedef NSMutableString *	(^NSMutableStringAppendBlock)( id format, ... );
typedef NSMutableString *	(^NSMutableStringReplaceBlock)( NSString * string, NSString * string2 );

#pragma mark -

@interface NSString (HzyExtension)

@property (nonatomic, readonly) NSStringAppendBlock             APPEND;
@property (nonatomic, readonly) NSStringAppendBlock             LINE;
@property (nonatomic, readonly) NSStringReplaceBlock            REPLACE;

- (BOOL)isKeywords;

@end

#pragma mark -

@interface NSMutableString(HzyExtension)

@property (nonatomic, readonly) NSMutableStringAppendBlock      APPEND;
@property (nonatomic, readonly) NSMutableStringAppendBlock      LINE;
@property (nonatomic, readonly) NSMutableStringReplaceBlock     REPLACE;

@end

