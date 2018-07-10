//
//  BaseTableViewVC.h
//  LearnRAC
//
//  Created by xiaoniu on 2018/7/5.
//  Copyright © 2018年 com.learn. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 dataSources的结构
 [
    {
        "type" : " 'UIViewController' or 'UIView' or ''"
        "className" : "ClassName"
        "desc" : "desc"
    }
 ]
 */
@interface BaseTableViewVC : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *dataSources;

@end
