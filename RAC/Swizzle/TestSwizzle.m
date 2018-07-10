//
//  TestSwizzle.m
//  LearnRAC
//
//  Created by xiaoniu on 2018/7/10.
//  Copyright © 2018年 com.learn. All rights reserved.
//

#import "TestSwizzle.h"
#import <objc/runtime.h>

@implementation TestSwizzle

- (instancetype)init {
    self = [super init];
    if (self) {
        NSObject *obj = [NSObject new];
        
        NSLog(@"[obj class] : %@",[obj class]);
        NSLog(@"object_getClassName() : %s",object_getClassName(obj));
        
        object_setClass(obj, [TestSwizzle class]);
     
        NSLog(@"[obj class] : %@",[obj class]);
        NSLog(@"object_getClassName() : %s",object_getClassName(obj));
    }
    return self;
}

@end
