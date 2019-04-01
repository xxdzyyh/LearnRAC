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
    
    self.dataSources = @[@{ @"type" : @"UIViewController", @"className" : @"InstantViewController", @"desc" : @"RAC学习第一步"},
                         @{ @"type" : @"UIViewController", @"className" : @"KVOVC", @"desc" : @"rac实现kvo"},
                         @{ @"type" : @"UIViewController", @"className" : @"DelegateVC", @"desc" : @"rac实现deleagte"},
                         @{ @"type" : @"UIViewController", @"className" : @"SelectorVC", @"desc" : @"rac监听方法执行"},
                         @{ @"type" : @"UIViewController", @"className" : @"SubjectVC", @"desc" : @"RACSubject"},
                         @{ @"type" : @"UIViewController", @"className" : @"EventVC", @"desc" : @"rac实现事件监听"},
                         @{ @"type" : @"UIViewController", @"className" : @"SignalVC", @"desc" : @"rac信号"},
                         @{ @"type" : @"UIViewController", @"className" : @"TimerVC", @"desc" : @"rac实现timer"},
                         @{ @"type" : @"UIViewController", @"className" : @"SignalActionVC", @"desc" : @"信号操作"},
                         @{ @"type" : @"UIViewController", @"className" : @"PersonInfoVC", @"desc" : @"数据绑定"},
                         @{ @"type" : @"UIViewController", @"className" : @"TestSwizzle", @"desc" : @"数据绑定"}
                         ];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataSources[indexPath.row];

    NSString *className = dict[@"className"];
    
    if ([className isEqualToString:@"TestSwizzle"]) {
        [NSClassFromString(className) new];
    } else {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

@end
