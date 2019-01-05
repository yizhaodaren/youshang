//
//  MOLRechargeCell.m
//  reward
//
//  Created by moli-2017 on 2018/9/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLRechargeCell.h"

@interface MOLRechargeCell ()
@property (nonatomic, weak) UIImageView *diamondImageView;
@property (nonatomic, weak) UILabel *diamondLabel;
@property (nonatomic, weak) UIButton *rechargeButton;
@end

@implementation MOLRechargeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupRechargeCellUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = HEX_COLOR_ALPHA(0xFFFFFF, 0.05);
    }
    return self;
}

- (void)setWalletModel:(MOLWalletModel *)walletModel
{
    _walletModel = walletModel;
    self.diamondLabel.text = [NSString stringWithFormat:@"%@",walletModel.diamondAmount];
    [self.rechargeButton setTitle:[NSString stringWithFormat:@"¥%@",walletModel.cnyAmount] forState:UIControlStateNormal];
    [self.rechargeButton sizeToFit];
}

#pragma mark - UI
- (void)setupRechargeCellUI
{
    UIImageView *diamondImageView = [[UIImageView alloc] init];
    _diamondImageView = diamondImageView;
    diamondImageView.image = [UIImage imageNamed:@"withdraw_diamond_small"];
    [self.contentView addSubview:diamondImageView];
    
    UILabel *diamondLabel = [[UILabel alloc] init];
    _diamondLabel = diamondLabel;
    diamondLabel.text = @" ";
    diamondLabel.textColor = HEX_COLOR_ALPHA(0xffffff, 0.6);
    diamondLabel.font = MOL_REGULAR_FONT(16);
    [self.contentView addSubview:diamondLabel];
    
    UIButton *rechargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rechargeButton = rechargeButton;
    rechargeButton.backgroundColor = HEX_COLOR_ALPHA(0xFE6257, 1);
    rechargeButton.titleLabel.font = MOL_MEDIUM_FONT(13);
    [rechargeButton setTitleColor:HEX_COLOR_ALPHA(0xffffff, 1) forState:UIControlStateNormal];
    rechargeButton.layer.cornerRadius = 3;
    rechargeButton.clipsToBounds = YES;
    rechargeButton.userInteractionEnabled = NO;
    [self.contentView addSubview:rechargeButton];
}

- (void)calculatorRechargeCellFrame
{
    self.diamondImageView.width = 18;
    self.diamondImageView.height = 14;
    self.diamondImageView.y = 19;
    self.diamondImageView.x = 15;
    
    self.diamondLabel.width = 150;
    self.diamondLabel.height = 22;
    self.diamondLabel.x = self.diamondImageView.right + 10;
    self.diamondLabel.centerY = self.diamondImageView.centerY;
    
    [self.rechargeButton sizeToFit];
    self.rechargeButton.width += 20;
    self.rechargeButton.height = 26;
    self.rechargeButton.right = self.contentView.width - 15;
    self.rechargeButton.centerY = self.diamondImageView.centerY;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorRechargeCellFrame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
