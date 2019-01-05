//
//  MOLLoginBindingPasswordViewController.m
//  reward
//
//  Created by moli-2017 on 2018/9/21.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLLoginBindingPasswordViewController.h"
#import "MOLLoginBindingPasswordView.h"
#import "MOLAccountViewModel.h"
@interface MOLLoginBindingPasswordViewController ()
@property (nonatomic, strong) MOLAccountViewModel *accountViewModel;
@property (nonatomic, weak) MOLLoginBindingPasswordView *bindingPswView;
@end

@implementation MOLLoginBindingPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_COLOR_ALPHA(0x161824, 0.4);
    
    self.accountViewModel = [[MOLAccountViewModel alloc] init];
    
    [self setupLoginBindingPasswordViewControllerUI];
    
    [self setupNavigation];
    
    [self bindingViewModel];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.bindingPswView.codeTextField becomeFirstResponder];
}

#pragma mark - 按钮的点击
- (void)button_clickJump
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)button_clickNext  // 下一步
{
    if (!self.bindingPswView.codeTextField.text.length) {
        [MBProgressHUD showMessageAMoment:@"验证码不能为空"];
        return;
    }
    
    if (!self.bindingPswView.pswTextField.text.length) {
        [MBProgressHUD showMessageAMoment:@"密码不能为空"];
        return;
    }
    
    if (self.bindingPswView.pswTextField.text.length < 6) {
        [MBProgressHUD showMessageAMoment:@"密码太短,请输入6-32位密码"];
        return;
    }
    
    if (self.bindingPswView.pswTextField.text.length > 32) {
        [MBProgressHUD showMessageAMoment:@"密码太长,请输入6-32位密码"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"loginType"] = @"5";
    dic[@"password"] = [self.bindingPswView.pswTextField.text mol_md5WithOrigin];
    dic[@"phone"] = [self.phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    dic[@"phoneCode"] = self.bindingPswView.codeTextField.text;
    
    // 绑定手机接口
    [self.accountViewModel.bindingCommand execute:dic];
}

- (void)button_clickCode  // 获取验证码
{
    // 发送验证码
    self.bindingPswView.codeButton.enabled = NO;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"button"] = self.bindingPswView.codeButton;
    dic[@"paraId"] = [self.phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self.accountViewModel.codeCommand execute:dic];
}

#pragma mark - bindingViewModel
- (void)bindingViewModel
{
    @weakify(self)
    [self.accountViewModel.codeCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        
        if ([x integerValue] == MOL_SUCCESS_REQUEST) {
            
            NSLog(@"验证码发送成功");
        }
    }];
    
    [self.accountViewModel.bindingCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        
        if ([x integerValue] == MOL_SUCCESS_REQUEST) {
            
            // toast 绑定成功
            [self button_clickJump];
        }
    }];
}

#pragma mark - 导航条
- (void)setupNavigation
{
    UIBarButtonItem *rightItem = [UIBarButtonItem mol_barButtonItemWithTitleName:@"跳过" color:HEX_COLOR_ALPHA(0xffffff, 0.9) disableColor:HEX_COLOR_ALPHA(0xffffff, 0.9) font:MOL_MEDIUM_FONT(14) targat:self action:@selector(button_clickJump)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - UI
- (void)setupLoginBindingPasswordViewControllerUI
{
    MOLLoginBindingPasswordView *bindingPswView = [[MOLLoginBindingPasswordView alloc] init];
    _bindingPswView = bindingPswView;
    bindingPswView.phone = self.phoneNumber;
    
    [bindingPswView.codeButton addTarget:self action:@selector(button_clickCode) forControlEvents:UIControlEventTouchUpInside];
    [bindingPswView.nextButton addTarget:self action:@selector(button_clickNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bindingPswView];
}

- (void)calculatorLoginBindingPasswordViewControllerFrame
{
    self.bindingPswView.frame = self.view.bounds;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self calculatorLoginBindingPasswordViewControllerFrame];
}

@end
