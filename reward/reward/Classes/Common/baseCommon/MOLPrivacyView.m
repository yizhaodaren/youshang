//
//  MOLPrivacyView.m
//  reward
//
//  Created by moli-2017 on 2018/10/27.
//  Copyright © 2018 reward. All rights reserved.
//

#import "MOLPrivacyView.h"
#import "MOLWebViewController.h"
#import "MOLHostHead.h"

@interface MOLPrivacyView ()

@property (nonatomic, weak) UIView *backView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *privacyLabel;
@property (nonatomic, weak) YYLabel *allPrivacyLabel;
@property (nonatomic, weak) UIButton *agreeButton;
@property (nonatomic, weak) UIButton *agreeButton_no;
@end

@implementation MOLPrivacyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupPrivacyViewUI];
    }
    return self;
}

+ (void)privacy_show
{
    BOOL pri = [[NSUserDefaults standardUserDefaults] boolForKey:@"MOL_Privacy"];
    
    if (!pri) {
        
        MOLPrivacyView *v = [[MOLPrivacyView alloc] init];
        v.width = MOL_SCREEN_WIDTH;
        v.height = MOL_SCREEN_HEIGHT;
        [MOLAppDelegateWindow addSubview:v];
    }
}

#pragma mark - 按钮点击
- (void)button_clickagreeButton_no
{
    exit(0);
}

- (void)button_clickagreeButton
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MOL_Privacy"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self removeFromSuperview];
}

#pragma mark - UI
- (void)setupPrivacyViewUI
{
    self.backgroundColor = HEX_COLOR_ALPHA(0x111519, 0.8);
    
    UIView *backView = [[UIView alloc] init];
    _backView = backView;
    backView.backgroundColor = HEX_COLOR_ALPHA(0xEDEDF7, 1);
    backView.layer.cornerRadius = 3;
    backView.clipsToBounds = YES;
    [self addSubview:backView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    titleLabel.text = @"用户隐私政策概要";
    titleLabel.font = MOL_MEDIUM_FONT(17);
    titleLabel.textColor = HEX_COLOR_ALPHA(0x262835, 1);
    [backView addSubview:titleLabel];
    
    UILabel *privacyLabel = [[UILabel alloc] init];
    _privacyLabel = privacyLabel;
    privacyLabel.numberOfLines = 0;
    privacyLabel.text = @"“CC”隐私政策\n更新日期：2018年9月29日\n生效日期：2018年9月29日\n本隐私政策将帮助你了解：\n（1）为了保障产品的正常运行，实现个性化音视频推荐、网络直播、发布信息、互动交流、搜索查询等核心功能以及其他功能，我们会收集你的部分必要信息；\n（2）在你进行发布信息、互动交流、注册认证或使用基于地理位置的服务时，基于法律要求或实现功能所必须，我们可能会收集姓名、联络方式、通讯录、音视频文件、地理位置等个人敏感信息。你有权拒绝向我们提供这些信息，或者撤回你对这些信息的授权同意。请你了解，拒绝或撤回授权同意，将导致你无法使用相关的特定功能，但不影响你使用“CC”的其他功能；";
    privacyLabel.font = MOL_REGULAR_FONT(13);
    privacyLabel.textColor = HEX_COLOR_ALPHA(0x666875, 1);
    [backView addSubview:privacyLabel];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"你可以查看完整版"];
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"隐私政策"];
    text.yy_font = MOL_MEDIUM_FONT(14);
    text.yy_color = HEX_COLOR(0x666875);
    one.yy_font = MOL_MEDIUM_FONT(14);
    one.yy_color = HEX_COLOR(0xFE6257 );
//    one.yy_underlineStyle = NSUnderlineStyleSingle;
    @weakify(self);
    [one yy_setTextHighlightRange:one.yy_rangeOfAll
                            color:HEX_COLOR(0xF4C054)
                  backgroundColor:[UIColor clearColor]
                        tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                            @strongify(self);
                            
                            [self removeFromSuperview];
                            
                            MOLWebViewController *vc  = [[MOLWebViewController alloc] init];
                            NSString *offic = MOL_OFFIC_SERVICE_H5;  // 正式
#ifdef MOL_TEST_HOST
                            offic = MOL_TEST_SERVICE;  // 测试
#endif
                            vc.urlString = [NSString stringWithFormat:@"%@/static/views/app/about/privacyPolicy.html",offic];
                            vc.titleString = @"隐私政策";
                            [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
                        }];
    [text appendAttributedString:one];
    YYLabel *allPrivacyLabel = [[YYLabel alloc] init];
    _allPrivacyLabel = allPrivacyLabel;
    allPrivacyLabel.width = 200;
    allPrivacyLabel.height = 20;
    allPrivacyLabel.attributedText = text;
    allPrivacyLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:allPrivacyLabel];
    
    UIButton *agreeButton_no = [UIButton buttonWithType:UIButtonTypeCustom];
    _agreeButton_no = agreeButton_no;
    [agreeButton_no setTitle:@"不同意" forState:UIControlStateNormal];
    [agreeButton_no setTitleColor:HEX_COLOR_ALPHA(0x666875, 1) forState:UIControlStateNormal];
    agreeButton_no.titleLabel.font = MOL_MEDIUM_FONT(17);
    agreeButton_no.backgroundColor = HEX_COLOR_ALPHA(0xE6E8F5, 1);
    [agreeButton_no addTarget:self action:@selector(button_clickagreeButton_no) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:agreeButton_no];
    
    UIButton *agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _agreeButton = agreeButton;
    [agreeButton setTitle:@"同意" forState:UIControlStateNormal];
    [agreeButton setTitleColor:HEX_COLOR_ALPHA(0x262835, 1) forState:UIControlStateNormal];
    agreeButton.titleLabel.font = MOL_MEDIUM_FONT(17);
    agreeButton.backgroundColor = HEX_COLOR_ALPHA(0xD9DBEA, 1);
    [agreeButton addTarget:self action:@selector(button_clickagreeButton) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:agreeButton];
}

- (void)calculatorPrivacyViewFrame
{
    self.backView.width = 270;
    self.backView.height = 370;
    self.backView.centerX = self.width * 0.5;
    self.backView.centerY = self.height * 0.5;
    
    [self.titleLabel sizeToFit];
    self.titleLabel.height = 25;
    self.titleLabel.centerX = self.backView.width * 0.5;
    self.titleLabel.y = 25;
    
    self.privacyLabel.width = 230;
    self.privacyLabel.height = 220;
    self.privacyLabel.centerX = self.titleLabel.centerX;
    self.privacyLabel.y = self.titleLabel.bottom + 5;
    
    self.allPrivacyLabel.centerX = self.titleLabel.centerX;
    self.allPrivacyLabel.y = self.privacyLabel.bottom + 10;
    
    self.agreeButton_no.width = 135;
    self.agreeButton_no.height = 55;
    self.agreeButton_no.bottom = self.backView.height;
    
    self.agreeButton.width = 135;
    self.agreeButton.height = 55;
    self.agreeButton.bottom = self.backView.height;
    self.agreeButton.x = self.agreeButton_no.right;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self calculatorPrivacyViewFrame];
}
@end
