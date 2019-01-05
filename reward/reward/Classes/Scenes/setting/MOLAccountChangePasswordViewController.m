//
//  MOLAccountChangePasswordViewController.m
//  reward
//
//  Created by moli-2017 on 2018/9/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLAccountChangePasswordViewController.h"
#import "MOLAccountChangePasswordView.h"
#import "MOLAccountViewModel.h"

@interface MOLAccountChangePasswordViewController ()
@property (nonatomic, strong) MOLAccountViewModel *accountViewModel;
@property (nonatomic, weak) MOLAccountChangePasswordView *changePswView;
@end

@implementation MOLAccountChangePasswordViewController
- (BOOL)showNavigationLine
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.accountViewModel = [[MOLAccountViewModel alloc] init];
    
    [self setupAccountChangePasswordViewControllerUI];
    [self setupNavigation];
    
    [self bindingViewModel];
}

#pragma mark - bindingViewModel
- (void)bindingViewModel
{
    @weakify(self);
    RAC(self.accountViewModel,oldPswString) = self.changePswView.oldPswTextField.rac_textSignal;
    RAC(self.accountViewModel,nowPwdString) = self.changePswView.pswTextField.rac_textSignal;
    RAC(self.accountViewModel,againPwdString) = self.changePswView.againPswTextField.rac_textSignal;
    RAC(self.navigationItem.rightBarButtonItem,enabled) = self.accountViewModel.changePswFinishSignal;
    
    [self.accountViewModel.changePswCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        if ([x integerValue] == MOL_SUCCESS_REQUEST) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

#pragma mark - 按钮点击
- (void)button_clickFinish
{
    if (self.changePswView.oldPswTextField.text.length < 6 ||
        self.changePswView.pswTextField.text.length < 6 ||
        self.changePswView.againPswTextField.text.length < 6) {
        [MBProgressHUD showMessageAMoment:@"密码太短,请输入6-32位密码"];
        return;
    }
    
    if (self.changePswView.oldPswTextField.text.length > 32 ||
        self.changePswView.pswTextField.text.length > 32 ||
        self.changePswView.againPswTextField.text.length > 32) {
        [MBProgressHUD showMessageAMoment:@"密码太短,请输入6-32位密码"];
        return;
    }
    
    
    if (![self.changePswView.pswTextField.text isEqualToString:self.changePswView.againPswTextField.text]) {
        // 两次代码不一样
        [MBProgressHUD showMessageAMoment:@"两次密码输入不一致\n请重新输入"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"oldPassword"] = [self.changePswView.oldPswTextField.text mol_md5WithOrigin];
    dic[@"newPassword"] = [self.changePswView.pswTextField.text mol_md5WithOrigin];
    
    [self.accountViewModel.changePswCommand execute:dic];
}

#pragma mark - 导航条
- (void)setupNavigation
{
    [self basevc_setCenterTitle:@"修改密码" titleColor:HEX_COLOR(0xffffff)];
    UIBarButtonItem *rightItem = [UIBarButtonItem mol_barButtonItemWithTitleName:@"完成" color:HEX_COLOR(0xFFEC00) disableColor:HEX_COLOR_ALPHA(0xFFEC00, 0.5) font:MOL_MEDIUM_FONT(14) targat:self action:@selector(button_clickFinish)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - UI
- (void)setupAccountChangePasswordViewControllerUI
{
    MOLAccountChangePasswordView *changePswView = [[MOLAccountChangePasswordView alloc] init];
    _changePswView = changePswView;
    [self.view addSubview:changePswView];
}

- (void)calculatorAccountChangePasswordViewControllerFrame
{
    self.changePswView.frame = self.view.bounds;
    self.changePswView.height = self.view.height - MOL_StatusBarAndNavigationBarHeight;
    self.changePswView.y = MOL_StatusBarAndNavigationBarHeight;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self calculatorAccountChangePasswordViewControllerFrame];
}
@end
