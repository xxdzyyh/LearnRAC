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
    [self not];
}

- (void)map {
    
    // map可以将返回值进行映射，可以用来解决返回和需要的数据不一致的情况
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@(1)];
            [subscriber sendCompleted];
        });
       
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"dispose");
        }];
        
    }] map:^id _Nullable(NSNumber * _Nullable value) {
        if (value.intValue == 1) {
            return @"one";
        }
        return @"";
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"map number to string : %@",x);
    }] ;
}

- (void)not {
    // not: 取反
    [RACObserve(self.view, hidden).not subscribeNext:^(NSNumber * _Nullable x) {
        NSLog(@"not x = %@", x);
    }];
}

@end
