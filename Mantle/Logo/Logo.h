//
//  Logo.h
//  Mantle
//
//  Created by yons on 17/2/17.
//  Copyright © 2017年 zhiyu.hao. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -

@class Logo;

typedef Logo * (^LogoBlock)( void );
typedef Logo * (^LogoBlockH)( id first, ... );

#pragma mark -

@interface Logo : NSObject

@property (nonatomic, copy) NSString *          color;
@property (nonatomic, assign) BOOL				autoChangeBack;


@property (nonatomic, readonly) LogoBlockH      LINE;
@property (nonatomic, readonly) LogoBlock		RED;
@property (nonatomic, readonly) LogoBlock		BLUE;
@property (nonatomic, readonly) LogoBlock		CYAN;
@property (nonatomic, readonly) LogoBlock		GREEN;
@property (nonatomic, readonly) LogoBlock		YELLOW;
@property (nonatomic, readonly) LogoBlock		LIGHT_RED;
@property (nonatomic, readonly) LogoBlock		LIGHT_BLUE;
@property (nonatomic, readonly) LogoBlock		LIGHT_CYAN;
@property (nonatomic, readonly) LogoBlock		LIGHT_GREEN;
@property (nonatomic, readonly) LogoBlock		LIGHT_YELLOW;
@property (nonatomic, readonly) LogoBlock		NO_COLOR;

+ (Logo *)shareInstance;

@end
