//
//  TimerVC.m
//  LearnRAC
//
//  Created by xiaoniu on 2018/7/6.
//  Copyright © 2018年 com.learn. All rights reserved.
//

#import "TimerVC.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface TimerVC ()

@end

@implementation TimerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self delay];

    [self timer1];
    [self timerStopBeforeDealloc];
}

- (void)dealloc {
    NSLog(@"TimerVC dealloc");
}

- (void)delay {
    [[RACScheduler mainThreadScheduler] afterDelay:2 schedule:^{
        NSLog(@"main thread after delay 2");
    }];
}

- (void)timer1 {
    // 这个timer会一直触发，即使当前viewController已经被回收了
    [[RACSignal interval:2 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        NSLog(@"RAC timer 1 ...");
    }];
}

- (void)timerStopBeforeDealloc {
    // 在收到self.rac_willDeallocSignal信号时，timer信号会被停掉
    [[[RACSignal interval:2 onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSDate * _Nullable x) {
        NSLog(@"RAC timer 2 ...");
    }];
}

@end
