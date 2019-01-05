//
//  MOLAccountViewController.m
//  reward
//
//  Created by moli-2017 on 2018/9/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLAccountViewController.h"
#import "MOLAccountCell.h"

#import "MOLAccountChangePasswordViewController.h"
#import "MOLAccountBindingPhoneViewController.h"
#import "MOLAccountFirstSettingPasswordViewController.h"

#import "MOLAccountViewModel.h"

@interface MOLAccountViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) MOLAccountViewModel *accountViewModel;
@property (nonatomic, strong) MOLAccountModel *accountModel;
@end

@implementation MOLAccountViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)showNavigationLine
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.accountViewModel = [[MOLAccountViewModel alloc] init];
    self.dataSourceArray = [NSMutableArray array];
    [self setupAccountViewControllerUI];
    [self setupNavigation];
    
    [self bindingViewModel];
    
    [self.accountViewModel.userAccountCommand execute:nil];
}

#pragma mark - bindingViewModel
- (void)bindingViewModel
{
    
     
    @weakify(self);
    [self.accountViewModel.userAccountCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        self.accountModel = (MOLAccountModel *)x;
        
        [self request_getAccountList:self.accountModel];
    }];
    
    [self.accountViewModel.bindingCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        if ([x integerValue] == MOL_SUCCESS_REQUEST) {
            // 绑定成功
            [self.accountViewModel.userAccountCommand execute:nil];
        }
    }];
    
    [self.accountViewModel.removeBindingCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        if ([x integerValue] == MOL_SUCCESS_REQUEST) {
            //  解除绑定成功
            [self.accountViewModel.userAccountCommand execute:nil];
        }
    }];
}

#pragma mark - 网络请求
- (void)request_getAccountList:(MOLAccountModel *)model
{
    [self.dataSourceArray removeAllObjects];
    
    NSMutableArray *arr1 = [NSMutableArray array];
    
    MOLAccountModel *model1 = [MOLAccountModel new];
    model1.name = @"手机号码";
    model1.subName = model.phone.length ? [NSString stringWithFormat:@"%@",model.phone] : @"未绑定";
    
    MOLAccountModel *model2 = [MOLAccountModel new];
    model2.name = model.password.length ? @"修改密码" : @"设置密码";
    model2.subName = model.password.length ? @"已设置" : @"未设置";
    
    NSMutableArray *arr2 = [NSMutableArray array];
    
    MOLAccountModel *model3 = [MOLAccountModel new];
    model3.name = @"微信账号";
    model3.subName = model.wxUid.length ? model.wxName : @"未绑定";
    
    MOLAccountModel *model4 = [MOLAccountModel new];
    model4.name = @"微博账号";
    model4.subName = model.wbUid.length ? model.wbName : @"未绑定";
    
    MOLAccountModel *model5 = [MOLAccountModel new];
    model5.name = @"QQ账号";
    model5.subName = model.qqUid.length ? model.qqName : @"未绑定";
    
    
    [arr1 addObject:model1];
    [arr1 addObject:model2];
    
    [arr2 addObject:model3];
    [arr2 addObject:model4];
    [arr2 addObject:model5];

    [self.dataSourceArray addObject:arr1];
    [self.dataSourceArray addObject:arr2];
    
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindingPhoneSuccess:) name:@"MOL_BINDINGPHONE_SUCCESS" object:nil];
}

- (void)bindingPhoneSuccess:(NSNotification *)noti
{
    NSString *phone = noti.object;
    NSArray *arr = self.dataSourceArray.firstObject;
    MOLAccountModel *model = arr.firstObject;
    model.subName = phone;
    MOLAccountModel *model1 = arr[1];
    model1.subName = @"已设置";
    [self.tableView reloadData];
    
    self.accountModel.phone = phone;
}

