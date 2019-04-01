//
//  SelectorVC.m
//  LearnRAC
//
//  Created by xiaoniu on 2019/4/1.
//  Copyright © 2019 com.learn. All rights reserved.
//

#import "SelectorVC.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface SelectorVC ()

@end

@implementation SelectorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [[self rac_signalForSelector:@selector(viewDidAppear:)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"viewDidAppear:"); 
    }];
}


@end
