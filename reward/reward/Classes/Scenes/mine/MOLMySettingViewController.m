//
//  MOLMySettingViewController.m
//  reward
//
//  Created by moli-2017 on 2018/9/13.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLMySettingViewController.h"
#import "MOLMySettingCell.h"
#import "MOLMySettingViewModel.h"

#import "MOLAccountViewController.h"
#import "MOLWebViewController.h"
#import "MOLHostHead.h"

@interface MOLMySettingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) MOLMySettingViewModel *settingViewModel;
@end

@implementation MOLMySettingViewController
- (BOOL)showNavigationLine
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSourceArray = [NSMutableArray array];
    self.settingViewModel = [[MOLMySettingViewModel alloc] init];
    [self setupMySettingViewControllerUI];
    [self bindingMySettingViewModel];
    [self request_getSettingData];
    
    [self basevc_setCenterTitle:@"设置" titleColor:HEX_COLOR(0xffffff)];
}

#pragma mark - bindingViewModel
- (void)bindingMySettingViewModel
{
    @weakify(self);
    [self.settingViewModel.settingCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        NSArray *arr = (NSArray *)x;
        [self.dataSourceArray removeAllObjects];
        [self.dataSourceArray addObjectsFromArray:arr];
        [self.tableView reloadData];
    }];
}

#pragma mark - 网络请求
- (void)request_getSettingData
{
    [self.settingViewModel.settingCommand execute:nil];
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *arr = self.dataSourceArray[indexPath.section];
    NSDictionary *dic = arr[indexPath.row];
    
    NSString *name = [dic mol_jsonString:@"name"];
    
    if ([name isEqualToString:@"账号安全"]) {
        
        MOLAccountViewController *vc = [[MOLAccountViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([name isEqualToString:@"意见反馈"]){
        
        MOLWebViewController *vc = [[MOLWebViewController alloc] init];
        NSString *offic = MOL_OFFIC_SERVICE_H5;  // 正式
#ifdef MOL_TEST_HOST
        offic = MOL_TEST_SERVICE;  // 测试
#endif
        vc.urlString = [NSString stringWithFormat:@"%@/static/views/app/about/feedback.html",offic];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([name isEqualToString:@"用户协议"]){
        
        MOLWebViewController *vc = [[MOLWebViewController alloc] init];
        NSString *offic = MOL_OFFIC_SERVICE_H5;  // 正式
#ifdef MOL_TEST_HOST
        offic = MOL_TEST_SERVICE;  // 测试
#endif
        vc.urlString = [NSString stringWithFormat:@"%@/static/views/app/about/userAgreement.html",offic];
        
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([name isEqualToString:@"隐私政策"]){
        
        MOLWebViewController *vc = [[MOLWebViewController alloc] init];
        NSString *offic = MOL_OFFIC_SERVICE_H5;  // 正式
#ifdef MOL_TEST_HOST
        offic = MOL_TEST_SERVICE;  // 测试
#endif
        vc.urlString = [NSString stringWithFormat:@"%@/static/views/app/about/privacyPolicy.html",offic];
        vc.titleString = @"隐私政策";
        
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([name isEqualToString:@"关于我们"]){
        
        MOLWebViewController *vc = [[MOLWebViewController alloc] init];
        NSString *offic = MOL_OFFIC_SERVICE_H5;  // 正式
#ifdef MOL_TEST_HOST
        offic = MOL_TEST_SERVICE;  // 测试
#endif
        vc.urlString = [NSString stringWithFormat:@"%@/static/views/app/about/aboutUs.html",offic];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([name isEqualToString:@"给个好评"]){
        NSString *appid = @"1444421076";
        NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@",appid];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else if ([name isEqualToString:@"清除缓存"]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认清除缓存？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if ([MOLCacheFileManager clearCacheWithFilePath:nil]) {
                  [self  request_getSettingData];
                   [MBProgressHUD showMessageAMoment:@"清除成功!"];
            }else{
                  [MBProgressHUD showMessageAMoment:@"清除失败"];
                
            }     
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:okAction];
        [alertController addAction:cancleAction];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }else if ([name isEqualToString:@"退出登录"]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"退出当前账号？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self.tableView.delegate = nil;
            self.tableView.dataSource = nil;
            // 退出登录
            [[MOLGlobalManager shareGlobalManager] global_loginOut];
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:okAction];
        [alertController addAction:cancleAction];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = self.dataSourceArray[section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 10 + 20 + 25;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = self.dataSourceArray[indexPath.section];
    NSDictionary *dic = arr[indexPath.row];
    MOLMySettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MOLMySettingCell_id"];
    cell.settingDic = dic;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == self.dataSourceArray.count - 1) {
        return [UIView new];
    }else{
        
        UIView *view = [[UIView alloc] init];
        view.width = MOL_SCREEN_WIDTH;
        UIView *v = [[UIView alloc] init];
        v.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.1);
        v.width = MOL_SCREEN_WIDTH - 45 - 15;
        v.height = 1;
        v.x = 45;
        [view addSubview:v];
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.dataSourceArray.count - 1) {
        return 0.01;
    }
    return 1;
}

#pragma mark - UI
- (void)setupMySettingViewControllerUI
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
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
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[MOLMySettingCell class] forCellReuseIdentifier:@"MOLMySettingCell_id"];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, MOL_TabbarHeight, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

- (void)calculatorMySettingViewControllerFrame
{
    self.tableView.frame = self.view.bounds;
    self.tableView.height = self.view.height - MOL_StatusBarAndNavigationBarHeight;
    self.tableView.y = MOL_StatusBarAndNavigationBarHeight;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self calculatorMySettingViewControllerFrame];
}

@end
