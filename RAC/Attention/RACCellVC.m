//
//  RACCellVC.m
//  LearnRAC
//
//  Created by xiaoniu on 2018/7/19.
//  Copyright © 2018年 com.learn. All rights reserved.
//

#import "RACCellVC.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface CellModel : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *detailLabel;

@end

@implementation CellModel

@end


@interface RACCellVC ()

@property (strong, nonatomic) NSArray *dataSources;

@end

@implementation RACCellVC

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CellModel *model = self.dataSources[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    /**
     * 默认信号会在dealloc的时候dispose
     */
    RAC(cell.textLabel, text) = [RACObserve(model, title) takeUntil:cell.rac_prepareForReuseSignal];
    
    return cell;
}


@end
