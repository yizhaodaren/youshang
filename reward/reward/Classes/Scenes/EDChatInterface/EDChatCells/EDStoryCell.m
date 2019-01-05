//
//  EDStoryCell.m
//  aletter
//
//  Created by moli-2017 on 2018/8/28.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "EDStoryCell.h"
#import "MOLExamineCardView.h"
#import "EDStoryMessageModel.h"

@interface EDStoryCell ()

@property (nonatomic, weak) UILabel *label;
@property (nonatomic, weak) UIButton *attendButton; // 参加
@property (nonatomic, weak) MOLExamineCardView *cardView;

@end

@implementation EDStoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupStoryCellUI];
    }
    return self;
}

#pragma mark - 赋值
- (void)updateCellWithCellModel:(EDBaseMessageModel *)model
{
    [super updateCellWithCellModel:model];
    
    EDStoryMessageModel *storyM = (EDStoryMessageModel *)model;
    self.attendButton.frame = storyM.attendButtonFrame;
    self.cardView.frame = storyM.cardViewFrame;
    self.bubbleImageView.frame = model.bubbleImageFrame;
    self.iconImageView.frame = model.iconImageViewFrame;
    self.label.frame = storyM.labelFrame;
    
    MOLExamineCardModel *cardM = [[MOLExamineCardModel alloc] init];
    MOLUserModel *userVO = [[MOLUserModel alloc] init];
    userVO.userName = storyM.rewardUserName;
    userVO.userId = storyM.rewardUserId;
    userVO.avatar = storyM.rewardUserAvatar;
    cardM.userVO = userVO;
    
    cardM.content = storyM.storyContent;
    
    self.cardView.cardModel = cardM;
    self.cardView.height = cardM.cardHeight_noBottom;
}

- (void)setupStoryCellUI
{
    UIButton *attendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _attendButton = attendButton;
    [attendButton setTitle:@"参加" forState:UIControlStateNormal];
    [attendButton setTitleColor:HEX_COLOR_ALPHA(0x322200, 1) forState:UIControlStateNormal];
    attendButton.titleLabel.font = MOL_REGULAR_FONT(13);
    attendButton.backgroundColor = HEX_COLOR(0xFFEC00);
    attendButton.layer.cornerRadius = 3;
    attendButton.clipsToBounds = YES;
    [self.contentView addSubview:attendButton];
    
    MOLExamineCardView *cardView = [[MOLExamineCardView alloc] init];
    _cardView = cardView;
    cardView.backgroundColor = HEX_COLOR_ALPHA(0x3B3C45, 0.8);
    cardView.cardViewType = MOLExamineCardViewType_noProduction;
    cardView.layer.cornerRadius = 5;
    cardView.clipsToBounds = YES;
    [self.contentView addSubview:cardView];
}

- (void)calculatorStoryCellFrame{}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorStoryCellFrame];
}
@end
