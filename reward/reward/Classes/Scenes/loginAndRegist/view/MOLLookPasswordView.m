//
//  MOLLookPasswordView.m
//  reward
//
//  Created by moli-2017 on 2018/9/21.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLLookPasswordView.h"
#import "MOLWebViewController.h"

@interface MOLLookPasswordView ()<YYTextKeyboardObserver>
@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, weak) UILabel *label1;
@property (nonatomic, weak) UILabel *label2;

@property (nonatomic, weak) UIView *codeBoardView; // 边框
@property (nonatomic, weak) UIView *pswBoardView; // 边框

@property (nonatomic, weak) YYLabel *label4;
@end

@implementation MOLLookPasswordView

-(void)dealloc
{
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLookPasswordViewUI];
        [[YYTextKeyboardManager defaultManager] addObserver:self];
    }
    return self;
}

- (void)setPhoneNumber:(NSString *)phoneNumber
{
    _phoneNumber = phoneNumber;
    NSString *phoneN = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *n = [NSString stringWithFormat:@"输入+86 %@收到的4位验证码",phoneN];
    self.label2.attributedText = [self attributedString:n word:phoneN];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - YYTextKeyboardObserver
- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition
{
    CGRect kbFrame = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self];
    
    [UIView animateWithDuration:transition.animationDuration delay:0 options:transition.animationOption animations:^{
        ///用此方法获取键盘的rect
        if (kbFrame.origin.y >= MOL_SCREEN_HEIGHT) {
            
            self.nextButton.bottom = kbFrame.origin.y - MOL_SCREEN_ADAPTER(35);
            self.label4.bottom = self.nextButton.y - MOL_SCREEN_ADAPTER(15);
        }else{
            self.nextButton.bottom = kbFrame.origin.y - MOL_SCREEN_ADAPTER(5);
            self.label4.bottom = self.nextButton.y - MOL_SCREEN_ADAPTER(5);
        }
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)inputVertifyNum:(UITextField *)field
{
    if (field.text.length >= 4) {
        field.text = [field.text substringToIndex:4];
    }
}

#pragma mark - UI
- (void)setupLookPasswordViewUI
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_beijing"]];
    _imageView = imageView;
    [self addSubview:imageView];
    
    UILabel *label1 = [[UILabel alloc] init];
    _label1 = label1;
    label1.textColor = HEX_COLOR_ALPHA(0xffffff, 0.9);
    label1.text = @"找回密码";
    label1.font = MOL_MEDIUM_FONT(22);
    [self addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] init];
    _label2 = label2;
    label2.textColor = HEX_COLOR_ALPHA(0xffffff, 0.8);
    label2.attributedText = [self attributedString:@"输入+86 收到的4位验证码" word:nil];
    label2.font = MOL_MEDIUM_FONT(12);
    [self addSubview:label2];
    
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
    NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:@"输入短信验证码" attributes:
                                       @{NSForegroundColorAttributeName:HEX_COLOR_ALPHA(0xffffff, 0.6),NSFontAttributeName:codeTextField.font}];
    codeTextField.attributedPlaceholder = attrString1;
    codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [[codeTextField valueForKey:@"_clearButton"] setImage:[UIImage imageNamed:@"login_clear"] forState:UIControlStateNormal];
    [codeTextField addTarget:self action:@selector(inputVertifyNum:) forControlEvents:UIControlEventEditingChanged];
    [codeBoardView addSubview:codeTextField];
    
    UIButton *codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _codeButton = codeButton;
    [codeButton setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [codeButton setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateDisabled];
    [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeButton setTitleColor:HEX_COLOR(0xFFEC00) forState:UIControlStateNormal];
    [codeButton setTitleColor:HEX_COLOR(0xFFEC00) forState:UIControlStateDisabled];
    codeButton.titleLabel.font = MOL_REGULAR_FONT(14);
    codeButton.layer.cornerRadius = 5;
    codeButton.layer.borderWidth = 2;
    codeButton.layer.borderColor = HEX_COLOR_ALPHA(0xffffff, 0.6).CGColor;
    codeButton.clipsToBounds = YES;
    [self addSubview:codeButton];
    
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
    pswTextField.secureTextEntry = YES;
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"输入新密码" attributes:
                                       @{NSForegroundColorAttributeName:HEX_COLOR_ALPHA(0xffffff, 0.6),NSFontAttributeName:pswTextField.font}];
    pswTextField.attributedPlaceholder = attrString;
    
    pswTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [[pswTextField valueForKey:@"_clearButton"] setImage:[UIImage imageNamed:@"login_clear"] forState:UIControlStateNormal];
    [pswBoardView addSubview:pswTextField];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"继续表示您同意CC"];
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"用户协议"];
    text.yy_font = MOL_MEDIUM_FONT(14);
    text.yy_color = HEX_COLOR_ALPHA(0xffffff, 0.6);
    one.yy_font = MOL_MEDIUM_FONT(14);
    one.yy_color = HEX_COLOR_ALPHA(0xFFEC00, 0.6);
    //    one.yy_underlineStyle = NSUnderlineStyleSingle;
    @weakify(self);
    [one yy_setTextHighlightRange:one.yy_rangeOfAll
                            color:HEX_COLOR_ALPHA(0xFFEC00, 0.6)
                  backgroundColor:[UIColor clearColor]
                        tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                            @strongify(self);
                            NSLog(@"用户协议");
                            MOLWebViewController *vc = [[MOLWebViewController alloc] init];
                            NSString *offic = MOL_OFFIC_SERVICE_H5;  // 正式
#ifdef MOL_TEST_HOST
                            offic = MOL_TEST_SERVICE;  // 测试
#endif
                            vc.urlString = [NSString stringWithFormat:@"%@/static/views/app/about/userAgreement.html",offic];
                            
                            [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
                            
                        }];
    [text appendAttributedString:one];
    YYLabel *label4 = [[YYLabel alloc] init];
    _label4 = label4;
    label4.width = 200;
    label4.height = 20;
    label4.attributedText = text;
    label4.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label4];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextButton = nextButton;
    [nextButton setImage:[UIImage imageNamed:@"login_xiayibu"] forState:UIControlStateNormal];
    
    [self addSubview:nextButton];
}

