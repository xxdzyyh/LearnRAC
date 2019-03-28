//
//  SignalVC.m
//  LearnRAC
//
//  Created by xiaoniu on 2018/7/6.
//  Copyright © 2018年 com.learn. All rights reserved.
//

#import "SignalVC.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface SignalVC () {
    id block;
}

@property (strong, nonatomic) RACSignal *signal;

@end

@implementation SignalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@(arc4random())];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"disposable");
        }];
    }];
        
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"x1 : %@",x);
    }];
    
    self.signal = signal;
}


@end
