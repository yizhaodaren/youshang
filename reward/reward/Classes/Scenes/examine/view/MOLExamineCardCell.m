//
//  MOLExamineCardCell.m
//  reward
//
//  Created by moli-2017 on 2018/9/15.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLExamineCardCell.h"

@interface MOLExamineCardCell ()
@property (nonatomic, weak) UIImageView *iconImageView;
@end

@implementation MOLExamineCardCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupExamineCardCellUI];
    }
    return self;
}

- (void)setImage:(NSString *)image
{
    _image = image;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:image]];
}

#pragma mark - UI
- (void)setupExamineCardCellUI
{
    UIImageView *iconImageView = [[UIImageView alloc] init];
    _iconImageView = iconImageView;
    
    iconImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:iconImageView];
}

- (void)calculatorExamineCardCellFrame
{
    self.iconImageView.width = self.contentView.width;
    self.iconImageView.height = self.contentView.height;
    self.iconImageView.layer.cornerRadius = self.iconImageView.height * 0.5;
    self.iconImageView.clipsToBounds = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorExamineCardCellFrame];
}
@end
