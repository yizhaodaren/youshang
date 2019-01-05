//
//  MOLAccountFirstSettingPasswordViewController.m
//  reward
//
//  Created by moli-2017 on 2018/9/25.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLAccountFirstSettingPasswordViewController.h"
#import "MOLAccountViewModel.h"
#import "MOLFirstSettingPasswordView.h"

@interface MOLAccountFirstSettingPasswordViewController ()
@property (nonatomic, strong) MOLAccountViewModel *accountViewModel;
@property (nonatomic, weak) MOLFirstSettingPasswordView *firstSetPswView;
@end

@implementation MOLAccountFirstSettingPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.accountViewModel = [[MOLAccountViewModel alloc] init];
    
    [self setupAccountFirstSettingPasswordViewControllerUI];
    [self setupNavigation];
    
    [self bindingViewModel];
}

#pragma mark - bindingViewModel
- (void)bindingViewModel
{
    @weakify(self);
    RAC(self.accountViewModel,nowPwdString) = self.firstSetPswView.pswTextField.rac_textSignal;
    RAC(self.accountViewModel,againPwdString) = self.firstSetPswView.againPswTextField.rac_textSignal;
    RAC(self.navigationItem.rightBarButtonItem,enabled) = self.accountViewModel.setPswFinishSignal;
    
    [self.accountViewModel.changePswCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        
        if ([x integerValue] == MOL_SUCCESS_REQUEST) {
            
            if (self.setPasswordBlock) {
                self.setPasswordBlock();
            }
            // toast 设置成功
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

#pragma mark - 按钮点击
- (void)button_clickFinish
{
    if (self.firstSetPswView.pswTextField.text.length < 6 || self.firstSetPswView.againPswTextField.text.length < 6) {
        [MBProgressHUD showMessageAMoment:@"密码太短,请输入6-32位密码"];
        return;
    }
    
    if (self.firstSetPswView.pswTextField.text.length > 32 ||
        self.firstSetPswView.againPswTextField.text.length > 32) {
        [MBProgressHUD showMessageAMoment:@"密码太短,请输入6-32位密码"];
        return;
    }
    
    if (![self.firstSetPswView.pswTextField.text isEqualToString:self.firstSetPswView.againPswTextField.text]) {
        [MBProgressHUD showMessageAMoment:@"两次密码输入不一致\n请重新输入"];
        return;
    }
    
    // 第一次设置密码的请求
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"newPassword"] = [self.firstSetPswView.pswTextField.text mol_md5WithOrigin];
    [self.accountViewModel.changePswCommand execute:dic];
}


#pragma mark - 导航条
- (void)setupNavigation
{
    [self basevc_setCenterTitle:@"设置密码" titleColor:HEX_COLOR(0xffffff)];
    UIBarButtonItem *rightItem = [UIBarButtonItem mol_barButtonItemWithTitleName:@"完成" color:HEX_COLOR(0xFFEC00) disableColor:HEX_COLOR_ALPHA(0xFFEC00, 0.5) font:MOL_MEDIUM_FONT(14) targat:self action:@selector(button_clickFinish)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - UI
- (void)setupAccountFirstSettingPasswordViewControllerUI
{
    MOLFirstSettingPasswordView *firstSetPswView = [[MOLFirstSettingPasswordView alloc] init];
    _firstSetPswView = firstSetPswView;
    [self.view addSubview:firstSetPswView];
}

- (void)calculatorAccountFirstSettingPasswordViewControllerFrame
{
    self.firstSetPswView.frame = self.view.bounds;
    self.firstSetPswView.height = self.view.height - MOL_StatusBarAndNavigationBarHeight;
    self.firstSetPswView.y = MOL_StatusBarAndNavigationBarHeight;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self calculatorAccountFirstSettingPasswordViewControllerFrame];
}

@end
