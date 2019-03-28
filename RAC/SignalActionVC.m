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

    self.dataSources = @[@{ @"type" : @"Method", @"className" : @"concat", @"desc" : @"concat"},
                         @{ @"type" : @"Method", @"className" : @"bind", @"desc" : @"bind"},
                         @{ @"type" : @"Method", @"className" : @"zipWith", @"desc" : @"zipWith"},
                         @{ @"type" : @"Method", @"className" : @"map", @"desc" : @"map"},
                         @{ @"type" : @"Method", @"className" : @"filter", @"desc" : @"filter"},
                         @{ @"type" : @"Method", @"className" : @"takeUntil", @"desc" : @"takeUntil"},
                         @{ @"type" : @"Method", @"className" : @"flattenMap", @"desc" : @"flattenMap"},
                         @{ @"type" : @"Method", @"className" : @"flatten", @"desc" : @"flatten"},
                         @{ @"type" : @"Method", @"className" : @"merge", @"desc" : @"merge"},
                         @{ @"type" : @"Method", @"className" : @"combineLatest", @"desc" : @"combineLatest"},
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

- (void)return {
    
}

- (void)bind {
    [[[self signalA] bind:^RACSignalBindBlock _Nonnull{
        return ^RACSignal *(id value,BOOL *stop) {
            return [self signalB];  
        };
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"bind x=%@",x);
    }];
}

- (void)concat {
    
    /**
     concat本意就是连接，a=[1,2] b=[3,4], a concat b => [1,2,3,4]
     
     第一个信号必须 sendCompleted,否则第二个信号不知道什么时候拼接上去
     
     SignalA         1       2      completed
     
     SignalB         B       C
    
     SignalConcat    1       2                     B     C
     */
    
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@(1)];
        [subscriber sendNext:@(2)];
        [subscriber sendNext:@(3)];
        
        // 如果不调用sendCompleted，signalB不会触发
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendCompleted];
        });
        
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

- (void)zipWith {
    RACSignal *signalA = [self signalA];
    RACSignal *signalB = [self signalB];
    
    /* zip with
     * 分别订阅两个信号，两个信号的value，分别保存在两个变量中，如果两个变量都不为空，将两个value打包（zip）传给新的信号，
     * 清空两个变量，重复。
     *
     * 新的信号一定是在两个信号都有值才会触发，因此可以来完成一些有前置条件要求的任务。
     * A和B都完成了，才进行C
     
     SignalA       1         2           3
     
     SignalB           B         C
     
     SignalZip       (1,B)      (2,C)
     
     */
    [[signalB zipWith:signalA] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x); 
    }];
}

- (void)map {
    /** 
     map可以将返回值进行映射，可以用来解决返回和需要的数据不一致的情况
    
     SignalA     1            2
     
     map         1 -> One
     
     SignalMap   one         ""
     */

    [[[self signalA] map:^id _Nullable(NSNumber * _Nullable value) {
        if (value.intValue == 1) {
            return @"one";
        }
        return @"";
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"map number to string : %@",x);
    }];
}

- (void)filter {
    
    /**
     signalA          1      2
    
     block            value > 1
    
     signalFilter            2
     */
    
    [[[self signalA] filter:^BOOL(id  _Nullable value) {
        if ([value integerValue] > 1) {
            return YES;
        } else {
            return NO;
        }
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (void)takeUntil {
    RACSubject *subjectA = [RACSubject subject];
    RACSubject *subjectB = [RACSubject subject];
    
    /**
     * takeUntilSignal = [signalA takeUntil:signalB] 
     * signalA在signalB触发前一直生效，一旦signalB触发，销毁signalAj
     *    
     * 在某些情况下，比如cell重用时，可能重复创建
     * RAC(cell.textLabel, text) = RACObserver(model, title)
     * 每次重用的时候，都添加了一个信号，这样会导致混乱，在重用前dispose掉之前的信号，保证每次只有一个信号
     * RAC(cell.textLabel, text) = [RACObserve(model, title) takeUntil:cell.rac_prepareForReuseSignal];
     */
    RACSignal *takeUntilSignal = [subjectA takeUntil:subjectB];
    
    [takeUntilSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"takeUntilSignal subscribeNext %@",x);
    }];
    
    [subjectA sendNext:@"aaa"];
    [subjectA sendNext:@"bbb"];
    [subjectB sendNext:@(1)];
    [subjectA sendNext:@"ccc"];
    [subjectB sendNext:@(2)];
    [subjectA sendNext:@"ddd"];
    
    // takeUntil是非常有用的，和UI相关的都需要注意signal的生存周期。
    
    // 在收到self.rac_willDeallocSignal的时候，干掉timer signal.
    [[[RACSignal interval:2 onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSDate * _Nullable x) {
        NSLog(@"RAC timer 2 ...");
    }];
}

- (void)flattenMap {
    /**
     在一个信号触发的时候将其映射为另外一个信号
     
     map只是将值进行了映射，flatten直接将信号进行了映射
     */
    [[[self signalA] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        return [self signalB];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"flattenMap x=%@",x);
    }] ;
}

- (void)flatten {
    [[[self signalA] flatten] subscribeNext:^(id  _Nullable x) {
        NSLog(@"flatten x=%@",x);
    }];
}


- (void)merge {
    /**
     将两个信号合并，任何一个信号变化，合并后的信号都会产生变化
     
     SignalA    1    2
     
     SignalB            A        B
     
     SignalC    1    2  A        B
     
     
     */
    [[[self signalA] merge:[self signalB]] subscribeNext:^(id  _Nullable x) {
        NSLog(@"merge x=%@",x);
    }];
}

- (void)combineLatest {
    /**
     
     记录单个信号最后发送的值，如果两个信号最后的值都存在，发送一个combineLatest信号
     
     SignalA    1    2
     
     SignalB            A        B
     
     SignalC          (2,A)     (2,B)
     */
    
    [[[self signalA] combineLatestWith:[self signalB]] subscribeNext:^(id  _Nullable x) {
        NSLog(@"combineLatest x=%@",x);
    }];
}

#pragma mark - 

- (RACSignal *)signalA {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@(1)];
        [subscriber sendNext:@(2)];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"dispose signalA");
        }];
    }];
}

- (RACSignal *)signalB {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"B"];
        [subscriber sendNext:@"C"];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"dispose signalB");
        }];
    }];
}

@end
