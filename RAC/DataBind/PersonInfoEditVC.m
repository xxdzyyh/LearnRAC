//
//  PersonInfoEditVC.m
//  LearnRAC
//
//  Created by xiaoniu on 2018/7/9.
//  Copyright © 2018年 com.learn. All rights reserved.
//

#import "PersonInfoEditVC.h"
#import "Person.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface PersonInfoEditVC ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;

@end

@implementation PersonInfoEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self fill];
}

- (IBAction)save:(id)sender {
    self.person.name = self.nameTextField.text;
    self.person.age = self.ageTextField.text.intValue;
}

- (void)fill {
    self.nameTextField.text = self.person.name;
    self.ageTextField.text = [NSString stringWithFormat:@"%d",self.person.age];
}

@end
