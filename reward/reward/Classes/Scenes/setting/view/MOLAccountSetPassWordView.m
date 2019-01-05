//
//  MOLAccountSetPassWordView.m
//  reward
//
//  Created by moli-2017 on 2018/9/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLAccountSetPassWordView.h"

@interface MOLAccountSetPassWordView ()

@property (nonatomic, weak) UILabel *label1;
@property (nonatomic, weak) UILabel *label2;

@property (nonatomic, weak) UIView *codeBoardView; // 边框

@property (nonatomic, weak) UIView *pswBoardView; // 边框

@property (nonatomic, weak) UILabel *label3;

@end

@implementation MOLAccountSetPassWordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupAccountSetPassWordViewUI];
        [[MOLCodeTimerManager shareCodeTimerManager] codeTimer_beginTimerWithButton:self.codeButton timeDownBlock:nil];
    }
    return self;
}

- (void)setPhone:(NSString *)phone
{
    _phone = phone;
    NSString *phoneN = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *n = [NSString stringWithFormat:@"输入+86 %@收到的4位验证码",phoneN];
    self.label2.attributedText = [self attributedString:n word:phoneN];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


#pragma mark - UI
- (void)setupAccountSetPassWordViewUI
{
    UILabel *label1 = [[UILabel alloc] init];
    _label1 = label1;
    label1.textColor = HEX_COLOR_ALPHA(0xffffff, 0.9);
    label1.text = @"绑定手机号";
    label1.font = MOL_MEDIUM_FONT(22);
    [self addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] init];
    _label2 = label2;
    label2.textColor = HEX_COLOR_ALPHA(0xffffff, 1);
    label2.attributedText = [self attributedString:@"输入+86 收到的4位验证码" word:@"000"];
    label2.font = MOL_MEDIUM_FONT(12);
    [self addSubview:label2];
    
    UIButton *codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _codeButton = codeButton;
    [codeButton setBackgroundImage:[UIImage imageWithColor:HEX_COLOR_ALPHA(0xFFEC00, 1)] forState:UIControlStateNormal];
    [codeButton setBackgroundImage:[UIImage imageWithColor:HEX_COLOR_ALPHA(0xffffff, 0.6)] forState:UIControlStateDisabled];
    [codeButton setTitle:@"重新发送" forState:UIControlStateNormal];
    [codeButton setTitleColor:HEX_COLOR(0x322200) forState:UIControlStateNormal];
    [codeButton setTitleColor:HEX_COLOR(0x322200) forState:UIControlStateDisabled];
    codeButton.titleLabel.font = MOL_REGULAR_FONT(12);
    codeButton.layer.cornerRadius = 3;
    codeButton.clipsToBounds = YES;
    
    [self addSubview:codeButton];
    
    UIView *codeBoardView = [[UIView alloc] init];
    _codeBoardView = codeBoardView;
    codeBoardView.backgroundColor = [UIColor clearColor];
    codeBoardView.layer.cornerRadius = 5;
    codeBoardView.layer.borderWidth = 2;
    codeBoardView.layer.borderColor = HEX_COLOR_ALPHA(0xffffff, 0.6).CGColor;
    [self addSubview:codeBoardView];
    
    UITextField *codeTextField = [[UITextField alloc] init];
    _codeTextField = codeTextField;
    codeTextField.font = MOL_REGULAR_FONT(14);
    codeTextField.textColor = HEX_COLOR(0xffffff);
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"输入短信验证码" attributes:
                                      @{NSForegroundColorAttributeName:HEX_COLOR_ALPHA(0xffffff, 0.6),NSFontAttributeName:codeTextField.font}];
    codeTextField.attributedPlaceholder = attrString;
    codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [codeTextField becomeFirstResponder];
    codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [[codeTextField valueForKey:@"_clearButton"] setImage:[UIImage imageNamed:@"login_clear"] forState:UIControlStateNormal];
    [codeBoardView addSubview:codeTextField];
    
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
    NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:@"设置登录密码" attributes:
                                      @{NSForegroundColorAttributeName:HEX_COLOR_ALPHA(0xffffff, 0.6),NSFontAttributeName:pswTextField.font}];
    pswTextField.attributedPlaceholder = attrString1;
    pswTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [[pswTextField valueForKey:@"_clearButton"] setImage:[UIImage imageNamed:@"login_clear"] forState:UIControlStateNormal];
    [pswBoardView addSubview:pswTextField];
    
    UILabel *label3 = [[UILabel alloc] init];
    _label3 = label3;
    label3.textColor = HEX_COLOR_ALPHA(0xffffff, 0.6);
    label3.text = @"密码为6-20位，任意的字母、数字、符号";
    label3.font = MOL_REGULAR_FONT(12);
    [self addSubview:label3];
    
}

- (void)calculatorAccountSetPassWordViewFrame
{
    [self.label1 sizeToFit];
    self.label1.centerX = self.width * 0.5;
    self.label1.y = MOL_SCREEN_ADAPTER(90);
    
    self.codeBoardView.width = MOL_SCREEN_ADAPTER(300);
    self.codeBoardView.height = MOL_SCREEN_ADAPTER(50);
    self.codeBoardView.centerX = self.label1.centerX;
    self.codeBoardView.y = self.label1.bottom + MOL_SCREEN_ADAPTER(57);
    
    self.codeTextField.width = self.codeBoardView.width - MOL_SCREEN_ADAPTER(30);
    self.codeTextField.height = 30;
    self.codeTextField.x = MOL_SCREEN_ADAPTER(15);
    self.codeTextField.centerY = self.codeBoardView.height * 0.5;
    
    self.pswBoardView.width = self.codeBoardView.width;
    self.pswBoardView.height = self.codeBoardView.height;
    self.pswBoardView.centerX = self.label1.centerX;
    self.pswBoardView.y = self.codeBoardView.bottom + MOL_SCREEN_ADAPTER(5);
    
    self.pswTextField.width = self.pswBoardView.width - MOL_SCREEN_ADAPTER(30);
    self.pswTextField.height = 30;
    self.pswTextField.x = MOL_SCREEN_ADAPTER(15);
    self.pswTextField.centerY = self.pswBoardView.height * 0.5;
    
    [self.label2 sizeToFit];
    self.label2.x = self.codeBoardView.x;
    self.label2.y = self.label1.bottom + MOL_SCREEN_ADAPTER(10);
    
    self.codeButton.width = 60;
    self.codeButton.height = 20;
    self.codeButton.x = self.label2.right + 6;
    self.codeButton.centerY = self.label2.centerY;
    
    [self.label3 sizeToFit];
    self.label3.x = self.codeBoardView.x;
    self.label3.y = self.pswBoardView.bottom + MOL_SCREEN_ADAPTER(10);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorAccountSetPassWordViewFrame];
}

- (NSMutableAttributedString *)attributedString:(NSString *)text word:(NSString *)keyWord
{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text];
    // 获取关键字的位置
    if (keyWord.length) {
        NSRange rang = [text rangeOfString:keyWord];
        [attr addAttribute:NSFontAttributeName value:MOL_MEDIUM_FONT(12) range:rang];
        [attr addAttribute:NSForegroundColorAttributeName value:HEX_COLOR_ALPHA(0xFFEC00, 1) range:rang];
    }
    return attr;
}
@end
