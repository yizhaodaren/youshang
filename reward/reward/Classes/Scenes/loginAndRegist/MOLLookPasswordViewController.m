//
//  MOLLookPasswordViewController.m
//  reward
//
//  Created by moli-2017 on 2018/9/21.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLLookPasswordViewController.h"
#import "MOLLookPasswordView.h"
#import "MOLAccountViewModel.h"

@interface MOLLookPasswordViewController ()
@property (nonatomic, strong) MOLAccountViewModel *accountViewModel;
@property (nonatomic, weak) MOLLookPasswordView *lookPswView;
@end

@implementation MOLLookPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_COLOR_ALPHA(0x161824, 0.4);
    
    self.accountViewModel = [[MOLAccountViewModel alloc] init];
    
    [self setupPhoneLoginViewControllerUI];
    
    [[MOLCodeTimerManager shareCodeTimerManager] codeTimer_beginTimerWithButton:self.lookPswView.codeButton timeDownBlock:nil];
    
    [self bindingViewModel];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.lookPswView.codeTextField becomeFirstResponder];
}


#pragma mark - 按钮点击
- (void)button_clickNext  // 下一步
{
    if (!self.lookPswView.pswTextField.text.length) {
        [MBProgressHUD showMessageAMoment:@"密码不能为空"];
        return;
    }
    
    if (!self.lookPswView.codeTextField.text.length) {
        [MBProgressHUD showMessageAMoment:@"验证码不能为空"];
        return;
    }
    
    if (self.lookPswView.pswTextField.text.length < 6) {
        [MBProgressHUD showMessageAMoment:@"密码太短,请输入6-32位密码"];
        return;
    }
    
    if (self.lookPswView.pswTextField.text.length > 32) {
        [MBProgressHUD showMessageAMoment:@"密码太短,请输入6-32位密码"];
        return;
    }
    
    // 找回密码
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"loginType"] = @"5";
    dic[@"phone"] = [self.phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    dic[@"password"] = [self.lookPswView.pswTextField.text mol_md5WithOrigin];
    dic[@"phoneCode"] = self.lookPswView.codeTextField.text;
    
    [self.accountViewModel.loginCommand execute:dic];
}

- (void)button_clickCode  // 获取验证码
{
    self.lookPswView.codeButton.enabled = NO;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"button"] = self.lookPswView.codeButton;
    dic[@"paraId"] = [self.phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self.accountViewModel.codeCommand execute:dic];
}

#pragma mark - bindingViewModel
- (void)bindingViewModel
{
    @weakify(self);
    [self.accountViewModel.loginCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        NSLog(@"%@",x);
        MOLUserModel *user = (MOLUserModel *)x;
        if (user.code == MOL_SUCCESS_REQUEST) {
            // 登录成功
            [MOLUserManagerInstance user_saveUserInfoWithModel:user isLogin:YES];
            [[MOLCodeTimerManager shareCodeTimerManager] codeTimer_stopTimer];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }else{
            [MBProgressHUD showMessageAMoment:user.message];
        }
    }];
}

#pragma mark - UI
- (void)setupPhoneLoginViewControllerUI
{
    MOLLookPasswordView *lookPswView = [[MOLLookPasswordView alloc] init];
    _lookPswView = lookPswView;
    lookPswView.phoneNumber = self.phoneNumber;
    [lookPswView.nextButton addTarget:self action:@selector(button_clickNext) forControlEvents:UIControlEventTouchUpInside];
    
    [lookPswView.codeButton addTarget:self action:@selector(button_clickCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lookPswView];
}

- (void)calculatorPhoneLoginViewControllerFrame
{
    self.lookPswView.frame = self.view.bounds;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self calculatorPhoneLoginViewControllerFrame];
}

@end
