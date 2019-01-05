//
//  MOLLoginBindingPhoneViewController.m
//  reward
//
//  Created by moli-2017 on 2018/9/21.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLLoginBindingPhoneViewController.h"
#import "MOLLoginBindingPhoneView.h"
#import "MOLAccountViewModel.h"
#import "MOLLoginBindingPasswordViewController.h"
#import "MOLRegular.h"
#import "MOLLoginRequest.h"

@interface MOLLoginBindingPhoneViewController ()
@property (nonatomic, strong) MOLAccountViewModel *accountViewModel;
@property (nonatomic, weak) MOLLoginBindingPhoneView *bindingPhoneView;

@property (nonatomic, strong) NSString *frontPhoneNumber;
@end

@implementation MOLLoginBindingPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_COLOR_ALPHA(0x161824, 0.4);
    
    self.accountViewModel = [[MOLAccountViewModel alloc] init];
    
    [self setupLoginBindingPhoneViewControllerUI];
    
    [self setupNavigation];
    
    [self bindingViewModel];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.bindingPhoneView.textField becomeFirstResponder];
}

#pragma mark - 按钮的点击
- (void)button_clickJump   // 跳过
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

#pragma mark - bindingViewModel
- (void)bindingViewModel
{
    @weakify(self)
    [self.accountViewModel.codeCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        
        if ([x integerValue] == MOL_SUCCESS_REQUEST) {
            
            MOLLoginBindingPasswordViewController *vc = [[MOLLoginBindingPasswordViewController alloc] init];
            vc.phoneNumber = self.bindingPhoneView.textField.text;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

#pragma mark - 按钮点击
- (void)button_clickNext  // 点击下一步
{
    if (!self.bindingPhoneView.textField.text.length) {
        [MBProgressHUD showMessageAMoment:@"手机号不能为空"];
        return;
    }
    
    if (![self isPhoneNum:self.bindingPhoneView.textField.text]) {
        [MBProgressHUD showMessageAMoment:@"手机号码格式错误"];
        return;
    }
    
    // 检查是否是已注册用户
    MOLLoginRequest *r = [[MOLLoginRequest alloc] initRequest_checkUserAccountWithParameter:nil parameterId:[self.bindingPhoneView.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        NSInteger c = [request.responseObject[@"resBody"] integerValue];
        if (code == MOL_SUCCESS_REQUEST) {
            
            if (c == 1) {
                [MBProgressHUD showMessageAMoment:@"手机号已经注册，请更换手机号"];
            }else{
                if (![self.frontPhoneNumber isEqualToString:self.bindingPhoneView.textField.text]) {
                    [[MOLCodeTimerManager shareCodeTimerManager] codeTimer_stopTimer];
                }
                if ([MOLCodeTimerManager shareCodeTimerManager].showTime != MOL_CODETIME) {
                    MOLLoginBindingPasswordViewController *vc = [[MOLLoginBindingPasswordViewController alloc] init];
                    vc.phoneNumber = self.bindingPhoneView.textField.text;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    // 发送验证码
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    dic[@"paraId"] = [self.bindingPhoneView.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                    [self.accountViewModel.codeCommand execute:dic];
                }
                
                self.frontPhoneNumber = self.bindingPhoneView.textField.text;
            }
            
        }else{
            [MBProgressHUD showMessageAMoment:message];
        }
    } failure:^(__kindof MOLBaseNetRequest *request) {
        
    }];
}

#pragma mark - 导航条
- (void)setupNavigation
{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *rightItem = [UIBarButtonItem mol_barButtonItemWithTitleName:@"跳过" color:HEX_COLOR_ALPHA(0xffffff, 0.9) disableColor:HEX_COLOR_ALPHA(0xffffff, 0.9) font:MOL_MEDIUM_FONT(14) targat:self action:@selector(button_clickJump)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - UI
- (void)setupLoginBindingPhoneViewControllerUI
{
    MOLLoginBindingPhoneView *bindingPhoneView = [[MOLLoginBindingPhoneView alloc] init];
    _bindingPhoneView = bindingPhoneView;
    [bindingPhoneView.nextButton addTarget:self action:@selector(button_clickNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bindingPhoneView];
}

- (void)calculatorLoginBindingPhoneViewControllerFrame
{
    self.bindingPhoneView.frame = self.view.bounds;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self calculatorLoginBindingPhoneViewControllerFrame];
}

- (BOOL)isPhoneNum:(NSString *)number
{
    if ([MOLRegular mol_RegularMobileNumber:[number stringByReplacingOccurrencesOfString:@" " withString:@""]]) {
        return number.length == 13;
    }
    return NO;
}
@end
