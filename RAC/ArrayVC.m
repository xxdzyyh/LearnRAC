//
//  ArrayVC.m
//  LearnRAC
//
//  Created by xiaoniu on 2019/3/29.
//  Copyright © 2019 com.learn. All rights reserved.
//

#import "ArrayVC.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface ArrayVC ()

@end

@implementation ArrayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self test];
}

- (void)test {
    [[@[@1,@2,@3].rac_sequence signal] subscribeNext:^(id  _Nullable x) {
        NSLog(@"rac_sequence x=%@",x);
    }];
}

@end
