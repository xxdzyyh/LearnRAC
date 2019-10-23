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
#import <objc/runtime.h>


@protocol ProtocolTest<NSObject>

- (BOOL)test;

@end

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
    
    self.tableView.delegate = self;
    
    BOOL useRAC = YES;
    
//     就这个情景而言，useRAC=YES和useRAC=NO效果相同
    if (useRAC) {
        [[self rac_signalForSelector:@selector(test) fromProtocol:@protocol(ProtocolTest)] subscribeNext:^(RACTuple * _Nullable x) {
            NSLog(@"%@",x);
        }];
    } else {
        [self addTestMethod];
    }    
}

- (void)addTestMethod {
    SEL selector = @selector(test);
    
    Method method = class_getInstanceMethod(self.class, selector);
    
    IMP imp = imp_implementationWithBlock(^{
        NSLog(@"ProtocolTest test");
    });
    
    BOOL addMethodResult = class_addMethod(self.class, selector, imp, method_getTypeEncoding(method));
    
    if (addMethodResult == YES) {
        NSLog(@"add method success");
    } else {
        NSLog(@"add method failure");
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSelector:@selector(test)];
}

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