#pragma mark - 三方调用
- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:nil completion:^(id result, NSError *error) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        if (error) {
            [MBProgressHUD showMessageAMoment:@""];
        } else {
            UMSocialUserInfoResponse *resp = result;
            // 第三方登录数据(为空表示平台未提供)
            dic[@"loginType"] = @"4";
            dic[@"accessToken"] = resp.accessToken;
            dic[@"uid"] = resp.uid;
            
            if (platformType == UMSocialPlatformType_WechatSession) {
                dic[@"loginType"] = @"2";
                dic[@"accessToken"] = resp.accessToken;
                dic[@"uid"] = resp.unionId;
                dic[@"openId"] = resp.openid;
                
            }else if (platformType == UMSocialPlatformType_Sina){
                
                
                dic[@"loginType"] = @"3";
                dic[@"accessToken"] = resp.accessToken;
                dic[@"uid"] = resp.uid;
            }
            
            [self.accountViewModel.bindingCommand execute:dic];
        }
    }];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *arr = self.dataSourceArray[indexPath.section];
    MOLAccountModel *model = arr[indexPath.row];
    
    NSString *name = model.name;
    
    if ([name isEqualToString:@"手机号码"]) {
        if (self.accountModel.phone.length) {
            return;
        }
        MOLAccountBindingPhoneViewController *vc = [[MOLAccountBindingPhoneViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([name isEqualToString:@"设置密码"]){ // 提示绑定手机
        
        if (self.accountModel.phone.length) {
            MOLAccountFirstSettingPasswordViewController *vc = [[MOLAccountFirstSettingPasswordViewController alloc] init];
            @weakify(self);
            vc.setPasswordBlock = ^{
                @strongify(self);
                model.subName = @"已设置";
                model.name = @"修改密码";
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [MBProgressHUD showMessageAMoment:@"请先绑定手机"];
        }
        
    }else if ([name isEqualToString:@"修改密码"]){
        MOLAccountChangePasswordViewController *vc = [[MOLAccountChangePasswordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([name isEqualToString:@"微信账号"]){
        
        if (self.accountModel.wxUid.length) {   // 解绑
            
            // 确认解绑？
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认解绑" message:@"解绑微信账号后将无法继续使用它登录该CC短视频账号" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSString *type = @"2";
                [self.accountViewModel.removeBindingCommand execute:type];
                
            }];
            
            [alert addAction:action1];
            [alert addAction:action2];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:alert animated:YES completion:nil];
            });
            
        }else{
            [self getUserInfoForPlatform:UMSocialPlatformType_WechatSession];
        }
        
    }else if ([name isEqualToString:@"微博账号"]){
        
        if (self.accountModel.wbUid.length) {  // 解绑
            
            // 确认解绑？
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认解绑" message:@"解绑微博账号后将无法继续使用它登录该CC短视频账号" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSString *type = @"3";
                [self.accountViewModel.removeBindingCommand execute:type];
            }];
            
            [alert addAction:action1];
            [alert addAction:action2];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:alert animated:YES completion:nil];
            });
            
        }else{
            [self getUserInfoForPlatform:UMSocialPlatformType_Sina];
        }
    }else if ([name isEqualToString:@"QQ账号"]){
        
        if (self.accountModel.qqUid.length) {  // 解绑
            
            // 确认解绑？
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认解绑" message:@"解绑QQ账号后将无法继续使用它登录该CC短视频账号" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSString *type = @"4";
                [self.accountViewModel.removeBindingCommand execute:type];
            }];
            
            [alert addAction:action1];
            [alert addAction:action2];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:alert animated:YES completion:nil];
            });
            
        }else{
            [self getUserInfoForPlatform:UMSocialPlatformType_QQ];
        }
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
    MOLAccountModel *model = arr[indexPath.row];
    MOLAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MOLAccountCell_id"];
    cell.accountModel = model;
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
        v.width = MOL_SCREEN_WIDTH - 30;
        v.height = 1;
        v.x = 15;
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

#pragma mark - 导航条
- (void)setupNavigation
{
    [self basevc_setCenterTitle:@"账户安全" titleColor:HEX_COLOR(0xffffff)];
}

#pragma mark - UI
- (void)setupAccountViewControllerUI
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
    [tableView registerClass:[MOLAccountCell class] forCellReuseIdentifier:@"MOLAccountCell_id"];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, MOL_TabbarHeight, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

- (void)calculatorAccountViewControllerFrame
{
    self.tableView.frame = self.view.bounds;
    self.tableView.height = self.view.height - MOL_StatusBarAndNavigationBarHeight;
    self.tableView.y = MOL_StatusBarAndNavigationBarHeight;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self calculatorAccountViewControllerFrame];
}
@end
