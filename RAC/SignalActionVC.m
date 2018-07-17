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

    self.dataSources = @[@{ @"type" : @"Method", @"className" : @"map", @"desc" : @"map"},
                         @{ @"type" : @"Method", @"className" : @"zip", @"desc" : @"zip"},
                         @{ @"type" : @"Method", @"className" : @"concat", @"desc" : @"concat"},
                         ];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataSources[indexPath.row];
    
    NSString *className = dict[@"className"];
    NSString *type = dict[@"type"];
    
    if ([type isEqualToString:@"Method"]) {
        
        SEL sel = NSSelectorFromString(className);
        
        [self performSelector:sel];
        
    } else {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    
}

- (void)map {
    
    // map可以将返回值进行映射，可以用来解决返回和需要的数据不一致的情况
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@(1)];
            [subscriber sendCompleted];
        });
       
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"dispose");
        }];
    }];
      
    [[signal map:^id _Nullable(NSNumber * _Nullable value) {
        if (value.intValue == 1) {
            return @"one";
        }
        return @"";
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"map number to string : %@",x);
    }];
}

- (void)zip {
    
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@(1)];
        [subscriber sendNext:@(2)];
        [subscriber sendNext:@(3)];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"dispose");
        }];
        
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@"aaa"];
        [subscriber sendNext:@"bbb"];
        
        [[RACScheduler mainThreadScheduler] afterDelay:2 schedule:^{
            [subscriber sendNext:@"ccc"];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"dispose");
        }];
    }];
    
    /* zip with
     * 分别订阅两个信号，两个信号的value，分别保存在两个变量中，如果两个变量都不为空，将两个value打包（zip）传给新的信号，
     * 清空两个变量，重复。
     *
     * 新的信号一定是在两个信号都有值才会触发，因此可以来完成一些有前置条件要求的任务。
     * A和B都完成了，才进行C
     */
    [[signalA zipWith:signalB] subscribeNext:^(id  _Nullable x) {
        NSLog(@"zip x=%@",x);
    }];
}

- (void)concat {
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@(1)];
        [subscriber sendNext:@(2)];
        [subscriber sendNext:@(3)];
        
        // 如果不调用sendCompleted，signalB不会触发
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"dispose signalA");
        }];
        
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@"aaa"];
        [subscriber sendNext:@"bbb"];
        
        [[RACScheduler mainThreadScheduler] afterDelay:2 schedule:^{
            [subscriber sendNext:@"ccc"];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"dispose signalB");
        }];
    }];
    
    // signalA执行完成才会进行signalB
    // concat使两个信号变成串行
    [[signalA concat:signalB] subscribeNext:^(id  _Nullable x) {
        NSLog(@"concat x=%@",x);
    }];
}

- (void)not {
    // not: 取反
    [RACObserve(self.view, hidden).not subscribeNext:^(NSNumber * _Nullable x) {
        NSLog(@"not x = %@", x);
    }];
}

@end
