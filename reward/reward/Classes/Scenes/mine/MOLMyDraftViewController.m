//
//  MOLMyDraftViewController.m
//  reward
//
//  Created by moli-2017 on 2018/9/17.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLMyDraftViewController.h"
#import "MOLMyDraftCell.h"

@interface MOLMyDraftViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@end

@implementation MOLMyDraftViewController

- (BOOL)showNavigationLine
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSourceArray = [NSMutableArray array];
    [self setupNavigation];
    [self setupMyDraftViewControllerUI];
    
    [self request_getDraftListWithMore:NO];
}

#pragma mark - 网络请求
- (void)request_getDraftListWithMore:(BOOL)isMore
{
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] init];
    v.width = MOL_SCREEN_WIDTH;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.width = MOL_SCREEN_WIDTH - 15;
    btn.height = 40;
    btn.x = 15;
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitle:@"草稿箱里的视频只有自己可见哦" forState:UIControlStateNormal];
    [btn setTitleColor:HEX_COLOR_ALPHA(0xffffff, 0.6) forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"mine_draft_smiling_face"] forState:UIControlStateNormal];
    btn.titleLabel.font = MOL_REGULAR_FONT(13);
    [btn mol_setButtonImageTitleStyle:ButtonImageTitleStyleDefault padding:5];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [v addSubview:btn];
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MOLMyDraftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MOLMyDraftCell_id"];
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //从选中中取消
    
}

#pragma mark - 按钮的点击
- (void)button_clickMultiple
{
    [self.tableView setEditing:YES animated:YES];
    UIBarButtonItem *rightItem = [UIBarButtonItem mol_barButtonItemWithTitleName:@"取消" color:HEX_COLOR_ALPHA(0xffffff, 1) disableColor:HEX_COLOR_ALPHA(0xffffff, 1) font:MOL_MEDIUM_FONT(17) targat:self action:@selector(button_clickMultipleCancle)];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)button_clickMultipleCancle
{
    [self.tableView setEditing:NO animated:YES];
    UIBarButtonItem *rightItem = [UIBarButtonItem mol_barButtonItemWithTitleName:@"选择" color:HEX_COLOR_ALPHA(0xffffff, 1) disableColor:HEX_COLOR_ALPHA(0xffffff, 1) font:MOL_MEDIUM_FONT(17) targat:self action:@selector(button_clickMultiple)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self basevc_setNavLeftItemWithTitle:nil titleColor:nil];
    self.navigationItem.hidesBackButton = NO;
}

#pragma mark - UI
- (void)setupMyDraftViewControllerUI
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
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
    [tableView registerClass:[MOLMyDraftCell class] forCellReuseIdentifier:@"MOLMyDraftCell_id"];
    [self.view addSubview:tableView];
    
}

- (void)calculatorMyDraftViewControllerFrame
{
    self.tableView.frame = self.view.bounds;
    self.tableView.height = self.view.height - MOL_StatusBarAndNavigationBarHeight;
    self.tableView.y = MOL_StatusBarAndNavigationBarHeight;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, MOL_TabbarSafeBottomMargin, 0);
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self calculatorMyDraftViewControllerFrame];
}


#pragma mark - 导航条
- (void)setupNavigation
{
    [self basevc_setCenterTitle:@"草稿箱" titleColor:HEX_COLOR(0xffffff)];
    UIBarButtonItem *rightItem = [UIBarButtonItem mol_barButtonItemWithTitleName:@"选择" color:HEX_COLOR_ALPHA(0xffffff, 1) disableColor:HEX_COLOR_ALPHA(0xffffff, 1) font:MOL_MEDIUM_FONT(17) targat:self action:@selector(button_clickMultiple)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
@end
