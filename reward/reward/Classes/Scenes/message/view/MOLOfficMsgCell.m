//
//  MOLOfficMsgCell.m
//  reward
//
//  Created by moli-2017 on 2018/9/21.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLOfficMsgCell.h"

@interface MOLOfficMsgCell ()

@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UIImageView *tagImageView;

@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *messageLabel;

@property (nonatomic, weak) UIButton *attendButton;  // 参加按钮

@property (nonatomic, weak) UILabel *timeLabel;
@end

@implementation MOLOfficMsgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupOfficMsgCell];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setOfficModel:(MOLOfficMsgModel *)officModel
{
    _officModel = officModel;
    self.iconImageView.image = [UIImage imageNamed:officModel.image];
    self.nameLabel.text = officModel.name;
    self.messageLabel.text = officModel.messageBody;
    self.timeLabel.text = officModel.createTime;
    
    if (officModel.type == 0) {
        self.attendButton.hidden = YES;
    }else{
        self.attendButton.hidden = NO;
    }
    
    [self layoutIfNeeded];
}

#pragma mark - UI
- (void)setupOfficMsgCell
{
    UIImageView *iconImageView = [[UIImageView alloc] init];
    _iconImageView = iconImageView;
    iconImageView.image = [UIImage imageNamed:@"message_youshang"];
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
    messageLabel.font = MOL_REGULAR_FONT(15);
    messageLabel.numberOfLines = 0;
    [self.contentView addSubview:messageLabel];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    _timeLabel = timeLabel;
    timeLabel.text = @"刚刚";
    timeLabel.textColor = HEX_COLOR_ALPHA(0xffffff, 0.5);
    timeLabel.font = MOL_REGULAR_FONT(13);
    [self.contentView addSubview:timeLabel];
    
    UIButton *attendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _attendButton = attendButton;
    [attendButton setTitle:@"参加" forState:UIControlStateNormal];
    [attendButton setTitleColor:HEX_COLOR_ALPHA(0x000000, 1) forState:UIControlStateNormal];
    attendButton.titleLabel.font = MOL_REGULAR_FONT(13);
    attendButton.backgroundColor = HEX_COLOR_ALPHA(0xFFEC00, 1);
    attendButton.layer.cornerRadius = 3;
    attendButton.clipsToBounds = YES;
    [self.contentView addSubview:attendButton];
}

- (void)calculatorOfficMsgCellFrame
{
    self.iconImageView.width = 40;
    self.iconImageView.height = 40;
    self.iconImageView.x = 15;
    self.iconImageView.y = 15;
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
    
    self.attendButton.width = 60;
    self.attendButton.height = 28;
    self.attendButton.y = self.iconImageView.y;
    self.attendButton.right = self.contentView.width - 15;
    
    self.messageLabel.x = self.nameLabel.x; // 65
    CGFloat w = self.attendButton.hidden ? 15 : 85;
    self.messageLabel.width = self.contentView.width - 65 - w;
    [self.messageLabel sizeToFit];
    self.messageLabel.width = self.contentView.width - 65 - w;
    self.messageLabel.y = self.nameLabel.bottom + 2;
    
    [self.timeLabel sizeToFit];
    self.timeLabel.y = self.messageLabel.bottom + 5;
    self.timeLabel.x = self.nameLabel.x;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorOfficMsgCellFrame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
