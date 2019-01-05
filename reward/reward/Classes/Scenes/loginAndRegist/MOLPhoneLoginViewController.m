//
//  MOLPhoneLoginViewController.m
//  reward
//
//  Created by moli-2017 on 2018/9/21.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLPhoneLoginViewController.h"
#import "MOLPhoneLoginView.h"
#import "MOLAccountViewModel.h"
#import "MOLRegular.h"
#import "MOLLookPasswordViewController.h"
#import "MOLLoginRequest.h"

@interface MOLPhoneLoginViewController ()
@property (nonatomic, strong) MOLAccountViewModel *accountViewModel;
@property (nonatomic, weak) MOLPhoneLoginView *phoneLoginView;

@property (nonatomic, strong) NSString *frontPhoneNumber;
@end

@implementation MOLPhoneLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEX_COLOR_ALPHA(0x161824, 0.4);
    
    self.accountViewModel = [[MOLAccountViewModel alloc] init];
    
    [self setupPhoneLoginViewControllerUI];
    
    [self bindingViewModel];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.phoneLoginView.textField becomeFirstResponder];
}

#pragma mark - 按钮点击
- (void)button_clickForget  // 忘记密码
{
    if (!self.phoneLoginView.textField.text.length) {
        [MBProgressHUD showMessageAMoment:@"手机号码不能为空"];
        return;
    }
    
    if (![self isPhoneNum:self.phoneLoginView.textField.text]) {
        [MBProgressHUD showMessageAMoment:@"手机号码格式错误"];
        return;
    }
    
    // 检查是否是已注册用户
    MOLLoginRequest *r = [[MOLLoginRequest alloc] initRequest_checkUserAccountWithParameter:nil parameterId:[self.phoneLoginView.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        NSInteger c = [request.responseObject[@"resBody"] integerValue];
        if (code == MOL_SUCCESS_REQUEST && c == 1) {
            if (![self.frontPhoneNumber isEqualToString:self.phoneLoginView.textField.text]) {
                [[MOLCodeTimerManager shareCodeTimerManager] codeTimer_stopTimer];
            }
            if ([MOLCodeTimerManager shareCodeTimerManager].showTime != MOL_CODETIME) {
                MOLLookPasswordViewController *vc = [[MOLLookPasswordViewController alloc] init];
                vc.phoneNumber = self.phoneLoginView.textField.text;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                // 发送验证码
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                dic[@"paraId"] = [self.phoneLoginView.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                [self.accountViewModel.codeCommand execute:dic];
            }
            
            self.frontPhoneNumber = self.phoneLoginView.textField.text;
        }else{
            [MBProgressHUD showMessageAMoment:@"手机号尚未注册，无须找回密码"];
        }
    } failure:^(__kindof MOLBaseNetRequest *request) {
        
    }];
}

- (void)button_clickNext  // 下一步
{
    if (!self.phoneLoginView.textField.text.length) {
        [MBProgressHUD showMessageAMoment:@"手机号码不能为空"];
        return;
    }
    
    if (!self.phoneLoginView.pswTextField.text.length) {
        [MBProgressHUD showMessageAMoment:@"密码不能为空"];
        return;
    }
    
    if (![self isPhoneNum:self.phoneLoginView.textField.text]) {
        [MBProgressHUD showMessageAMoment:@"手机号码格式错误"];
        return;
    }
    
    if (self.phoneLoginView.pswTextField.text.length < 6) {
        [MBProgressHUD showMessageAMoment:@"密码太短,请输入6-32位密码"];
        return;
    }
    
    if (self.phoneLoginView.pswTextField.text.length > 32) {
        [MBProgressHUD showMessageAMoment:@"密码太短,请输入6-32位密码"];
        return;
    }
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"loginType"] = @"1";
    dic[@"phone"] = [self.phoneLoginView.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    dic[@"password"] = [self.phoneLoginView.pswTextField.text mol_md5WithOrigin];
    
    // 发送登录请求
    [self.accountViewModel.loginCommand execute:dic];
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
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }else{
//            [MBProgressHUD showMessageAMoment:user.message];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"密码错误，是否找回密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self button_clickForget];
            }];
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:okAction];
            [alertController addAction:cancleAction];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:alertController animated:YES completion:nil];
            });
        }
    }];
    
    [self.accountViewModel.codeCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        
        if ([x integerValue] == MOL_SUCCESS_REQUEST) {
            
            MOLLookPasswordViewController *vc = [[MOLLookPasswordViewController alloc] init];
            vc.phoneNumber = self.phoneLoginView.textField.text;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

#pragma mark - UI
- (void)setupPhoneLoginViewControllerUI
{
    MOLPhoneLoginView *phoneLoginView = [[MOLPhoneLoginView alloc] init];
    _phoneLoginView = phoneLoginView;
    [phoneLoginView.nextButton addTarget:self action:@selector(button_clickNext) forControlEvents:UIControlEventTouchUpInside];
    [phoneLoginView.forgetButton addTarget:self action:@selector(button_clickForget) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phoneLoginView];
}

- (void)calculatorPhoneLoginViewControllerFrame
{
    self.phoneLoginView.frame = self.view.bounds;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self calculatorPhoneLoginViewControllerFrame];
}

- (BOOL)isPhoneNum:(NSString *)number
{
    if ([MOLRegular mol_RegularMobileNumber:[number stringByReplacingOccurrencesOfString:@" " withString:@""]]) {
        return number.length == 13;
    }
    return NO;
}
@end
