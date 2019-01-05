//
//  MOLFirstSettingPasswordView.m
//  reward
//
//  Created by moli-2017 on 2018/9/25.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLFirstSettingPasswordView.h"

@interface MOLFirstSettingPasswordView ()
@property (nonatomic, weak) UIView *pswBoardView; // 边框
@property (nonatomic, weak) UIView *againPswBoardView; // 边框

@property (nonatomic, weak) UILabel *label3;
@end

@implementation MOLFirstSettingPasswordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupFirstSettingPasswordViewUI];
    }
    return self;
}

#pragma mark - UI
- (void)setupFirstSettingPasswordViewUI
{
    UIView *pswBoardView = [[UIView alloc] init];
    _pswBoardView = pswBoardView;
    pswBoardView.backgroundColor = [UIColor clearColor];
    pswBoardView.layer.cornerRadius = 5;
    pswBoardView.layer.borderWidth = 2;
    pswBoardView.layer.borderColor = HEX_COLOR_ALPHA(0xffffff, 0.6).CGColor;
    [self addSubview:pswBoardView];
    
    UITextField *pswTextField = [[UITextField alloc] init];
    _pswTextField = pswTextField;
    pswTextField.font = MOL_REGULAR_FONT(14);
    pswTextField.textColor = HEX_COLOR(0xffffff);
    NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:@"输入新密码" attributes:
                                       @{NSForegroundColorAttributeName:HEX_COLOR_ALPHA(0xffffff, 0.6),NSFontAttributeName:pswTextField.font}];
    pswTextField.attributedPlaceholder = attrString1;
    pswTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [[pswTextField valueForKey:@"_clearButton"] setImage:[UIImage imageNamed:@"login_clear"] forState:UIControlStateNormal];
    [pswBoardView addSubview:pswTextField];
    
    UIView *againPswBoardView = [[UIView alloc] init];
    _againPswBoardView = againPswBoardView;
    againPswBoardView.backgroundColor = [UIColor clearColor];
    againPswBoardView.layer.cornerRadius = 5;
    againPswBoardView.layer.borderWidth = 2;
    againPswBoardView.layer.borderColor = HEX_COLOR_ALPHA(0xffffff, 0.6).CGColor;
    [self addSubview:againPswBoardView];
    
    UITextField *againPswTextField = [[UITextField alloc] init];
    _againPswTextField = againPswTextField;
    againPswTextField.font = MOL_REGULAR_FONT(14);
    againPswTextField.textColor = HEX_COLOR(0xffffff);
    NSAttributedString *attrString2 = [[NSAttributedString alloc] initWithString:@"再次输入密码" attributes:
                                       @{NSForegroundColorAttributeName:HEX_COLOR_ALPHA(0xffffff, 0.6),NSFontAttributeName:againPswTextField.font}];
    againPswTextField.attributedPlaceholder = attrString2;
    againPswTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [[againPswTextField valueForKey:@"_clearButton"] setImage:[UIImage imageNamed:@"login_clear"] forState:UIControlStateNormal];
    [againPswBoardView addSubview:againPswTextField];
    
    UILabel *label3 = [[UILabel alloc] init];
    _label3 = label3;
    label3.textColor = HEX_COLOR_ALPHA(0xffffff, 0.6);
    label3.text = @"密码为6-20位，任意的字母、数字、符号";
    label3.font = MOL_REGULAR_FONT(12);
    [self addSubview:label3];
}

- (void)calculatorFirstSettingPasswordViewFrame
{
    // 新密码
    self.pswBoardView.width = MOL_SCREEN_ADAPTER(300);
    self.pswBoardView.height = MOL_SCREEN_ADAPTER(50);
    self.pswBoardView.centerX = self.width * 0.5;
    self.pswBoardView.y = 30;
    
    self.pswTextField.width = self.pswBoardView.width - MOL_SCREEN_ADAPTER(30);
    self.pswTextField.height = 30;
    self.pswTextField.x = MOL_SCREEN_ADAPTER(15);
    self.pswTextField.centerY = self.pswBoardView.height * 0.5;
    
    // 确认密码
    self.againPswBoardView.width = MOL_SCREEN_ADAPTER(300);
    self.againPswBoardView.height = MOL_SCREEN_ADAPTER(50);
    self.againPswBoardView.centerX = self.width * 0.5;
    self.againPswBoardView.y = self.pswBoardView.bottom + MOL_SCREEN_ADAPTER(5);
    
    self.againPswTextField.width = self.againPswBoardView.width - MOL_SCREEN_ADAPTER(30);
    self.againPswTextField.height = 30;
    self.againPswTextField.x = MOL_SCREEN_ADAPTER(15);
    self.againPswTextField.centerY = self.againPswBoardView.height * 0.5;
    
    self.label3.x = self.pswBoardView.x;
    self.label3.y = self.againPswBoardView.bottom + MOL_SCREEN_ADAPTER(10);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorFirstSettingPasswordViewFrame];
}
@end
