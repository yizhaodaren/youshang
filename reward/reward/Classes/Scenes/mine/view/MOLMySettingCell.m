//
//  MOLMySettingCell.m
//  reward
//
//  Created by moli-2017 on 2018/9/13.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLMySettingCell.h"

@interface MOLMySettingCell ()
@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UIImageView *arrowImageView;
@property (nonatomic, weak) UILabel *subNameLabel;
@end

@implementation MOLMySettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupMySettingCellUI];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSettingDic:(NSDictionary *)settingDic
{
    _settingDic = settingDic;
    NSString *image = [settingDic mol_jsonString:@"image"];
    NSString *name = [settingDic mol_jsonString:@"name"];
    NSString *subName = [settingDic mol_jsonString:@"subName"];
    NSString *arrow = [settingDic mol_jsonString:@"arrow"];
    
    self.iconImageView.image = [UIImage imageNamed:image];
    self.nameLabel.text = name;
    if (subName.length) {
        self.subNameLabel.hidden = NO;
        self.arrowImageView.hidden = YES;
        self.subNameLabel.text = subName;
    }else if (arrow.length){
        self.subNameLabel.hidden = YES;
        self.arrowImageView.hidden = NO;
        self.arrowImageView.image = [UIImage imageNamed:arrow];
    }else{
        self.subNameLabel.hidden = YES;
        self.arrowImageView.hidden = YES;
    }
}

#pragma mark - UI
- (void)setupMySettingCellUI
{
    UIImageView *iconImageView = [[UIImageView alloc] init];
    _iconImageView = iconImageView;
    [self.contentView addSubview:iconImageView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    _nameLabel = nameLabel;
    nameLabel.text = @" ";
    nameLabel.textColor = HEX_COLOR(0xffffff);
    nameLabel.font = MOL_REGULAR_FONT(15);
    [self.contentView addSubview:nameLabel];
    
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    _arrowImageView = arrowImageView;
    arrowImageView.hidden = YES;
    [self.contentView addSubview:arrowImageView];
    
    UILabel *subNameLabel = [[UILabel alloc] init];
    _subNameLabel = subNameLabel;
    subNameLabel.hidden = YES;
    subNameLabel.text = @" ";
    subNameLabel.textColor = HEX_COLOR_ALPHA(0xffffff, 0.6);
    subNameLabel.font = MOL_REGULAR_FONT(13);
    [self.contentView addSubview:subNameLabel];
}

- (void)calculatorMySettingCellFrame
{
    self.iconImageView.width = 16;
    self.iconImageView.height = 16;
    self.iconImageView.x = 15;
    self.iconImageView.y = 10;
    
    [self.nameLabel sizeToFit];
    self.nameLabel.height = 20;
    self.nameLabel.x = 45;
    self.nameLabel.centerY = self.iconImageView.centerY;
    
    self.arrowImageView.width = 5;
    self.arrowImageView.height = 9;
    self.arrowImageView.right = self.contentView.width - 15;
    self.arrowImageView.centerY = self.iconImageView.centerY;
    
    [self.subNameLabel sizeToFit];
    self.subNameLabel.centerY = self.iconImageView.centerY;
    self.subNameLabel.right = self.arrowImageView.right;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorMySettingCellFrame];
}
@end
