//
//  MOLOfficHelperViewController.m
//  reward
//
//  Created by moli-2017 on 2018/9/21.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLOfficHelperViewController.h"
#import "MOLOfficMsgCell.h"

@interface MOLOfficHelperViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@end

@implementation MOLOfficHelperViewController

- (BOOL)showNavigationLine
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSourceArray = [NSMutableArray array];
    [self setupOfficHelperViewControllerUI];
    [self setNavigationBar];
    [self request_getHelperList];
}

#pragma mark - 网络请求
- (void)request_getHelperList
{
    for (NSInteger i = 0; i < 10; i++) {
        MOLOfficMsgModel *model = [MOLOfficMsgModel new];
        model.image = @"message_youshang";
        model.name = @"CC小助手";
        NSString *str1 = @"CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手";
        NSString *str2 = @"CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手";
        NSString *str3 = @"CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手CC小助手";
        if (i % 3 == 1) {
            model.messageBody = str1;
        }else if (i % 3 == 2){
            model.messageBody = str2;
        }else{
            model.messageBody = str3;
        }
        
        model.createTime = @"2018-9-21";
        
        model.type = i%2;
        
        [self.dataSourceArray addObject:model];
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MOLOfficMsgModel *model = self.dataSourceArray[indexPath.row];
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MOLOfficMsgModel *model = self.dataSourceArray[indexPath.row];
    MOLOfficMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MOLOfficMsgCell_id"];
    cell.officModel = model;
    return cell;
}

#pragma mark - 导航条
- (void)setNavigationBar
{
    [self basevc_setCenterTitle:@"CC小助手" titleColor:HEX_COLOR(0xffffff)];
}

#pragma mark - UI
- (void)setupOfficHelperViewControllerUI
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
    _tableView = tableView;
    tableView.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[MOLOfficMsgCell class] forCellReuseIdentifier:@"MOLOfficMsgCell_id"];
    [self.view addSubview:tableView];
}

- (void)calculatorOfficHelperViewControllerFrame
{
    self.tableView.frame = self.view.bounds;
    self.tableView.height = self.view.height - MOL_StatusBarAndNavigationBarHeight;
    self.tableView.y = MOL_StatusBarAndNavigationBarHeight;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self calculatorOfficHelperViewControllerFrame];
}
@end