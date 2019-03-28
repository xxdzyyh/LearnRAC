//
//  InstantViewController.m
//  LearnRAC
//
//  Created by xiaoniu on 2019/2/22.
//  Copyright © 2019 com.learn. All rights reserved.
//

#import "InstantViewController.h"
#import <ReactiveObjC.h>

@interface InstantViewController () {
    int _eggCount;
    int _noodleCount;
    int _condimentCount;
}

@property (weak, nonatomic) IBOutlet UIButton *mainButton;
@property (weak, nonatomic) IBOutlet UIButton *eggButton;
@property (weak, nonatomic) IBOutlet UIButton *noodleButton;
@property (weak, nonatomic) IBOutlet UIButton *condimentButton;
@property (weak, nonatomic) IBOutlet UILabel *eggLabel;
@property (weak, nonatomic) IBOutlet UILabel *noodleLabel;
@property (weak, nonatomic) IBOutlet UILabel *condimentLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *failProductLabel;

@property (assign, nonatomic) int eggCount;
@property (assign, nonatomic) int noodleCount;
@property (assign, nonatomic) int condimentCount;
@property (assign, nonatomic) NSInteger productCount;
@property (assign, nonatomic) NSInteger failProductCount;

@end

@implementation InstantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // RACObserve(self, eggCount) 对应的值是NSNumber,RAC(self.eggLabel,text)需要的是NSString,需要做map操作
    RAC(self.eggLabel,text) = [RACObserve(self, eggCount) map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:@"%@",value];
    }];
    
    RAC(self.noodleLabel,text) = [RACObserve(self, noodleCount) map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:@"%@",value];
    }];
    
    RAC(self.condimentLabel,text) = [RACObserve(self, condimentCount) map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:@"%@",value];
    }];
    
    RAC(self.totalLabel,text) = [RACObserve(self, productCount) map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:@"成功组装了%@桶方便面",value];
    }];
    
    RAC(self.failProductLabel,text) = [RACObserve(self, failProductCount) map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:@"失败了%@桶方便面",value];
    }];
    
    @weakify(self);
    RACSignal *eggSignal = [[self.eggButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"放入一个鸡蛋");
        x.tag = 40+arc4random()%5;
        @strongify(self);
        self.eggCount++;
    }];
    RACSignal *noodleSignal = [[self.noodleButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"放入一个面饼");
        x.tag = 60+arc4random()%5;
        self.noodleCount++;
    }];
    RACSignal *condimentSignal = [[self.condimentButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"放入一包调料");
        x.tag = 10+arc4random()%5;
        @strongify(self);
        self.condimentCount++;
    }];

    RACSignal *productSignal = [[eggSignal zipWith:noodleSignal] zipWith:condimentSignal];
    
    //filter 符合添加值才会发送给订阅者
    [[productSignal filter:^BOOL(id  _Nullable value) {
        RACTwoTuple *tuple = value;
        
        RACTwoTuple *tuple1 = tuple.first;
        UIControl *control1 = tuple1.first;
        UIControl *control2 = tuple1.second;
        UIControl *control3 = tuple.second;
        
        NSInteger weight = control1.tag + control2.tag + control3.tag;
        
        NSLog(@"(%zd,%zd,%zd)=%zd",control1.tag,control2.tag,control3.tag,weight);
        
        if (weight < 110+6 && weight > 110-5) {
            // 重量合适
            return YES;
        } else {
            // 太重或者太轻不符合条件
            self.eggCount--;
            self.noodleCount--;
            self.condimentCount--;
            NSLog(@"本次组装失败了");
            self.failProductCount++;
            
            return NO;
        }
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",@"组装了一桶方便面"); 
        @strongify(self);
        self.eggCount--;
        self.noodleCount--;
        self.condimentCount--;
        self.productCount++;
    }];    
}

@end

