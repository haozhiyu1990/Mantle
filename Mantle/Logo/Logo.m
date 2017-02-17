//
//  Logo.m
//  Mantle
//
//  Created by yons on 17/2/17.
//  Copyright © 2017年 zhiyu.hao. All rights reserved.
//

#import "Logo.h"

@implementation Logo

static Logo * staticLogo = nil;

+ (Logo *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticLogo = [[Logo alloc] init];
        staticLogo.autoChangeBack = YES;
    });
    
    return staticLogo;
}

- (LogoBlockH)LINE
{
    LogoBlockH block = ^ Logo * ( id first, ... )
    {
        va_list args;
        va_start( args, first );
        
        if ( first && [first isKindOfClass:[NSString class]] )
        {
#if (TARGET_OS_MAC)
            if ( self.color )
            {
                fprintf( stderr, "%s", [self.color UTF8String] );
            }
#endif	// #if (TARGET_OS_MAC)
            
            NSString * text = [[NSString alloc] initWithFormat:(NSString *)first arguments:args];
            fprintf( stderr, "%s", [text UTF8String] );
        }
        
#if (TARGET_OS_MAC)
        if ( self.color )
        {
            if ( self.autoChangeBack )
            {
                fprintf( stderr, "\e[0m" );
            }
        }
#endif	// #if (TARGET_OS_MAC)
        
        va_end( args );
        
        if ( self.autoChangeBack )
        {
            self.color = nil;
        }
        
        fprintf( stderr, "\n" );
        return self;
    };
    
    return [block copy];
}


- (LogoBlock)NO_COLOR
{
    LogoBlock block = ^ Logo * ( void )
    {
        self.color = @"\e[0m";
        return self;
    };
    
    return [block copy];
}

- (LogoBlock)RED
{
    LogoBlock block = ^ Logo * ( void )
    {
        self.color = @"\e[0;31m";
        return self;
    };
    
    return [block copy];
}

- (LogoBlock)BLUE
{
    LogoBlock block = ^ Logo * ( void )
    {
        self.color = @"\e[0;34m";
        return self;
    };
    
    return [block copy];
}

- (LogoBlock)CYAN
{
    LogoBlock block = ^ Logo * ( void )
    {
        self.color = @"\e[0;36m";
        return self;
    };
    
    return [block copy];
}

- (LogoBlock)GREEN
{
    LogoBlock block = ^ Logo * ( void )
    {
        self.color = @"\e[0;32m";
        return self;
    };
    
    return [block copy];
}

- (LogoBlock)YELLOW
{
    LogoBlock block = ^ Logo * ( void )
    {
        self.color = @"\e[0;33m";
        return self;
    };
    
    return [block copy];
}

- (LogoBlock)LIGHT_RED
{
    LogoBlock block = ^ Logo * ( void )
    {
        self.color = @"\e[1;31m";
        return self;
    };
    
    return [block copy];
}

- (LogoBlock)LIGHT_BLUE
{
    LogoBlock block = ^ Logo * ( void )
    {
        self.color = @"\e[1;34m";
        return self;
    };
    
    return [block copy];
}

- (LogoBlock)LIGHT_CYAN
{
    LogoBlock block = ^ Logo * ( void )
    {
        self.color = @"\e[1;36m";
        return self;
    };
    
    return [block copy];
}

- (LogoBlock)LIGHT_GREEN
{
    LogoBlock block = ^ Logo * ( void )
    {
        self.color = @"\e[1;32m";
        return self;
    };
    
    return [block copy];
}

- (LogoBlock)LIGHT_YELLOW
{
    LogoBlock block = ^ Logo * ( void )
    {
        self.color = @"\e[1;33m";
        return self;
    };
    
    return [block copy];
}

@end
