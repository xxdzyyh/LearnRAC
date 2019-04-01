//
//  SencondVC.h
//  LearnRAC
//
//  Created by xiaoniu on 2019/4/1.
//  Copyright © 2019 com.learn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface SencondVC : UIViewController

@property (nonatomic, strong) RACSubject *delegateSubject;
@property (nonatomic, strong) RACSignal *delegateSignal;

@end

NS_ASSUME_NONNULL_END
