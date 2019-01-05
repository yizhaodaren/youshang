//
//  MOLPhoneLoginView.m
//  reward
//
//  Created by moli-2017 on 2018/9/21.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLPhoneLoginView.h"
#import "MOLWebViewController.h"

@interface MOLPhoneLoginView ()<UITextFieldDelegate, YYTextKeyboardObserver>
@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, weak) UILabel *label1;

@property (nonatomic, weak) UIView *boardView; // 边框
@property (nonatomic, weak) UILabel *label3; // + 86
@property (nonatomic, weak) UIView *lineView; // 竖线

@property (nonatomic, weak) UIView *pswBoardView; // 边框

@property (nonatomic, weak) YYLabel *label4;

@end

@implementation MOLPhoneLoginView

-(void)dealloc
{
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupPhoneLoginViewUI];
        [[YYTextKeyboardManager defaultManager] addObserver:self];
    }
    return self;
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

#pragma mark - UI
- (void)setupPhoneLoginViewUI
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_beijing"]];
    _imageView = imageView;
    [self addSubview:imageView];
    
    UILabel *label1 = [[UILabel alloc] init];
    _label1 = label1;
    label1.textColor = HEX_COLOR_ALPHA(0xffffff, 0.8);
    label1.text = @"手机号登录有助于您快速找到好友";
    label1.font = MOL_MEDIUM_FONT(12);
    [self addSubview:label1];
    
    UIView *boardView = [[UIView alloc] init];
    _boardView = boardView;
    boardView.backgroundColor = [UIColor clearColor];
    boardView.layer.cornerRadius = 5;
    boardView.layer.borderWidth = 2;
    boardView.layer.borderColor = HEX_COLOR_ALPHA(0xffffff, 0.6).CGColor;
    [self addSubview:boardView];
    
    UILabel *label3 = [[UILabel alloc] init];
    _label3 = label3;
    label3.textColor = HEX_COLOR_ALPHA(0xffffff, 0.8);
    label3.text = @"+86";
    label3.font = MOL_MEDIUM_FONT(14);
    [boardView addSubview:label3];
    
    UIView *lineView = [[UIView alloc] init];
    _lineView = lineView;
    lineView.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.8);
    [boardView addSubview:lineView];
    
    UITextField *textField = [[UITextField alloc] init];
    _textField = textField;
    textField.font = MOL_REGULAR_FONT(14);
    textField.textColor = HEX_COLOR(0xffffff);
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:
                                      @{NSForegroundColorAttributeName:HEX_COLOR_ALPHA(0xffffff, 0.6),NSFontAttributeName:textField.font}];
    textField.attributedPlaceholder = attrString;
    textField.delegate = self;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [[textField valueForKey:@"_clearButton"] setImage:[UIImage imageNamed:@"login_clear"] forState:UIControlStateNormal];
    [boardView addSubview:textField];
    
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
    NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:@"输入登录密码" attributes:
                                       @{NSForegroundColorAttributeName:HEX_COLOR_ALPHA(0xffffff, 0.6),NSFontAttributeName:pswTextField.font}];
    pswTextField.attributedPlaceholder = attrString1;
    pswTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [[pswTextField valueForKey:@"_clearButton"] setImage:[UIImage imageNamed:@"login_clear"] forState:UIControlStateNormal];
    [pswBoardView addSubview:pswTextField];
    
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _forgetButton = forgetButton;
    forgetButton.backgroundColor = [UIColor clearColor];
    [forgetButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetButton setTitleColor:HEX_COLOR(0xFFEC00) forState:UIControlStateNormal];
    forgetButton.titleLabel.font = MOL_REGULAR_FONT(12);
    [self addSubview:forgetButton];
    
    
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

