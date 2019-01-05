//
//  MOLAccountCell.m
//  reward
//
//  Created by moli-2017 on 2018/9/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLAccountCell.h"

@interface MOLAccountCell ()
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *subNameLabel;
@property (nonatomic, weak) UIImageView *arrowImageView;
@end

@implementation MOLAccountCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupAccountCellUI];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setAccountModel:(MOLAccountModel *)accountModel
{
    _accountModel = accountModel;
    self.nameLabel.text = accountModel.name;
    self.subNameLabel.text = accountModel.subName;
    [self.nameLabel sizeToFit];
    [self.subNameLabel sizeToFit];
}

#pragma mark - UI
- (void)setupAccountCellUI
{
    UILabel *nameLabel = [[UILabel alloc] init];
    _nameLabel = nameLabel;
    nameLabel.text = @" ";
    nameLabel.textColor = HEX_COLOR_ALPHA(0xffffff, 1);
    nameLabel.font = MOL_REGULAR_FONT(15);
    [self.contentView addSubview:nameLabel];
    
    UILabel *subNameLabel = [[UILabel alloc] init];
    _subNameLabel = subNameLabel;
    subNameLabel.text = @" ";
    subNameLabel.textColor = HEX_COLOR_ALPHA(0xffffff, 0.6);
    subNameLabel.font = MOL_REGULAR_FONT(15);
    [self.contentView addSubview:subNameLabel];
    
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    _arrowImageView = arrowImageView;
    arrowImageView.image = [UIImage imageNamed:@"withdraw_shape"];
    [self.contentView addSubview:arrowImageView];
}

- (void)calculatorAccountCellFrame
{
    [self.nameLabel sizeToFit];
    self.nameLabel.x = 15;
    self.nameLabel.y = 10;
    
    self.arrowImageView.width = 5;
    self.arrowImageView.height = 9;
    self.arrowImageView.right = self.contentView.width - 15;
    self.arrowImageView.centerY = self.nameLabel.centerY;
    
    [self.subNameLabel sizeToFit];
    self.subNameLabel.centerY = self.nameLabel.centerY;
    self.subNameLabel.right = self.arrowImageView.x - 10;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorAccountCellFrame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
