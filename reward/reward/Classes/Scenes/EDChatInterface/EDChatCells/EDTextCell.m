//
//  EDTextCell.m
//  aletter
//
//  Created by moli-2017 on 2018/8/28.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "EDTextCell.h"
#import "EDTextMessageModel.h"

@interface EDTextCell ()
@property (nonatomic, weak) UILabel *titleLabel;
@end

@implementation EDTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupTextCellUI];
    }
    return self;
}

#pragma mark - 赋值
- (void)updateCellWithCellModel:(EDBaseMessageModel *)model
{
    [super updateCellWithCellModel:model];
    EDTextMessageModel *textM = (EDTextMessageModel *)model;
    self.titleLabel.frame = textM.textLabelFrame;
    self.titleLabel.text = textM.content;
    self.bubbleImageView.frame = model.bubbleImageFrame;
    self.iconImageView.frame = model.iconImageViewFrame;
}

#pragma mark - UI
- (void)setupTextCellUI
{
    UILabel *titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    titleLabel.text = @" ";
    titleLabel.font = MOL_LIGHT_FONT(14);
    titleLabel.backgroundColor = HEX_COLOR(0xffffff);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.numberOfLines = 0;
    [self.bubbleImageView addSubview:titleLabel];
}

- (void)calculatorTextCellFrame{}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorTextCellFrame];
}
@end
