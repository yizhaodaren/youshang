//
//  MOLAccountSetPasswordViewController.m
//  reward
//
//  Created by moli-2017 on 2018/9/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLAccountSetPasswordViewController.h"
#import "MOLAccountSetPassWordView.h"
#import "MOLAccountViewModel.h"

@interface MOLAccountSetPasswordViewController ()
@property (nonatomic, strong) MOLAccountViewModel *accountViewModel;
@property (nonatomic, weak) MOLAccountSetPassWordView *pswView;
@end

@implementation MOLAccountSetPasswordViewController
- (BOOL)showNavigationLine
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.accountViewModel = [[MOLAccountViewModel alloc] init];
    
    [self setupAccountSetPasswordViewControllerUI];
    [self setupNavigation];
    
    [self bindingViewModel];
}

#pragma mark - bindingViewModel
- (void)bindingViewModel
{
    @weakify(self);
    RAC(self.accountViewModel,codeString) = self.pswView.codeTextField.rac_textSignal;
    RAC(self.accountViewModel,pwdString) = self.pswView.pswTextField.rac_textSignal;
    RAC(self.navigationItem.rightBarButtonItem,enabled) = self.accountViewModel.bindingFinishSignal;
    
    [self.accountViewModel.bindingCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        
        if ([x integerValue] == MOL_SUCCESS_REQUEST) {
            
            // toast 绑定成功
            [MBProgressHUD showMessageAMoment:@"绑定成功"];
            NSString *num = [self.phoneString stringByReplacingOccurrencesOfString:@" " withString:@""];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MOL_BINDINGPHONE_SUCCESS" object:num];
            NSInteger count = self.navigationController.childViewControllers.count - 1 - 1 - 1;
            MOLBaseViewController *vc = self.navigationController.childViewControllers[count];
            [self.navigationController popToViewController:vc animated:YES];
        }
    }];
    
    [self.accountViewModel.codeCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        
    }];
}

#pragma mark - 按钮点击
- (void)button_clickFinish
{
    if (!self.pswView.codeTextField.text.length) {
        [MBProgressHUD showMessageAMoment:@"验证码不能为空"];
        return;
    }
    
    if (!self.pswView.pswTextField.text.length) {
        [MBProgressHUD showMessageAMoment:@"密码不能为空"];
        return;
    }
    
    if (self.pswView.pswTextField.text.length < 6) {
        [MBProgressHUD showMessageAMoment:@"密码太短,请输入6-32位密码"];
        return;
    }
    
    if (self.pswView.pswTextField.text.length > 32) {
        [MBProgressHUD showMessageAMoment:@"密码太短,请输入6-32位密码"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"loginType"] = @"5";
    dic[@"password"] = [self.pswView.pswTextField.text mol_md5WithOrigin];
    dic[@"phone"] = [self.phoneString stringByReplacingOccurrencesOfString:@" " withString:@""];
    dic[@"phoneCode"] = self.pswView.codeTextField.text;
    
    
    // 绑定手机的请求
    [self.accountViewModel.bindingCommand execute:dic];
}

- (void)button_clickCode
{
    self.pswView.codeButton.enabled = NO;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"button"] = self.pswView.codeButton;
    dic[@"paraId"] = [self.phoneString stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self.accountViewModel.codeCommand execute:dic];
}

#pragma mark - 导航条
- (void)setupNavigation
{
    [self basevc_setCenterTitle:@"设置密码" titleColor:HEX_COLOR(0xffffff)];
    UIBarButtonItem *rightItem = [UIBarButtonItem mol_barButtonItemWithTitleName:@"完成" color:HEX_COLOR(0xFFEC00) disableColor:HEX_COLOR_ALPHA(0xFFEC00, 0.5) font:MOL_MEDIUM_FONT(14) targat:self action:@selector(button_clickFinish)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - UI
- (void)setupAccountSetPasswordViewControllerUI
{
    MOLAccountSetPassWordView *pswView = [[MOLAccountSetPassWordView alloc] init];
    _pswView = pswView;
    pswView.phone = self.phoneString;
    [pswView.codeButton addTarget:self action:@selector(button_clickCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pswView];
}

- (void)calculatorAccountSetPasswordViewControllerFrame
{
    self.pswView.frame = self.view.bounds;
    self.pswView.height = self.view.height - MOL_StatusBarAndNavigationBarHeight;
    self.pswView.y = MOL_StatusBarAndNavigationBarHeight;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self calculatorAccountSetPasswordViewControllerFrame];
}

@end