- (void)calculatorPhoneLoginViewFrame
{
    self.imageView.frame = self.bounds;
    
    [self.label1 sizeToFit];
    [self.label3 sizeToFit];
    [self.label4 sizeToFit];
    
    self.label1.centerX = self.width * 0.5;
    self.label4.centerX = self.width * 0.5;
    
    CGFloat h = iPhone4 ? 0:MOL_SCREEN_ADAPTER(100);
    self.label1.y = h + MOL_SCREEN_ADAPTER(10);
    
    self.boardView.width = MOL_SCREEN_ADAPTER(300);
    self.boardView.height = MOL_SCREEN_ADAPTER(50);
    self.boardView.centerX = self.label1.centerX;
    self.boardView.y = self.label1.bottom + MOL_SCREEN_ADAPTER(30);
    
    self.label3.x = MOL_SCREEN_ADAPTER(20);
    self.label3.centerY = self.boardView.height * 0.5;
    
    self.lineView.width = 1;
    self.lineView.height = 15;
    self.lineView.x = self.label3.right + 5;
    self.lineView.centerY = self.label3.centerY;
    
    self.textField.x = self.lineView.right + 5;
    self.textField.height = 30;
    self.textField.centerY = self.label3.centerY;
    self.textField.width = self.boardView.width - self.textField.x - 10;
    
    self.pswBoardView.width = MOL_SCREEN_ADAPTER(300);
    self.pswBoardView.height = MOL_SCREEN_ADAPTER(50);
    self.pswBoardView.x = self.boardView.x;
    self.pswBoardView.y = self.boardView.bottom + 5;
    
    self.pswTextField.width = self.pswBoardView.width - MOL_SCREEN_ADAPTER(40);
    self.pswTextField.x = MOL_SCREEN_ADAPTER(20);
    self.pswTextField.height = 30;
    self.pswTextField.centerY = self.pswBoardView.height * 0.5;
    
    self.forgetButton.width = 60;
    self.forgetButton.height = 17;
    self.forgetButton.y = self.pswBoardView.bottom + MOL_SCREEN_ADAPTER(20);
    self.forgetButton.centerX = self.label1.centerX;
    
    [self.nextButton sizeToFit];
    self.nextButton.centerX = self.label1.centerX;
    self.nextButton.bottom = self.height - MOL_SCREEN_ADAPTER(35);
    
    self.label4.bottom = self.nextButton.y - MOL_SCREEN_ADAPTER(15);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorPhoneLoginViewFrame];
}

#pragma mark - 手机号的输入设置
// 手机号码输入
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField) {
        NSString* text = textField.text;
        //删除
        if([string isEqualToString:@""]){
            
            //删除一位
            if(range.length == 1){
                //最后一位,遇到空格则多删除一次
                if (range.location == text.length-1 ) {
                    if ([text characterAtIndex:text.length-1] == ' ') {
                        [textField deleteBackward];
                    }
                    return YES;
                }
                //从中间删除
                else{
                    NSInteger offset = range.location;
                    
                    if (range.location < text.length && [text characterAtIndex:range.location] == ' ' && [textField.selectedTextRange isEmpty]) {
                        [textField deleteBackward];
                        offset --;
                    }
                    [textField deleteBackward];
                    textField.text = [self parseString:textField.text];
                    UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
                    textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
                    return NO;
                }
            }
            else if (range.length > 1) {
                BOOL isLast = NO;
                //如果是从最后一位开始
                if(range.location + range.length == textField.text.length ){
                    isLast = YES;
                }
                [textField deleteBackward];
                textField.text = [self parseString:textField.text];
                
                NSInteger offset = range.location;
                if (range.location == 3 || range.location  == 8) {
                    offset ++;
                }
                if (isLast) {
                    //光标直接在最后一位了
                }else{
                    UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
                    textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
                }
                
                return NO;
            }
            
            else{
                return YES;
            }
        }
        
        else if(string.length >0){
            
            //限制输入字符个数
            if (([self noneSpaseString:textField.text].length + string.length - range.length > 11) ) {
                return NO;
            }
            //判断是否是纯数字(千杀的搜狗，百度输入法，数字键盘居然可以输入其他字符)
            //            if(![string isNum]){
            //                return NO;
            //            }
            [textField insertText:string];
            textField.text = [self parseString:textField.text];
            
            NSInteger offset = range.location + string.length;
            if (range.location == 3 || range.location  == 8) {
                offset ++;
            }
            UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
            textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
            return NO;
        }else{
            return YES;
        }
    }
    return YES;
}

-(NSString*)noneSpaseString:(NSString*)string
{
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString*)parseString:(NSString*)string
{
    if (!string) {
        return nil;
    }
    NSMutableString* mStr = [NSMutableString stringWithString:[string stringByReplacingOccurrencesOfString:@" " withString:@""]];
    if (mStr.length >3) {
        [mStr insertString:@" " atIndex:3];
    }if (mStr.length > 8) {
        [mStr insertString:@" " atIndex:8];
    }
    return  mStr;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}
@end