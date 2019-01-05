//
//  MOLAtUserCell.m
//  reward
//
//  Created by moli-2017 on 2018/11/7.
//  Copyright © 2018 reward. All rights reserved.
//

#import "MOLAtUserCell.h"
#import "MOLMineViewController.h"
#import "MOLOtherUserViewController.h"

@interface MOLAtUserCell ()
@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *subNameLabel; // 内容
@property (nonatomic, weak) UILabel *introduceLabel; // 在xxx提到了你
@property (nonatomic, weak) UIImageView *productionImageView;
@property (nonatomic, weak) UIView *lineView;
@end

@implementation MOLAtUserCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupAtUserCellUI];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setAtModel:(MOLAtUserModel *)atModel
{
    _atModel = atModel;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:atModel.baseUserVO.avatar]];
    self.nameLabel.text = atModel.baseUserVO.userName;
    self.subNameLabel.text = atModel.commentContent;
    self.introduceLabel.text = [NSString stringWithFormat:@"%@ %@",atModel.content,[NSString getCommentMessageTimeWithTimestamp:atModel.createTime]];
    
    [self.productionImageView sd_setImageWithURL:[NSURL URLWithString:atModel.avatar]];
}

#pragma mark - 点击头像
- (void)clickIconImageView
{
    MOLUserModel *user = [MOLUserManagerInstance user_getUserInfo];
    if ([self.atModel.baseUserVO.userId isEqualToString:user.userId]) {
        MOLMineViewController *vc = [[MOLMineViewController alloc] init];
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
    }else{
        MOLOtherUserViewController *vc = [[MOLOtherUserViewController alloc] init];
        vc.userId = self.atModel.baseUserVO.userId;
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
    }
}

#pragma mark - UI
- (void)setupAtUserCellUI
{
    UIImageView *iconImageView = [[UIImageView alloc] init];
    _iconImageView = iconImageView;
    iconImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIconImageView)];
    [iconImageView addGestureRecognizer:tap];
    [self.contentView addSubview:iconImageView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    _nameLabel = nameLabel;
    nameLabel.text = @"加载中...";
    nameLabel.textColor = HEX_COLOR_ALPHA(0xFFFFFF, 1);
    nameLabel.font = MOL_MEDIUM_FONT(15);
    [self.contentView addSubview:nameLabel];
    
    UILabel *subNameLabel = [[UILabel alloc] init];
    _subNameLabel = subNameLabel;
    subNameLabel.text = @"你快来看看这个悬赏！";
    subNameLabel.textColor = HEX_COLOR_ALPHA(0xFFFFFF, 0.6);
    subNameLabel.font = MOL_REGULAR_FONT(13);
    subNameLabel.numberOfLines = 0;
    [self.contentView addSubview:subNameLabel];
    
    UILabel *introduceLabel = [[UILabel alloc] init];
    _introduceLabel = introduceLabel;
    introduceLabel.text = @"在悬赏中提到了你";
    introduceLabel.textColor = HEX_COLOR_ALPHA(0xFFFFFF, 0.6);
    introduceLabel.font = MOL_REGULAR_FONT(13);
    [self.contentView addSubview:introduceLabel];
    
    UIImageView *productionImageView = [[UIImageView alloc] init];
    _productionImageView = productionImageView;
    productionImageView.contentMode = UIViewContentModeScaleAspectFill;
    productionImageView.clipsToBounds = YES;
    productionImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:productionImageView];
    
    UIView *lineView = [[UIView alloc] init];
    _lineView = lineView;
    lineView.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.1);
    [self.contentView addSubview:lineView];
}

- (void)calculatorAtUserCellFrame
{
    self.iconImageView.width = 40;
    self.iconImageView.height = 40;
    self.iconImageView.x = 15;
    self.iconImageView.y = 15;
    self.iconImageView.layer.cornerRadius = self.iconImageView.height * 0.5;
    self.iconImageView.clipsToBounds = YES;
    
    self.productionImageView.width = 50;
    self.productionImageView.height = 50;
    self.productionImageView.layer.cornerRadius = 3;
    self.productionImageView.clipsToBounds = YES;
    self.productionImageView.right = self.contentView.width - 15;
    self.productionImageView.y = 15;
    
    self.nameLabel.x = self.iconImageView.right + 10;
    self.nameLabel.y = self.iconImageView.y;
    [self.nameLabel sizeToFit];
    if (self.nameLabel.width > self.productionImageView.x - self.nameLabel.x) {
        self.nameLabel.width = self.productionImageView.x - self.nameLabel.x;
    }
    self.nameLabel.height = 20;
    
    self.subNameLabel.x = self.nameLabel.x;
    self.subNameLabel.y = self.nameLabel.bottom + 1;
    self.subNameLabel.width = self.productionImageView.x - self.subNameLabel.x;
    self.subNameLabel.height = 18;
    
    self.introduceLabel.x = self.nameLabel.x;
    self.introduceLabel.y = self.subNameLabel.bottom + 1;
    self.introduceLabel.width = self.subNameLabel.width;
    self.introduceLabel.height = 18;
    
    self.lineView.x = self.iconImageView.x;
    self.lineView.y = self.contentView.height - 1;
    self.lineView.width = self.contentView.width - self.lineView.x;
    self.lineView.height = 1;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorAtUserCellFrame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
