//
//  MOLYSHelpCell.m
//  reward
//
//  Created by moli-2017 on 2018/10/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLYSHelpCell.h"
#import "MOLYSHelpMessageModel.h"
#import "RewardDetailViewController.h"
#import "MOLWebViewController.h"

@interface MOLYSHelpCell ()
@property (nonatomic, weak) UIButton *attendButton; // 参加
@property (nonatomic, weak) YYLabel *contentLabel;

@property (nonatomic, strong) EDBaseMessageModel *model;
@end

@implementation MOLYSHelpCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupYSHelpCellUI];
    }
    return self;
}

#pragma mark - 按钮点击
- (void)button_attendButton
{
    MOLYSHelpMessageModel *helpM = (MOLYSHelpMessageModel *)self.model;
    if (helpM.type == 1) {
        MOLWebViewController *vc = [[MOLWebViewController alloc] init];
        MOLYSHelpMessageModel *helpM = (MOLYSHelpMessageModel *)self.model;
        vc.urlString = helpM.typeId;
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
    }else{
        RewardDetailViewController *vc = [[RewardDetailViewController alloc] init];
//        MOLYSHelpMessageModel *helpM = (MOLYSHelpMessageModel *)self.model;
        vc.rewardId = helpM.typeId;
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
    }
}

#pragma mark - 赋值
- (void)updateCellWithCellModel:(EDBaseMessageModel *)model
{
    [super updateCellWithCellModel:model];
    _model = model;
    MOLYSHelpMessageModel *helpM = (MOLYSHelpMessageModel *)model;
    
    self.contentLabel.frame = helpM.contentLabelFrame;
    self.attendButton.frame = helpM.attendButtonFrame;
    self.bubbleImageView.frame = model.bubbleImageFrame;
    self.iconImageView.frame = model.iconImageViewFrame;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:helpM.content];
    text.yy_color = HEX_COLOR_ALPHA(0xffffff, 0.5);
    text.yy_font = MOL_REGULAR_FONT(15);
    
    NSRange range = [helpM.content rangeOfString:helpM.content];
    if (helpM.type == 1) {   // H5有点击
        @weakify(self);
        [text yy_setTextHighlightRange:range color:HEX_COLOR_ALPHA(0xffffff, 0.5) backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @strongify(self);
            MOLWebViewController *vc = [[MOLWebViewController alloc] init];
            MOLYSHelpMessageModel *helpM = (MOLYSHelpMessageModel *)self.model;
            vc.urlString = helpM.typeId;
            [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
        }];
    }else{  // 悬赏没有点击
        @weakify(self);
        [text yy_setTextHighlightRange:range color:HEX_COLOR_ALPHA(0xffffff, 0.5) backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @strongify(self);
            RewardDetailViewController *vc = [[RewardDetailViewController alloc] init];
            vc.rewardId = helpM.typeId;
            [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
        }];
    }
    
    if (helpM.type == 1) {
        [self.attendButton setTitle:@"详情" forState:UIControlStateNormal];
    }else if (helpM.type == 2){
        [self.attendButton setTitle:@"参与" forState:UIControlStateNormal];
    }else if (helpM.type == 3){
        [self.attendButton setTitle:@"查看" forState:UIControlStateNormal];
    }
    
    self.contentLabel.attributedText = text;
}

- (void)setupYSHelpCellUI
{
    UIButton *attendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _attendButton = attendButton;
    [attendButton setTitle:@"参与" forState:UIControlStateNormal];
    [attendButton setTitleColor:HEX_COLOR_ALPHA(0x322200, 1) forState:UIControlStateNormal];
    attendButton.titleLabel.font = MOL_REGULAR_FONT(13);
    attendButton.backgroundColor = HEX_COLOR(0xFFEC00);
    attendButton.layer.cornerRadius = 3;
    attendButton.clipsToBounds = YES;
    [attendButton addTarget:self action:@selector(button_attendButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:attendButton];
    
    YYLabel *contentLabel = [[YYLabel alloc] init];
    _contentLabel = contentLabel;
    contentLabel.numberOfLines = 0;
    [self.contentView addSubview:contentLabel];
}

/*
 NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:storyModel.content];
 text.yy_color = HEX_COLOR(0x074D81);
 text.yy_font = MOL_LIGHT_FONT(14);
 if (storyModel.topicVO.topicName.length) {
 NSRange range = [storyModel.content rangeOfString:storyModel.topicVO.topicName];
 [text yy_setColor:HEX_COLOR(0x4A90E2) range:range];
 [text yy_setFont:MOL_MEDIUM_FONT(14) range:range];
 @weakify(self);
 [text yy_setTextHighlightRange:range color:HEX_COLOR(0x4A90E2) backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
 @strongify(self);
 if (self.clickHighText) {
 self.clickHighText(storyModel);
 }
 }];
 }
 self.contentLabel.attributedText = text;
 */
@end
