//
//  SencondVC.m
//  LearnRAC
//
//  Created by xiaoniu on 2019/4/1.
//  Copyright © 2019 com.learn. All rights reserved.
//

#import "SencondVC.h"
#import <Masonry/Masonry.h>

@interface SencondVC ()

@end

@implementation SencondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [button setTitle:@"点我" forState:UIControlStateNormal];
    
    @weakify(self);
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        // 可以在很多个地方调用
        if (self.delegateSubject) {
            [self.delegateSubject sendNext:@1];
        }
    }];
    
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
        
    // 如果有多个地方需要代理，传递delegateSignal的方式就不是很方便
    self.delegateSignal = [button rac_signalForControlEvents:UIControlEventTouchUpInside];
}

@end
