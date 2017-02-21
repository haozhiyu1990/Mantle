//
//  BuildProtocol.m
//  Mantle
//
//  Created by haozhiyu on 2017/2/16.
//  Copyright © 2017年 haozhiyu. All rights reserved.
//

#import "BuildProtocol.h"
#import "NSString+HzyExtension.h"
#import "NSDate+HzyExtension.h"
#import "JSONKit.h"

@implementation BuildProtocol

- (BOOL)parseString:(NSString *)content {
    
    content = [content stringByReplacingOccurrencesOfString:@"true" withString:@"\"bool\""];
    content = [content stringByReplacingOccurrencesOfString:@"false" withString:@"\"bool\""];
    
    NSError * error = NULL;
    NSObject * obj = [content objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:&error];
    if ( nil == obj || NO == [obj isKindOfClass:[NSDictionary class]] )
    {
        return NO;
    }
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)obj];
    
    self.classNameArr = [NSMutableArray array];
    self.classDic = [NSMutableDictionary dictionary];
    
    [self.classNameArr addObject:self.fileName];
    if ([[dict allKeys] containsObject:@"class"]) {
        [self.classNameArr addObjectsFromArray:[[dict objectForKey:@"class"] allKeys]];
    }
    
    if ([[dict allKeys] containsObject:@"model"]) {
        for (NSString * className in self.classNameArr) {
            if ([className isEqualToString:self.fileName]) {
                [self.classDic setObject:[dict objectForKey:@"model"] forKey:className];
            } else {
                [self.classDic setObject:[[dict objectForKey:@"class"] objectForKey:className] forKey:className];
            }
        }
    } else {
        return NO;
    }
    
    return YES;
}

- (NSString *)h {
    NSMutableString *code = [NSMutableString string];
    self.memberIsArrList = [NSMutableDictionary dictionary];

    code.LINE(@"//");
    code.LINE(@"//  %@.h", self.fileName);
    code.LINE(@"//");
    code.LINE(@"//");
    code.LINE(@"//  Created by haozhiyu on %@.", [[NSDate date] stringWithDateFormat:@"yyyy/MM/dd"]);
    code.LINE(@"//  Copyright © %@年 haozhiyu. All rights reserved.", [[NSDate date] stringWithDateFormat:@"yyyy"]);
    code.LINE(@"//");
    
    code.LINE(nil);
    code.LINE(@"#import <Mantle/Mantle.h>");
    code.LINE(nil);

    for (int i=1; i<self.classNameArr.count; i++) {
        code.LINE(@"@class %@;", self.classNameArr[i]);
    }
    
    for (NSString * currentClassName in self.classNameArr) {
        code.LINE(nil);
        code.LINE(@"#pragma mark - %@", currentClassName);
        code.LINE(nil);
        code.LINE(@"@interface %@ : MTLModel<MTLJSONSerializing>", currentClassName);
        code.LINE(nil);
        for (NSString * member in [[self.classDic objectForKey:currentClassName] allKeys]) {
            if ([[[self.classDic objectForKey:currentClassName] objectForKey:member] isKindOfClass:[NSString class]]) {
                if ([[[self.classDic objectForKey:currentClassName] objectForKey:member] isEqualToString:@"bool"]) {
                    code.LINE(@"@property (nonatomic, assign) \t\t\t\tBOOL \t\t\t\t\t  %@;", [member isKeywords] ? [member uppercaseString] : member);
                } else if ([[[self.classDic objectForKey:currentClassName] objectForKey:member] hasPrefix:@"{"] && [[[self.classDic objectForKey:currentClassName] objectForKey:member] hasSuffix:@"}"]) {
                    NSString * className = [[self.classDic objectForKey:currentClassName] objectForKey:member];
                    className = [className substringWithRange:NSMakeRange(1, className.length-2)];
                    code.LINE(@"@property (nonatomic, strong) \t\t\t\t%@ \t\t\t\t* %@;", className, [member isKeywords] ? [member uppercaseString] : member);
                } else {
                    code.LINE(@"@property (nonatomic, copy) \t\t\t\tNSString \t\t\t\t* %@;", [member isKeywords] ? [member uppercaseString] : member);
                }
            } else if ([[[self.classDic objectForKey:currentClassName] objectForKey:member] isKindOfClass:[NSNumber class]]) {
                code.LINE(@"@property (nonatomic, strong) \t\t\t\tNSNumber \t\t\t\t* %@;", [member isKeywords] ? [member uppercaseString] : member);
            } else if ([[[self.classDic objectForKey:currentClassName] objectForKey:member] isKindOfClass:[NSArray class]]) {
                NSArray *arr = [[self.classDic objectForKey:currentClassName] objectForKey:member];
                NSString *memberDicName = [arr firstObject];
                if ([memberDicName hasPrefix:@"{"] && [memberDicName hasSuffix:@"}"]) {
                    memberDicName = [memberDicName substringWithRange:NSMakeRange(1, memberDicName.length-2)];
                    [self.memberIsArrList setObject:memberDicName forKey:member];
                    code.LINE(@"@property (nonatomic, strong) \t\t\t\tNSArray<%@ *> \t\t\t\t* %@;",memberDicName , [member isKeywords] ? [member uppercaseString] : member);
                } else {
                    code.LINE(@"@property (nonatomic, strong) \t\t\t\tNSArray \t\t\t\t* %@;", [member isKeywords] ? [member uppercaseString] : member);
                }
            }
        }
        code.LINE(nil);
        code.LINE(@"@end");
        code.LINE(nil);
    }

    return code;
}

