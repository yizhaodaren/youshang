//
//  MOLUpdateView.m
//  aletter
//
//  Created by moli-2017 on 2018/9/1.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "MOLUpdateView.h"

@interface MOLUpdateView ()
@property (nonatomic, weak) UIButton *closeButton;
@property (nonatomic, weak) UIView *backView;
@property (nonatomic, weak) UIImageView *topImageView;
@property (nonatomic, weak) UILabel *label1;  // 发现新版本
@property (nonatomic, weak) UILabel *versionLabel;  // 新版本
@property (nonatomic, weak) UILabel *label2;  // 是否升级到最新版本？
@property (nonatomic, weak) UITextView *textView; // 版本更新介绍
@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, weak) UIButton *updateButton;  // 安装

@end

@implementation MOLUpdateView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUpdateViewUI];
        self.backgroundColor = HEX_COLOR_ALPHA(0x000000, 0.3);
    }
    return self;
}

- (void)showUpdateWithVersion:(NSString *)version content:(NSString *)content force:(BOOL)force
{
    self.versionLabel.text = version;
    [self.versionLabel sizeToFit];
    self.textView.text = content;
    
    if (force) {
        self.closeButton.hidden = YES;
    }else{
        self.closeButton.hidden = NO;
    }
}

#pragma mark - 按钮的点击
- (void)button_clickCloseButton
{
    [self removeFromSuperview];
}

- (void)button_clickUpdateButton
{
    //跳转到appStore
    NSString *appid = @"1437093946";
    NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@",appid];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

#pragma mark - UI
- (void)setupUpdateViewUI
{
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton = closeButton;
    [closeButton setImage:[UIImage imageNamed:@"update_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(button_clickCloseButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    
    UIView *backView = [[UIView alloc] init];
    _backView = backView;
    backView.backgroundColor = HEX_COLOR(0xffffff);
    backView.layer.cornerRadius = 10;
    backView.clipsToBounds = YES;
    [self addSubview:backView];
    
    UIImageView *topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"update_back"]];
    _topImageView = topImageView;
    [backView addSubview:topImageView];
    
    UILabel *label1 = [[UILabel alloc] init];
    _label1 = label1;
    label1.text = @"发现新版本";
    label1.textColor = HEX_COLOR(0xffffff);
    label1.font = MOL_MEDIUM_FONT(20);
    [backView addSubview:label1];
    
    UILabel *versionLabel = [[UILabel alloc] init];
    _versionLabel = versionLabel;
    versionLabel.text = @" ";
    versionLabel.textColor = HEX_COLOR(0xffffff);
    versionLabel.font = MOL_MEDIUM_FONT(14);
    [backView addSubview:versionLabel];
    
    UILabel *label2 = [[UILabel alloc] init];
    _label2 = label2;
    label2.text = @"是否升级到最新版本？";
    label2.textColor = HEX_COLOR(0x444444);
    label2.font = MOL_MEDIUM_FONT(14);
    [backView addSubview:label2];
    
    UITextView *textView = [[UITextView alloc] init];
    _textView = textView;
    textView.text = @"- 新增音频专辑，优化故事分类\n- 新增动态页，全网动态实时更新\n- 故事新增播放列表，收听更尽兴\n- 修复已知bug";
    textView.textColor = HEX_COLOR(0x444444);
    textView.font = MOL_REGULAR_FONT(14);
    textView.editable = NO;
    [backView addSubview:textView];
    
    UIView *lineView = [[UIView alloc] init];
    _lineView = lineView;
    lineView.backgroundColor = HEX_COLOR(0xFAFAFA);
    [backView addSubview:lineView];
    
    UIButton *updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _updateButton = updateButton;
    [updateButton setTitle:@"安装" forState:UIControlStateNormal];
    [updateButton setTitleColor:HEX_COLOR(0x4A4A4A) forState:UIControlStateNormal];
    updateButton.titleLabel.font = MOL_MEDIUM_FONT(18);
    [updateButton addTarget:self action:@selector(button_clickUpdateButton) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:updateButton];
}

- (void)calculatorUpdateViewFrame
{
    self.backView.width = 300;
    self.backView.height = 400;
    self.backView.centerX = self.width * 0.5;
    self.backView.centerY = self.height * 0.5;
    
    self.closeButton.width = 30;
    self.closeButton.height = 62;
    self.closeButton.bottom = self.backView.y;
    self.closeButton.right = self.backView.right;
    
    self.topImageView.width = 300;
    self.topImageView.height = 134;
    
    [self.label1 sizeToFit];
    self.label1.x = 15;
    self.label1.y = 40;
    
    [self.versionLabel sizeToFit];
    self.versionLabel.x = self.label1.x;
    self.versionLabel.y = self.label1.bottom + 2;
    
    [self.label2 sizeToFit];
    self.label2.x = 18;
    self.label2.y = self.topImageView.bottom + 6;
    
    self.textView.width = self.backView.width  -36;
    self.textView.x = 18;
    self.textView.height = 120;
    self.textView.y = self.label2.bottom + 25;
    
    self.lineView.width = self.backView.width;
    self.lineView.height = 1;
    self.lineView.y = self.backView.height - 51;
    
    self.updateButton.width = self.backView.width;
    self.updateButton.height = 50;
    self.updateButton.y = self.lineView.bottom;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorUpdateViewFrame];
}
@end
