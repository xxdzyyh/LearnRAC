//
//  SubjectVC.m
//  LearnRAC
//
//  Created by xiaoniu on 2019/4/1.
//  Copyright © 2019 com.learn. All rights reserved.
//

#import "SubjectVC.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "SencondVC.h"

@interface SubjectVC ()

@end

@implementation SubjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    /**
     一般而言，信号是由事件产生的，比如点击按钮，RACSubject自给自足，可以发送信号，可以被订阅。
     
     subject = event + signal。
     
     如果事件转换为信号不是太方便，那么可以使用RACSubject.
     
     冷信号是被动的，只会在被订阅时向订阅者发送通知，订阅者会在订阅时收到完全相同的序列
     热信号是主动的，它可以在任意时间发出通知，与订阅者的订阅时间无关，只会收到在订阅之后发出的序列
     */
    RACSubject *subject = [[RACSubject alloc] init];
    
    [subject subscribeNext:^(id  _Nullable x) {
        [self pushToSomeVC];
    }];
    
    // 发送信号
    [subject sendNext:@1];
}

- (void)pushToSomeVC {
    SencondVC *vc = [[SencondVC alloc] init];    
    
    vc.delegateSubject = [RACSubject subject];
    
    [vc.delegateSubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"delegateSubject callback");
    }];
    
    // 延迟一点，因为 delegateSignal 在 viewDidLoad 赋值
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [vc.delegateSignal subscribeNext:^(id  _Nullable x) {
            NSLog(@"delegateSignal callback"); 
        }];
    });
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