- (NSString *)m {
    NSMutableString *code = [NSMutableString string];
    code.LINE(@"//");
    code.LINE(@"//  %@.m", self.fileName);
    code.LINE(@"//");
    code.LINE(@"//");
    code.LINE(@"//  Created by haozhiyu on %@.", [[NSDate date] stringWithDateFormat:@"yyyy/MM/dd"]);
    code.LINE(@"//  Copyright © %@年 haozhiyu. All rights reserved.", [[NSDate date] stringWithDateFormat:@"yyyy"]);
    code.LINE(@"//");
    
    code.LINE(nil);
    code.LINE(@"#import \"%@.h\"", self.fileName);
    code.LINE(nil);
    
    for (NSString * currentClassName in self.classNameArr) {
        code.LINE(nil);
        code.LINE(@"#pragma mark - %@", currentClassName);
        code.LINE(nil);
        code.LINE(@"@implementation %@", currentClassName);
        code.LINE(nil);
        code.LINE(@"+ (NSDictionary *)JSONKeyPathsByPropertyKey {");
        code.LINE(@"\treturn\t\t@{");
        NSArray *memberArr = [[self.classDic objectForKey:currentClassName] allKeys];
        for (int i=0; i<memberArr.count; i++) {
            NSString *member = memberArr[i];
            if (i == memberArr.count-1) {
                code.LINE(@"\t\t\t\t@\"%@\" : @\"%@\"", [member isKeywords] ? [member uppercaseString] : member, member);
            } else {
                code.LINE(@"\t\t\t\t@\"%@\" : @\"%@\",", [member isKeywords] ? [member uppercaseString] : member, member);
            }
        }
        
        code.LINE(@"\t\t\t\t};");
        code.LINE(@"}");
        code.LINE(nil);
        for (NSString * member in [[self.classDic objectForKey:currentClassName] allKeys]) {
            for (NSString * memberDic in [self.memberIsArrList allKeys]) {
                if ([member isEqualToString:memberDic]) {
                    code.LINE(@"+ (NSValueTransformer *)%@JSONTransformer {", member);
                    code.LINE(@"\treturn [MTLJSONAdapter arrayTransformerWithModelClass:%@.class];", [self.memberIsArrList objectForKey:member]);
                    code.LINE(@"}");
                    code.LINE(nil);
                }
            }
        }
        code.LINE(nil);
        code.LINE(@"@end");
        code.LINE(nil);
    }

    return code;
}

@end
