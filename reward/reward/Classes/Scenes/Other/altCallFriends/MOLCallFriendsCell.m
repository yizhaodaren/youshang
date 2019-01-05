//
//  MOLCallFriendsCell.m
//  reward
//
//  Created by apple on 2018/11/7.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLCallFriendsCell.h"

#import "MOLActionRequest.h"

@interface MOLCallFriendsCell ()
@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *introduceLabel;
@property (nonatomic, weak) UIView *lineView;
@end

@implementation MOLCallFriendsCell

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCellUI];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)setUserModel:(MOLMsgUserModel *)userModel
{
    _userModel = userModel;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:userModel.userVO.avatar]];
    
    self.nameLabel.text = userModel.userVO.userName;
    if (self.type) {
        self.introduceLabel.text = [NSString getCommentMessageTimeWithTimestamp:userModel.createTime];
    }else{
        
        self.introduceLabel.text = userModel.userVO.signInfo.length ? userModel.userVO.signInfo : @"本宝宝暂时没有个性签名";
    }
    
    
    [self layoutIfNeeded];
}

#pragma mark - UI
- (void)setupCellUI
{
    UIImageView *iconImageView = [[UIImageView alloc] init];
    _iconImageView = iconImageView;
    iconImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:iconImageView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    _nameLabel = nameLabel;
    nameLabel.text = @"加载中...";
    nameLabel.textColor = HEX_COLOR_ALPHA(0xFFFFFF, 1);
    nameLabel.font = MOL_MEDIUM_FONT(15);
    [self.contentView addSubview:nameLabel];
    
    UILabel *introduceLabel = [[UILabel alloc] init];
    _introduceLabel = introduceLabel;
    introduceLabel.text = @"他暂时没有个性签名";
    introduceLabel.textColor = HEX_COLOR_ALPHA(0xFFFFFF, 0.6);
    introduceLabel.font = MOL_REGULAR_FONT(13);
    [self.contentView addSubview:introduceLabel];
    
//
//    UIView *lineView = [[UIView alloc] init];
//    _lineView = lineView;
//    lineView.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.1);
//    [self.contentView addSubview:lineView];
}

- (void)calculatorUserRelationCellFrame
{
    self.iconImageView.width = 50;
    self.iconImageView.height = 50;
    self.iconImageView.x = 15;
    self.iconImageView.y = 15;
    self.iconImageView.layer.cornerRadius = self.iconImageView.height * 0.5;
    self.iconImageView.clipsToBounds = YES;
    

    
    self.nameLabel.x = self.iconImageView.right + 10;
    self.nameLabel.y = self.iconImageView.y + 8;
    [self.nameLabel sizeToFit];
    if (self.nameLabel.width > MOL_SCREEN_WIDTH- self.nameLabel.x) {
        self.nameLabel.width = MOL_SCREEN_WIDTH - self.nameLabel.x - 10;
    }
    self.nameLabel.height = 20;
//
//    self.subNameLabel.x = self.nameLabel.x;
//    self.subNameLabel.y = self.nameLabel.bottom + 1;
//    self.subNameLabel.width = MOL_SCREEN_WIDTH - self.subNameLabel.x;
//    self.subNameLabel.height = 18;
    
    self.introduceLabel.x = self.nameLabel.x;
    self.introduceLabel.y = self.nameLabel.bottom + 5;
    self.introduceLabel.width = MOL_SCREEN_WIDTH - self.introduceLabel.x - 10;
    self.introduceLabel.height = 18;
    
//
//    self.lineView.x = self.iconImageView.x;
//    self.lineView.y = self.contentView.height - 1;
//    self.lineView.width = self.contentView.width - self.lineView.x;
//    self.lineView.height = 1;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorUserRelationCellFrame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
