//
//  PersonInfoVC.m
//  LearnRAC
//
//  Created by xiaoniu on 2018/7/9.
//  Copyright © 2018年 com.learn. All rights reserved.
//

#import "PersonInfoVC.h"
#import "Person.h"
#import "PersonInfoEditVC.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface PersonInfoVC ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) Person *person;
@end

@implementation PersonInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.person = [Person new];
    
    self.person.name = @"nameone";
    self.person.age = 18;

    [self oneWayBind];
}

- (void)oneWayBind {
    
    NSUInteger type = 0;
    
    // 单向绑定 self.person.age被修改，self.ageLabel.text也会随着改变
    // 为了方便使用，提供了两个宏RAC、RACObserve，一般使用宏就可以，但是也要取了解这些宏到底干了什么
    switch (type) {
        case 0: {
            RAC(self.ageLabel, text) = [RACObserve(self.person, age) map:^id _Nullable(NSNumber *value) {
                return [value stringValue];
            }];
        }
            break;
        case 1: {
            RAC(self.ageLabel, text) = [[self.person rac_valuesForKeyPath:@"age" observer:self] map:^id _Nullable(NSNumber *value) {
                return [value stringValue];
            }];
        }
            break;
        case 2: {
            RACSignal *signal =  [RACObserve(self.person, age) map:^id _Nullable(NSNumber *value) {
                return [value stringValue];
            }];
            
            /**
             * 宏RAC的等价写法
             */
            [signal setKeyPath:@"text" onObject:self.ageLabel nilValue:nil];
        }
            break;
        default:
            break;
    }
}

- (void)twoWayBind {
    // 类型相同，直接等于就可以
    RACChannelTo(self.nameLabel,text) = RACChannelTo(self.person,name);
    
    // 使用基本类型，在这个位置会被转换为NSNumber,NSNumber和NSString不是相同的类型，下面的语句会闪退
    // RACChannelTo(self.ageLabel,text) = RACChannelTo(self.person,age);
    RACChannelTerminal *channelA = RACChannelTo(self.ageLabel,text);
    RACChannelTerminal *channelB = RACChannelTo(self.person,age);
    
    [[channelA map:^id _Nullable(NSString *value) {
        return @([value intValue]);
    }] subscribe:channelB];
    
    [[channelB map:^id _Nullable(NSNumber *value) {
        return [value stringValue];
    }] subscribe:channelA];
}

- (IBAction)editPersonInfo:(id)sender {
    PersonInfoEditVC *vc = [PersonInfoEditVC new];
    
    vc.person = self.person;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)randomName:(id)sender {

    NSArray *array = @[@"北方的风",@"喵喵喵"];
    
    self.nameLabel.text = [array objectAtIndex:arc4random()%2];
}

- (IBAction)randomAge:(id)sender {

    self.ageLabel.text = [@(arc4random()%18) stringValue];
}

@end
