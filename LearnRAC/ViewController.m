//
//  ViewController.m
//  LearnRAC
//
//  Created by xiaoniu on 2018/7/5.
//  Copyright © 2018年 com.learn. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dataSources = @[@{ @"type" : @"UIViewController", @"className" : @"KVOVC", @"desc" : @"rac实现kvo"},
                         @{ @"type" : @"UIViewController", @"className" : @"DelegateVC", @"desc" : @"rac实现deleagte"},
                         @{ @"type" : @"UIViewController", @"className" : @"EventVC", @"desc" : @"rac实现事件监听"},
                         @{ @"type" : @"UIViewController", @"className" : @"SignalVC", @"desc" : @"rac信号"},
                         @{ @"type" : @"UIViewController", @"className" : @"TimerVC", @"desc" : @"rac实现timer"},
                         @{ @"type" : @"UIViewController", @"className" : @"SignalActionVC", @"desc" : @"信号操作"},
                         @{ @"type" : @"UIViewController", @"className" : @"PersonInfoVC", @"desc" : @"双向绑定"}];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
