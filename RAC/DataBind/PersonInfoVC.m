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

    [self bind];
}

- (void)bind {
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
