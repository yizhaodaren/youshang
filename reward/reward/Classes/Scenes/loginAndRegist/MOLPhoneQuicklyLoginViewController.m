//
//  MOLPhoneQuicklyLoginViewController.m
//  reward
//
//  Created by moli-2017 on 2018/9/21.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLPhoneQuicklyLoginViewController.h"
#import "MOLQuicklyLoginView.h"
#import "MOLAccountViewModel.h"
#import "MOLRegular.h"

@interface MOLPhoneQuicklyLoginViewController ()
@property (nonatomic, strong) MOLAccountViewModel *accountViewModel;
@property (nonatomic, weak) MOLQuicklyLoginView *quicklyView;
@end

@implementation MOLPhoneQuicklyLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_COLOR_ALPHA(0x161824, 0.4);
    
    self.accountViewModel = [[MOLAccountViewModel alloc] init];
    
    [self setupPhoneQuicklyLoginViewControllerUI];
    
    [self bindingViewModel];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.quicklyView.textField becomeFirstResponder];
}

#pragma mark - 按钮点击
- (void)button_clickNext
{
    if (!self.quicklyView.textField.text.length) {
        [MBProgressHUD showMessageAMoment:@"手机号码不能为空"];
        return;
    }
    
    if (!self.quicklyView.codeTextField.text.length) {
        [MBProgressHUD showMessageAMoment:@"验证码不能为空"];
        return;
    }
    
    if (![self isPhoneNum:self.quicklyView.textField.text]) {
        [MBProgressHUD showMessageAMoment:@"手机号码格式错误"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"loginType"] = @"5";
    dic[@"phone"] = [self.quicklyView.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    dic[@"phoneCode"] = self.quicklyView.codeTextField.text;
    
    // 发送登录请求
    [self.accountViewModel.loginCommand execute:dic];
}

- (void)button_clickCode  // 获取验证码
{
    if (!self.quicklyView.textField.text.length) {
        [MBProgressHUD showMessageAMoment:@"手机号码不能为空"];
        return;
    }
    
    // 友盟统计
    [MobClick event:@"_c_get_code"];
    
    if (![self isPhoneNum:self.quicklyView.textField.text]) {
        [MBProgressHUD showMessageAMoment:@"手机号码格式错误"];
        return;
    }
    
    self.quicklyView.codeButton.enabled = NO;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"button"] = self.quicklyView.codeButton;
    dic[@"paraId"] = [self.quicklyView.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
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
            
            // 友盟统计
            [MobClick event:@"_c_login_commit"];
            
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
- (void)setupPhoneQuicklyLoginViewControllerUI
{
    MOLQuicklyLoginView *quicklyView = [[MOLQuicklyLoginView alloc] init];
    _quicklyView = quicklyView;
    [quicklyView.codeButton addTarget:self action:@selector(button_clickCode) forControlEvents:UIControlEventTouchUpInside];
    [quicklyView.nextButton addTarget:self action:@selector(button_clickNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quicklyView];
}

- (void)calculatorPhoneQuicklyLoginViewControllerFrame
{
    self.quicklyView.frame = self.view.bounds;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self calculatorPhoneQuicklyLoginViewControllerFrame];
}

- (BOOL)isPhoneNum:(NSString *)number
{
    if ([MOLRegular mol_RegularMobileNumber:[number stringByReplacingOccurrencesOfString:@" " withString:@""]]) {
        return number.length == 13;
    }
    return NO;
}
@end
