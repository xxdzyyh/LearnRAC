//
//  SignalActionVC.m
//  LearnRAC
//
//  Created by xiaoniu on 2018/7/6.
//  Copyright © 2018年 com.learn. All rights reserved.
//

#import "SignalActionVC.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface SignalActionVC ()

@end

@implementation SignalActionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    [self map];
}

- (void)map {
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@(1)];
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"dispose");
        }];
        
    }] map:^id _Nullable(NSNumber * _Nullable value) {
        if (value.intValue == 1) {
            return @"one";
        }
        return @"";
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"number to string : %@",x);
    }] ;
}

@end
