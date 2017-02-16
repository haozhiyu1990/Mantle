//
//  main.m
//  Mantle
//
//  Created by haozhiyu on 2017/2/16.
//  Copyright © 2017年 haozhiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Build.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Build *build = [[Build alloc] init];
        
        [build argc:argc argv:argv];
    }
    return 0;
}
