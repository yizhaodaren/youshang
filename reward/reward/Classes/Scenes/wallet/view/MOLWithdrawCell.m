//
//  MOLWithdrawCell.m
//  reward
//
//  Created by moli-2017 on 2018/9/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLWithdrawCell.h"

@interface MOLWithdrawCell ()
@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImageView *arrowImageView;
@property (nonatomic, weak) UIView *lineView;
@end

@implementation MOLWithdrawCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupWithdrawCellUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = HEX_COLOR_ALPHA(0xFFFFFF, 0.05);
    }
    return self;
}

- (void)setDictionary:(NSDictionary *)dictionary
{
    _dictionary = dictionary;
    NSString *image = [dictionary mol_jsonString:@"image"];
    NSString *title = [dictionary mol_jsonString:@"title"];
    self.iconImageView.image = [UIImage imageNamed:image];
    self.titleLabel.text = title;
}

#pragma mark - UI
- (void)setupWithdrawCellUI
{
    UIImageView *iconImageView = [[UIImageView alloc] init];
    _iconImageView = iconImageView;
    [self.contentView addSubview:iconImageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    titleLabel.text = @" ";
    titleLabel.textColor = HEX_COLOR_ALPHA(0xffffff, 1);
    titleLabel.font = MOL_REGULAR_FONT(15);
    [self.contentView addSubview:titleLabel];
    
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    _arrowImageView = arrowImageView;
    arrowImageView.image = [UIImage imageNamed:@"withdraw_shape"];
    [self.contentView addSubview:arrowImageView];
    
    UIView *lineView = [[UIView alloc] init];
    _lineView = lineView;
    lineView.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.1);
    [self.contentView addSubview:lineView];
}

- (void)calculatorWithdrawCellFrame
{
    self.iconImageView.width = 16;
    self.iconImageView.height = 16;
    self.iconImageView.centerY = self.contentView.height * 0.5;
    self.iconImageView.x = 15;
    
    self.titleLabel.width = 150;
    self.titleLabel.height = 22;
    self.titleLabel.x = self.iconImageView.right + 15;
    self.titleLabel.centerY = self.iconImageView.centerY;
    
    self.arrowImageView.width = 5;
    self.arrowImageView.height = 9;
    self.arrowImageView.centerY = self.iconImageView.centerY;
    self.arrowImageView.right = self.contentView.width - 15;
    
    self.lineView.x = 45;
    self.lineView.height = 1;
    self.lineView.width = self.contentView.width - self.lineView.x;
    self.lineView.bottom = self.contentView.height;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorWithdrawCellFrame];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
