//
//  DelegateVC.m
//  LearnRAC
//
//  Created by xiaoniu on 2018/7/5.
//  Copyright © 2018年 com.learn. All rights reserved.
//

#import "DelegateVC.h"
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface DelegateVC () <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *dataSources;

@end

@implementation DelegateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataSources = @[@{ @"type" : @"UIViewController", @"className" : @"UIViewController", @"desc" : @"空白的ViewController"}];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [[self rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:) fromProtocol:@protocol(UITableViewDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"xx %@",x);
    }];
    
    self.tableView.delegate = self;
}

- (void)setDataSources:(NSArray *)dataSources {
    _dataSources = dataSources;
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataSources[indexPath.row];
    
    NSString *desc = dict[@"desc"];
    NSString *className = dict[@"className"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = className;
    cell.detailTextLabel.text = desc;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSDictionary *dict = self.dataSources[indexPath.row];
//    
//    NSString *type = dict[@"type"];
//    NSString *className = dict[@"className"];
//    
//    if ([type isEqualToString:@"UIViewController"]) {
//        
//        UIViewController *vc = [NSClassFromString(className) new];
//        
//        [self.navigationController pushViewController:vc animated:YES];
//    } else if ([type isEqualToString:@"UIView"]) {
//        
//        UIView *view = [NSClassFromString(className) new];
//        
//        UIViewController *vc = [UIViewController new];
//        
//        view.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1];
//        
//        [vc.view addSubview:view];
//        
//        [view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.mas_equalTo(view);
//        }];
//        
//    } else {
//        
//    }
//}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
    }
    return _tableView;
}

@end
