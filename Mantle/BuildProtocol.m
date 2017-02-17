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

@implementation BuildProtocol

- (BOOL)parseString:(NSString *)content {
    return YES;
}

- (NSString *)h {
    NSMutableString *code = [NSMutableString string];
    code.LINE(@"//");
    code.LINE(@"//  %@.h", self.fileName);
    code.LINE(@"//");
    code.LINE(@"//");
    code.LINE(@"//  Created by haozhiyu on %@.", [[NSDate date] stringWithDateFormat:@"yyyy/MM/dd"]);
    code.LINE(@"//  Copyright © %@年 haozhiyu. All rights reserved.", [[NSDate date] stringWithDateFormat:@"yyyy"]);
    code.LINE(@"//");

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
    
    return code;
}

@end
