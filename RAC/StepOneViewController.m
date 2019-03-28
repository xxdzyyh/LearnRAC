//
//  StepOneViewController.m
//  LearnRAC
//
//  Created by xiaoniu on 2019/2/22.
//  Copyright © 2019 com.learn. All rights reserved.
//

#import "StepOneViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface StepOneViewController ()


@end

@implementation StepOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.backgroundColor = [UIColor orangeColor];
    button.frame = CGRectMake(100, 100, 100, 100);
    
    [self.view addSubview:button];

    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"方便面流水线启动");
        [self start];
    }];
}

- (void)start {
    @weakify(self);
    
    // 放入鸡蛋
    RACSignal *eggSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        for (int i=0; i<5; i++) {
            NSString *string = [NSString stringWithFormat:@"%dth egg",i];
            NSLog(@"%@",string);
            [subscriber sendNext:string];
        }
        
        RACDisposable *disposable = [RACDisposable disposableWithBlock:^{
            NSLog(@"no egg"); 
            [subscriber sendCompleted];
        }];
        
        [self.rac_deallocDisposable addDisposable:disposable];
        
        return [RACDisposable disposableWithBlock:^{
            @strongify(self);
            [self.rac_deallocDisposable removeDisposable:disposable];
        }];
    }];
    
    // 放入面包
    RACSignal *noodelSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
       
        for (int i=0; i<4; i++) {
            NSString *string = [NSString stringWithFormat:@"%dth noodle",i];
            NSLog(@"%@",string);
            [subscriber sendNext:string];
        }
        
        RACDisposable *disposable = [RACDisposable disposableWithBlock:^{
            NSLog(@"no noodle"); 
            [subscriber sendCompleted];
        }];
        
        [self.rac_deallocDisposable addDisposable:disposable];
        
        return [RACDisposable disposableWithBlock:^{
            @strongify(self);
            [self.rac_deallocDisposable removeDisposable:disposable];
        }];
    }];
    
    // 将鸡蛋和面条放到一个包装里
    RACSignal *package = [eggSignal zipWith:noodelSignal];
    
    [package subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

@end
