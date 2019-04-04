//
//  CommandVC.m
//  LearnRAC
//
//  Created by xiaoniu on 2019/4/3.
//  Copyright © 2019 com.learn. All rights reserved.
//

#import "CommandVC.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface CommandVC () {
    RACCommand *command;
}

@property (nonatomic, strong) UISwitch *switchView;

@end

@implementation CommandVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.switchView.frame = CGRectMake(150, 150, 60, 30);
    [self.view addSubview:self.switchView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [button setTitle:@"Signal" forState:UIControlStateNormal];
    
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self signalWithPara:@{@"key":@"signal"}];  
    }];
    
    button.frame = CGRectMake(50, 100, 60, 30);
    
    [self.view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [button1 setTitle:@"Command" forState:UIControlStateNormal];
    
    [[button1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self command];  
    }];
    
    button1.frame = CGRectMake(150, 100, 80, 30);
    
    [self.view addSubview:button1];
}

- (void)signalWithPara:(NSDictionary *)para {
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [self sendRequestWithPara:para complete:^(BOOL success) {
            if (success) {
                [subscriber sendNext:@(1)];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:[NSError errorWithDomain:NSURLErrorDomain code:1 userInfo:nil]];
            }
        }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"sigal x=%@",x); 
    }];
}

- (void)command {
    /**
     A command is a signal triggered in response to some action, typically UI-related.
     
     */
    command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            [self sendRequestWithPara:input complete:^(BOOL success) {
                if (success) {
                    [subscriber sendNext:@(1)];
                    [subscriber sendCompleted];
                } else {
                    [subscriber sendError:[NSError errorWithDomain:NSURLErrorDomain code:1 userInfo:nil]];
                }
            }];
            
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
    }];
    
    [command.executionSignals subscribeNext:^(RACSignal* innerSignal) {
        NSLog(@"executionSignals subscribeNext");
        [innerSignal subscribeNext:^(id  _Nullable x) {
            NSLog(@"executionSignals x=%@",x); 
        }];
    }];
    
    [command.errors subscribeNext:^(NSError * _Nullable x) {
        NSLog(@"errors x=%@",x);
    }];
    
    [command execute:@{@"paras":@"value"}];
}


- (void)enableCommand {
    
    RACSignal *enbaleSignal = RACObserve(self.switchView, isOn);
    
    RACCommand *command = [[RACCommand alloc] initWithEnabled:enbaleSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            [self sendRequestWithPara:input complete:^(BOOL success) {
                if (success) {
                    [subscriber sendNext:@(1)];
                    [subscriber sendCompleted];
                } else {
                    [subscriber sendError:[NSError errorWithDomain:NSURLErrorDomain code:1 userInfo:nil]];
                }
            }];
            
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
    }];
    
    [command.enabled subscribeNext:^(NSNumber * _Nullable x) {
        NSLog(@"command.enabled x=%@",x); 
    }];
    
    [command.executionSignals subscribeNext:^(RACSignal* innerSignal) {
        NSLog(@"executionSignals subscribeNext");
        [innerSignal subscribeNext:^(id  _Nullable x) {
            NSLog(@"executionSignals x=%@",x); 
        }];
    }];
    
    [command.errors subscribeNext:^(NSError * _Nullable x) {
        NSLog(@"errors x=%@",x);
    }];
    
    [command execute:@{@"paras":@"value"}];
}

- (void)sendRequestWithPara:(NSDictionary *)para complete:(void(^)(BOOL))completion {
    sleep(2);
    completion(arc4random()/2%2);
}


- (UISwitch *)switchView {
    if (_switchView == nil) {
        _switchView = [[UISwitch alloc] init];
    }
    return _switchView;
}
@end
