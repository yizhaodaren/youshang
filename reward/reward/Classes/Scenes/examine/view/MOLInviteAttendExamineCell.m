//
//  MOLInviteAttendExamineCell.m
//  reward
//
//  Created by moli-2017 on 2018/9/15.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLInviteAttendExamineCell.h"
#import "MOLExamineCardView.h"

@interface MOLInviteAttendExamineCell ()
@property (nonatomic, weak) MOLExamineCardView *cardView;
@property (nonatomic, weak) UIButton *chooseButton;
@end

@implementation MOLInviteAttendExamineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupInviteAttendExamineCellUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setCardModel:(MOLExamineCardModel *)cardModel
{
    _cardModel = cardModel;
    self.cardView.cardModel = cardModel;
    self.cardView.height = cardModel.cardHeight_noBottom;
    self.chooseButton.selected = cardModel.selectSend;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - UI
- (void)setupInviteAttendExamineCellUI
{
    UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _chooseButton = chooseButton;
    chooseButton.userInteractionEnabled = NO;
    [chooseButton setImage:[UIImage imageNamed:@"mine_reward_round"] forState:UIControlStateNormal];
    [chooseButton setImage:[UIImage imageNamed:@"mine_round_selected"] forState:UIControlStateSelected];
    [self.contentView addSubview:chooseButton];
    
    MOLExamineCardView *cardView = [[MOLExamineCardView alloc] init];
    _cardView = cardView;
    cardView.backgroundColor = HEX_COLOR_ALPHA(0x3B3C45, 0.8);
    cardView.cardViewType = MOLExamineCardViewType_noProduction;
    cardView.layer.cornerRadius = 5;
    cardView.clipsToBounds = YES;
    [self.contentView addSubview:cardView];
}

- (void)calculatorInviteAttendExamineCellFrame
{
    self.chooseButton.width = MOL_SCREEN_ADAPTER(22);
    self.chooseButton.height = MOL_SCREEN_ADAPTER(22);
    self.chooseButton.x = MOL_SCREEN_ADAPTER(15);
    self.chooseButton.centerY = self.contentView.height * 0.5 - 5;
    
    self.cardView.width = MOL_SCREEN_ADAPTER(300);
    self.cardView.x = self.chooseButton.right + MOL_SCREEN_ADAPTER(15);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorInviteAttendExamineCellFrame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
