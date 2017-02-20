//
//  NSString+HzyExtension.m
//  Mantle
//
//  Created by haozhiyu on 2017/2/16.
//  Copyright © 2017年 haozhiyu. All rights reserved.
//

#import "NSString+HzyExtension.h"

#pragma mark -

@implementation NSString (HzyExtension)

@dynamic APPEND;
@dynamic LINE;
@dynamic REPLACE;

- (NSStringAppendBlock)APPEND
{
    NSStringAppendBlock block = ^ NSString * ( id first, ... )
    {
        va_list args;
        va_start( args, first );
        
        NSString * append = [[NSString alloc] initWithFormat:first arguments:args];
        
        NSMutableString * copy = [self mutableCopy];
        [copy appendString:append];
        
        va_end( args );
        
        return copy;
    };
    
    return [block copy];
}

- (NSStringAppendBlock)LINE
{
    NSStringAppendBlock block = ^ NSString * ( id first, ... )
    {
        NSMutableString * copy = [self mutableCopy];
        
        if ( first )
        {
            va_list args;
            va_start( args, first );
            
            NSString * append = [[NSString alloc] initWithFormat:first arguments:args];
            [copy appendString:append];
            
            va_end( args );
        }
        
        [copy appendString:@"\n"];
        
        return copy;
    };
    
    return [block copy];
}

- (NSStringReplaceBlock)REPLACE
{
    NSStringReplaceBlock block = ^ NSString * ( NSString * string1, NSString * string2 )
    {
        return [self stringByReplacingOccurrencesOfString:string1 withString:string2];
    };
    
    return [block copy];
}

- (BOOL)isKeywords {
    if ([self isEqualToString:@"description"] || [self isEqualToString:@"id"] || [self isEqualToString:@"class"]) {
        return YES;
    }
    return NO;
}

@end

#pragma mark -

@implementation NSMutableString (HzyExtension)

@dynamic APPEND;
@dynamic LINE;
@dynamic REPLACE;

- (NSMutableStringAppendBlock)APPEND
{
    NSMutableStringAppendBlock block = ^ NSMutableString * ( id first, ... )
    {
        va_list args;
        va_start( args, first );
        
        NSString * append = [[NSString alloc] initWithFormat:first arguments:args];
        
        va_end( args );
        
        if ( NO == [self isKindOfClass:[NSMutableString class]] )
        {
            NSMutableString * copy = [self mutableCopy];
            [copy appendString:append];
            
            return copy;
        }
        else
        {
            [self appendString:append];
            
            return self;
        }
    };
    
    return [block copy];
}

- (NSMutableStringAppendBlock)LINE
{
    NSMutableStringAppendBlock block = ^ NSMutableString * ( id first, ... )
    {
        NSString * append = nil;
        
        if ( first )
        {
            va_list args;
            va_start( args, first );
            
            append = [[NSString alloc] initWithFormat:first arguments:args];
            
            va_end( args );
        }
        
        if ( NO == [self isKindOfClass:[NSMutableString class]] )
        {
            NSMutableString * copy = [self mutableCopy];
            
            if ( append )
            {
                [copy appendString:append];
            }
            
            [copy appendString:@"\n"];
            
            return copy;
        }
        else
        {
            if ( append )
            {
                [self appendString:append];
            }
            
            [self appendString:@"\n"];
            
            return self;
        }
        
        return self;
    };
    
    return [block copy];
}

- (NSMutableStringReplaceBlock)REPLACE
{
    NSMutableStringReplaceBlock block = ^ NSMutableString * ( NSString * string1, NSString * string2 )
    {
        [self replaceOccurrencesOfString:string1
                              withString:string2
                                 options:NSCaseInsensitiveSearch
                                   range:NSMakeRange(0, self.length)];
        
        return self;
    };
    
    return [block copy];
}

@end