- (void)calculatorLookPasswordViewFrame
{
    self.imageView.frame = self.bounds;
    
    [self.label1 sizeToFit];
    [self.label2 sizeToFit];
    [self.label4 sizeToFit];
    
    self.label1.centerX = self.width * 0.5;
    self.label2.centerX = self.width * 0.5;
    self.label4.centerX = self.width * 0.5;
    
    self.label1.y = iPhone4 ? 0:MOL_SCREEN_ADAPTER(100);
    self.label2.y = self.label1.bottom + MOL_SCREEN_ADAPTER(10);
    
    self.pswBoardView.width = MOL_SCREEN_ADAPTER(300);
    self.pswBoardView.height = MOL_SCREEN_ADAPTER(50);
    self.pswBoardView.centerX = self.label1.centerX;
    self.pswBoardView.y = self.label2.bottom + MOL_SCREEN_ADAPTER(85);
    
    self.pswTextField.width = self.pswBoardView.width - MOL_SCREEN_ADAPTER(40);
    self.pswTextField.x = MOL_SCREEN_ADAPTER(20);
    self.pswTextField.height = 30;
    self.pswTextField.centerY = self.pswBoardView.height * 0.5;
    
    self.codeBoardView.width = MOL_SCREEN_ADAPTER(195);
    self.codeBoardView.height = MOL_SCREEN_ADAPTER(50);
    self.codeBoardView.x = self.pswBoardView.x;
    self.codeBoardView.y = self.label2.bottom + MOL_SCREEN_ADAPTER(30);
    
    self.codeTextField.width = self.codeBoardView.width - MOL_SCREEN_ADAPTER(40);
    self.codeTextField.x = MOL_SCREEN_ADAPTER(20);
    self.codeTextField.height = 30;
    self.codeTextField.centerY = self.codeBoardView.height * 0.5;
    
    self.codeButton.width = MOL_SCREEN_ADAPTER(100);
    self.codeButton.height = MOL_SCREEN_ADAPTER(50);
    self.codeButton.x = self.codeBoardView.right + 5;
    self.codeButton.centerY = self.codeBoardView.centerY;
    
    [self.nextButton sizeToFit];
    self.nextButton.centerX = self.label1.centerX;
    self.nextButton.bottom = self.height - MOL_SCREEN_ADAPTER(35);
    
    self.label4.bottom = self.nextButton.y - MOL_SCREEN_ADAPTER(15);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorLookPasswordViewFrame];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}
@end
