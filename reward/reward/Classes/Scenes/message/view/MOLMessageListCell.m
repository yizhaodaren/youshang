//
//  MOLMessageListCell.m
//  reward
//
//  Created by 刘宏亮 on 2018/9/16.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLMessageListCell.h"
#import "MOLMineViewController.h"
#import "MOLOtherUserViewController.h"

@interface MOLMessageListCell ()
@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UIImageView *tagImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *messageLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UIView *pointView;
@property (nonatomic, weak) UIView *lineView;
@end

@implementation MOLMessageListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupMessageListCellUI];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - 点击头像
- (void)clickIconImageView
{
    MOLUserModel *user = [MOLUserManagerInstance user_getUserInfo];
    
    if ([self.messageListModel.userId isEqualToString:@"0"] ||
        [self.messageListModel.userId isEqualToString:@"00"]) {
        return;
    }
    
    if ([self.messageListModel.userId isEqualToString:user.userId]) {
        MOLMineViewController *vc = [[MOLMineViewController alloc] init];
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
    }else{
        MOLOtherUserViewController *vc = [[MOLOtherUserViewController alloc] init];
        vc.userId = self.messageListModel.userId;
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
    }
}

#pragma mark - 数据
- (void)setMessageListModel:(MOLMessageListModel *)messageListModel
{
    _messageListModel = messageListModel;
    
    if ([messageListModel.image containsString:@"http"] || [messageListModel.image containsString:@"https"]) {
        messageListModel.image = [messageListModel.image stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:messageListModel.image]];
    }else{
        self.iconImageView.image = [UIImage imageNamed:messageListModel.image];
    }
    
    self.nameLabel.text = messageListModel.name;
    
    self.messageLabel.text = messageListModel.messageBody;
    
    self.timeLabel.text = messageListModel.createTime;
    
    self.pointView.hidden = messageListModel.read;
    
    self.tagImageView.hidden = !messageListModel.offic;
}

#pragma mark - UI
- (void)setupMessageListCellUI
{
    UIImageView *iconImageView = [[UIImageView alloc] init];
    _iconImageView = iconImageView;
    iconImageView.image = [UIImage imageNamed:@"message_youshang"];
    iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIconImageView)];
    [iconImageView addGestureRecognizer:tap];
    iconImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:iconImageView];
    
    UIImageView *tagImageView = [[UIImageView alloc] init];
    _tagImageView = tagImageView;
    tagImageView.image = [UIImage imageNamed:@"message_authority"];
    [self.contentView addSubview:tagImageView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    _nameLabel = nameLabel;
    nameLabel.text = @"CC小助手";
    nameLabel.textColor = HEX_COLOR_ALPHA(0xffffff, 1);
    nameLabel.font = MOL_MEDIUM_FONT(15);
    [self.contentView addSubview:nameLabel];
    
    UILabel *messageLabel = [[UILabel alloc] init];
    _messageLabel = messageLabel;
    messageLabel.text = @"系统助手的内容";
    messageLabel.textColor = HEX_COLOR_ALPHA(0xffffff, 0.5);
    messageLabel.font = MOL_REGULAR_FONT(13);
    [self.contentView addSubview:messageLabel];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    _timeLabel = timeLabel;
    timeLabel.text = @"刚刚";
    timeLabel.textColor = HEX_COLOR_ALPHA(0xffffff, 0.5);
    timeLabel.font = MOL_REGULAR_FONT(13);
    [self.contentView addSubview:timeLabel];
    
    UIView *pointView = [[UIView alloc] init];
    _pointView = pointView;
    pointView.backgroundColor = HEX_COLOR(0xFACE15);
    [self.contentView addSubview:pointView];
    
    UIView *lineView = [[UIView alloc] init];
    _lineView = lineView;
    lineView.backgroundColor = HEX_COLOR_ALPHA(0xEDEDED, 0.1);
    [self.contentView addSubview:lineView];
    
}

- (void)calculatorMessageListCellFrame
{
    self.iconImageView.width = 40;
    self.iconImageView.height = 40;
    self.iconImageView.x = 15;
    self.iconImageView.centerY = self.contentView.height * 0.5;
    self.iconImageView.layer.cornerRadius = self.iconImageView.height * 0.5;
    self.iconImageView.clipsToBounds = YES;
    
    self.tagImageView.width = 26;
    self.tagImageView.height = 13;
    self.tagImageView.x = self.iconImageView.centerX - 5;
    self.tagImageView.centerY = self.iconImageView.bottom;
    
    [self.nameLabel sizeToFit];
    if (self.nameLabel.width > self.contentView.width * 0.6) {
        self.nameLabel.width = self.contentView.width * (MOL_SCREEN_WIDTH/375.0f*0.6);
    }
    self.nameLabel.height = 20;
    self.nameLabel.x = self.iconImageView.right + 10;
    self.nameLabel.y = self.iconImageView.y;
    
    self.messageLabel.width = MOL_SCREEN_ADAPTER(255);
    self.messageLabel.height = 18;
    self.messageLabel.x = self.nameLabel.x;
    self.messageLabel.y = self.nameLabel.bottom + 1;
    
    [self.timeLabel sizeToFit];
    self.timeLabel.centerY = self.nameLabel.centerY;
    self.timeLabel.right = self.contentView.width - 15;
    
    self.pointView.width = 8;
    self.pointView.height = 8;
    self.pointView.layer.cornerRadius = self.pointView.height * 0.5;
    self.pointView.clipsToBounds = YES;
    self.pointView.right = self.timeLabel.right;
    self.pointView.centerY = self.messageLabel.centerY;
    
    self.lineView.width = self.contentView.width - 15;
    self.lineView.height = 1;
    self.lineView.x = 15;
    self.lineView.y = self.contentView.height - 1;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorMessageListCellFrame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
