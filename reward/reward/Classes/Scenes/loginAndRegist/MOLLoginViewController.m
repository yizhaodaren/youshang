//
//  MOLLoginViewController.m
//  reward
//
//  Created by moli-2017 on 2018/9/11.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLLoginViewController.h"
#import "MOLLoginView.h"
#import "MOLAccountViewModel.h"

@interface MOLLoginViewController ()
@property (nonatomic, strong) MOLAccountViewModel *accountViewModel;
@property (nonatomic, weak) MOLLoginView *loginView;
@end

@implementation MOLLoginViewController

- (BOOL)showNavigation
{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_COLOR_ALPHA(0x161824, 0.4);
    
    self.accountViewModel = [[MOLAccountViewModel alloc] init];
    
    [self setupLoginViewControllerUI];
    
    [self bindingViewModel];
}


#pragma mark - bindingViewModel
- (void)bindingViewModel
{
    @weakify(self);
    [self.accountViewModel.loginCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        MOLUserModel *user = (MOLUserModel *)x;
        if (user.code == MOL_SUCCESS_REQUEST) {
            // 登录成功
            [MOLUserManagerInstance user_saveUserInfoWithModel:user isLogin:YES];
            [[MOLCodeTimerManager shareCodeTimerManager] codeTimer_stopTimer];
            // 绑定手机
            if (!user.phone.length) {
                [[MOLGlobalManager shareGlobalManager] global_modalBindingPhoneWithAnimate:YES];
            }
        }else{
            [MBProgressHUD showMessageAMoment:user.message];
        }
    }];
}

#pragma mark - 按钮点击
- (void)button_clickWX  // wx
{
    [self getUserInfoForPlatform:UMSocialPlatformType_WechatSession];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    });
    
}

- (void)button_clickWB  // wb
{
    [self getUserInfoForPlatform:UMSocialPlatformType_Sina];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    });
}

- (void)button_clickQQ  // qq
{
    [self getUserInfoForPlatform:UMSocialPlatformType_QQ];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    });
}


- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            [MBProgressHUD showMessageAMoment:@""];
        } else {
            UMSocialUserInfoResponse *resp = result;
            // 第三方登录数据(为空表示平台未提供)
            // 发送登录请求
            MOLUserManagerInstance.platType = 4;
            MOLUserManagerInstance.platToken = resp.accessToken;
            MOLUserManagerInstance.platUid = resp.uid;
            MOLUserManagerInstance.platOpenid = nil;
            if (platformType == UMSocialPlatformType_WechatSession) {
                MOLUserManagerInstance.platType = 2;
                MOLUserManagerInstance.platOpenid = resp.openid;
                MOLUserManagerInstance.platUid = resp.unionId;
            }else if (platformType == UMSocialPlatformType_Sina){
                MOLUserManagerInstance.platType = 3;
            }
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"accessToken"] = MOLUserManagerInstance.platToken;
            dic[@"loginType"] = @(MOLUserManagerInstance.platType);
            dic[@"uid"] = MOLUserManagerInstance.platUid;
            if (MOLUserManagerInstance.platOpenid.length) {
                dic[@"openId"] = MOLUserManagerInstance.platOpenid;
            }
            [self.accountViewModel.loginCommand execute:dic];
        }
    }];
}

#pragma mark - UI
- (void)setupLoginViewControllerUI
{
    MOLLoginView *loginView = [[MOLLoginView alloc] init];
    _loginView = loginView;
    [loginView.wxButton addTarget:self action:@selector(button_clickWX) forControlEvents:UIControlEventTouchUpInside];
    [loginView.wbButton addTarget:self action:@selector(button_clickWB) forControlEvents:UIControlEventTouchUpInside];
    [loginView.qqButton addTarget:self action:@selector(button_clickQQ) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginView];
}

- (void)calculatorLoginViewControllerFrame
{
    self.loginView.frame = self.view.bounds;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self calculatorLoginViewControllerFrame];
}

//- (BOOL)prefersStatusBarHidden
//{
//    return YES;//隐藏为YES，显示为NO
//}

@end
