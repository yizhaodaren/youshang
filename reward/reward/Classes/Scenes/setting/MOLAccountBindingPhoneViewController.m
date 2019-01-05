//
//  MOLAccountBindingPhoneViewController.m
//  reward
//
//  Created by moli-2017 on 2018/9/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLAccountBindingPhoneViewController.h"
#import "MOLAccountSetPasswordViewController.h"
#import "MOLAccountBindingPhoneView.h"
#import "MOLAccountViewModel.h"

@interface MOLAccountBindingPhoneViewController ()
@property (nonatomic, strong) MOLAccountViewModel *accountViewModel;
@property (nonatomic, weak) MOLAccountBindingPhoneView *bindingView;
@property (nonatomic, strong) NSString *frontPhoneNumber;
@end

@implementation MOLAccountBindingPhoneViewController
- (BOOL)showNavigationLine
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.accountViewModel = [[MOLAccountViewModel alloc] init];
    
    [self setupAccountBindingPhoneViewControllerUI];
    [self setupNavigation];
    
    [self bindingViewModel];
}

#pragma mark - bindingViewModel
- (void)bindingViewModel
{
    @weakify(self);
    RAC(self.accountViewModel,phoneNumber) = self.bindingView.textField.rac_textSignal;
    RAC(self.navigationItem.rightBarButtonItem,enabled) = self.accountViewModel.bindingNextSignal;
    
    [self.accountViewModel.codeCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        
        if ([x integerValue] == MOL_SUCCESS_REQUEST) {
            
            MOLAccountSetPasswordViewController *vc = [[MOLAccountSetPasswordViewController alloc] init];
            vc.phoneString = self.bindingView.textField.text;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

#pragma mark - 按钮点击
- (void)button_clickFinish
{
    if (![self.frontPhoneNumber isEqualToString:self.bindingView.textField.text]) {
        [[MOLCodeTimerManager shareCodeTimerManager] codeTimer_stopTimer];
    }
    if ([MOLCodeTimerManager shareCodeTimerManager].showTime != MOL_CODETIME) {
        MOLAccountSetPasswordViewController *vc = [[MOLAccountSetPasswordViewController alloc] init];
        vc.phoneString = self.bindingView.textField.text;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        // 发送验证码
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"paraId"] = [self.bindingView.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        [self.accountViewModel.codeCommand execute:dic];
    }
    
    self.frontPhoneNumber = self.bindingView.textField.text;
}

#pragma mark - 导航条
- (void)setupNavigation
{
    UIBarButtonItem *rightItem = [UIBarButtonItem mol_barButtonItemWithTitleName:@"下一步" color:HEX_COLOR(0xffffff) disableColor:HEX_COLOR_ALPHA(0xffffff, 0.5) font:MOL_MEDIUM_FONT(14) targat:self action:@selector(button_clickFinish)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - UI
- (void)setupAccountBindingPhoneViewControllerUI
{
    MOLAccountBindingPhoneView *bindingView = [[MOLAccountBindingPhoneView alloc] init];
    _bindingView = bindingView;
    [self.view addSubview:bindingView];
}

- (void)calculatorAccountBindingPhoneViewControllerFrame
{
    self.bindingView.frame = self.view.bounds;
    self.bindingView.height = self.view.height - MOL_StatusBarAndNavigationBarHeight;
    self.bindingView.y = MOL_StatusBarAndNavigationBarHeight;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self calculatorAccountBindingPhoneViewControllerFrame];
}

@end
