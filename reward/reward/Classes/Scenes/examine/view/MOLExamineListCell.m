//
//  MOLExamineListCell.m
//  reward
//
//  Created by 刘宏亮 on 2018/9/16.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLExamineListCell.h"
#import "JAPaddingLabel.h"
#import "MOLExamineCardView.h"

@interface MOLExamineListCell ()

@property (nonatomic, weak) JAPaddingLabel *timeLabel;
@property (nonatomic, weak) MOLExamineCardView *cardView;
@end

@implementation MOLExamineListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupExamineListCellUI];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setCardModel:(MOLExamineCardModel *)cardModel
{
    _cardModel = cardModel;
    
    self.timeLabel.text = [NSString moli_timeGetMessageTimeWithTimestamp:cardModel.createTime];
    
    self.cardView.cardModel = cardModel;
    self.cardView.height = cardModel.cardHeight_check;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark -  UI
- (void)setupExamineListCellUI
{
    JAPaddingLabel *timeLabel = [[JAPaddingLabel alloc] init];
    _timeLabel = timeLabel;
    timeLabel.text = @"刚刚";
    timeLabel.textColor = HEX_COLOR_ALPHA(0xffffff, 0.6);
    timeLabel.font = MOL_REGULAR_FONT(11);
    timeLabel.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.1);
    timeLabel.layer.cornerRadius = 3;
    timeLabel.clipsToBounds = YES;
    [self.contentView addSubview:timeLabel];
    
    MOLExamineCardView *cardView = [[MOLExamineCardView alloc] init];
    _cardView = cardView;
    cardView.backgroundColor = HEX_COLOR_ALPHA(0x3B3C45, 0.8);
    cardView.cardViewType = MOLExamineCardViewType_normal;
    cardView.layer.cornerRadius = 5;
    cardView.clipsToBounds = YES;
    [self.contentView addSubview:cardView];
}

- (void)calculatorExamineListCellFrame
{
    [self.timeLabel sizeToFit];
    self.timeLabel.height = 20;
    self.timeLabel.edgeInsets = UIEdgeInsetsMake(2, 10, 2, 10);
    self.timeLabel.centerX = self.contentView.width * 0.5;
    self.timeLabel.y = 20;
    
    self.cardView.width = MOL_SCREEN_ADAPTER(345);
    self.cardView.y = self.timeLabel.bottom + 15;
    self.cardView.centerX = self.contentView.width * 0.5;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorExamineListCellFrame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
