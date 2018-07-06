//
//  KVOVC.m
//  LearnRAC
//
//  Created by xiaoniu on 2018/7/5.
//  Copyright © 2018年 com.learn. All rights reserved.
//

#import "KVOVC.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface KVOVC ()

@end

@implementation KVOVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additbional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataSources = @[@{ @"type" : @"UIViewController", @"className" : @"UIViewController", @"desc" : @"空白的ViewController"}];

    // 两种写法其实是一致的
     [self function1];
//    [self function2];
}

- (void)function1 {
    [[self.tableView rac_valuesForKeyPath:@"contentOffset" observer:self] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@ %@",NSStringFromClass([x class]),x);
    }];
}

- (void)function2 {
    [RACObserve(self.tableView, contentOffset) subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@ %@",NSStringFromClass([x class]),x);
    }];
}

- (void)cancelKVO {
    RACSignal *signal = [self.tableView rac_valuesForKeyPath:@"contentOffset" observer:self];
    
    __block RACDisposable *disposable = [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@ %@",NSStringFromClass([x class]),x);
        
        [disposable dispose];
    }];
}

@end
