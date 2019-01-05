//
//  MOLLoginView.m
//  reward
//
//  Created by moli-2017 on 2018/9/21.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLLoginView.h"
#import "MOLPhoneQuicklyLoginViewController.h"
#import "MOLPhoneLoginViewController.h"

@interface MOLLoginView ()

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, weak) UIButton *pswLoginButton;
@property (nonatomic, weak) UIButton *closeButton;
@property (nonatomic, weak) UIButton *phoneButton;
@property (nonatomic, weak) UILabel *label;

@end

@implementation MOLLoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupLoginViewUI];
    }
    return self;
}

#pragma mark - 按钮点击
- (void)button_clickClose   // 关闭
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[[MOLGlobalManager shareGlobalManager] global_currentViewControl] dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)button_clickpswLoginButton  // 密码登录
{
    MOLPhoneLoginViewController *vc = [[MOLPhoneLoginViewController alloc] init];
    [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
}

- (void)button_clickPhone  // phone
{
    // 友盟统计
    [MobClick event:@"_c_seclet_phone_login"];
    
    MOLPhoneQuicklyLoginViewController *vc = [[MOLPhoneQuicklyLoginViewController alloc] init];
    [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
}


#pragma mark - UI
- (void)setupLoginViewUI
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_beijing"]];
    _imageView = imageView;
    [self addSubview:imageView];
    
    UIButton *pswLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _pswLoginButton = pswLoginButton;
    [pswLoginButton setTitle:@"密码登录" forState:UIControlStateNormal];
    [pswLoginButton setTitleColor:HEX_COLOR_ALPHA(0xffffff, 0.9) forState:UIControlStateNormal];
    pswLoginButton.titleLabel.font = MOL_MEDIUM_FONT(14);
    [pswLoginButton addTarget:self action:@selector(button_clickpswLoginButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:pswLoginButton];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton = closeButton;
    [closeButton setImage:[UIImage imageNamed:@"login_guanbi"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(button_clickClose) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    
    UIButton *wxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _wxButton = wxButton;
    [wxButton setTitleColor:HEX_COLOR_ALPHA(0xffffff, 0.8) forState:UIControlStateNormal];
    [wxButton setTitle:@"微信一键登录" forState:UIControlStateNormal];
    wxButton.titleLabel.font = MOL_MEDIUM_FONT(14);
    [wxButton setImage:[UIImage imageNamed:@"login_weixin"] forState:UIControlStateNormal];
    wxButton.backgroundColor = HEX_COLOR_ALPHA(0x61B847, 1);
    wxButton.layer.cornerRadius = 5;
    wxButton.clipsToBounds = YES;
    [self addSubview:wxButton];
    
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _phoneButton = phoneButton;
    [phoneButton setTitleColor:HEX_COLOR_ALPHA(0xffffff, 0.8) forState:UIControlStateNormal];
    [phoneButton setTitle:@"手机快捷登录" forState:UIControlStateNormal];
    phoneButton.titleLabel.font = MOL_MEDIUM_FONT(14);
    [phoneButton setImage:[UIImage imageNamed:@"login_shouji"] forState:UIControlStateNormal];
    [phoneButton addTarget:self action:@selector(button_clickPhone) forControlEvents:UIControlEventTouchUpInside];
    phoneButton.backgroundColor = [UIColor clearColor];
    phoneButton.layer.cornerRadius = 5;
    phoneButton.layer.borderColor = HEX_COLOR_ALPHA(0xffffff, 0.6).CGColor;
    phoneButton.layer.borderWidth = 2;
    phoneButton.clipsToBounds = YES;
    [self addSubview:phoneButton];
    
    UILabel *label = [[UILabel alloc] init];
    _label = label;
    label.text = @"其他登录方式";
    label.textColor = HEX_COLOR_ALPHA(0xffffff, 0.6);
    label.font = MOL_MEDIUM_FONT(14);
    [self addSubview:label];
    
    UIButton *wbButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _wbButton = wbButton;
    [wbButton setImage:[UIImage imageNamed:@"login_weibo"] forState:UIControlStateNormal];
    
    [self addSubview:wbButton];
    
    UIButton *qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _qqButton = qqButton;
    [qqButton setImage:[UIImage imageNamed:@"login_qq"] forState:UIControlStateNormal];
    
    [self addSubview:qqButton];
    
}

- (void)calculatorLoginViewFrame
{
    self.imageView.frame = self.bounds;
    
    [self.pswLoginButton sizeToFit];
    self.pswLoginButton.x = 20;
    self.pswLoginButton.y = 32;
    
    [self.closeButton sizeToFit];
    self.closeButton.centerY = self.pswLoginButton.centerY;
    self.closeButton.right = self.width - 20;
    
    self.wxButton.width = MOL_SCREEN_ADAPTER(300);
    self.wxButton.height = MOL_SCREEN_ADAPTER(50);
    self.wxButton.centerX = self.width * 0.5;
    self.wxButton.y = MOL_SCREEN_ADAPTER(237);
    
    self.phoneButton.width = self.wxButton.width;
    self.phoneButton.height = self.wxButton.height;
    self.phoneButton.centerX = self.wxButton.centerX;
    self.phoneButton.y = self.wxButton.bottom + 5;
    
    [self.qqButton sizeToFit];
    self.qqButton.bottom = self.height - 10;
    self.qqButton.right = self.width * 0.5 - 30;
    
    [self.wbButton sizeToFit];
    self.wbButton.bottom = self.qqButton.bottom;
    self.wbButton.x = self.width * 0.5 + 30;
    
    [self.label sizeToFit];
    self.label.centerX = self.width * 0.5;
    self.label.bottom = self.qqButton.y - 15;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorLoginViewFrame];
}
@end
