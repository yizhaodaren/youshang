//
//  MOLMyDraftCell.m
//  reward
//
//  Created by moli-2017 on 2018/9/17.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLMyDraftCell.h"

@interface MOLMyDraftCell ()
@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UIImageView *iconBackView;
@property (nonatomic, weak) UIImageView *playImageView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIView *lineView;
@end

@implementation MOLMyDraftCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupMyDraftCellUI];
        self.backgroundColor = [UIColor clearColor];
        
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        
        self.multipleSelectionBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.multipleSelectionBackgroundView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - UI
- (void)setupMyDraftCellUI
{
    UIImageView *iconImageView = [[UIImageView alloc] init];
    _iconImageView = iconImageView;
    iconImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    iconImageView.image = [UIImage imageNamed:@"屏幕快照 2018-09-12 下午3.28.04"];
    [self.contentView addSubview:iconImageView];
    
    UIImageView *iconBackView = [[UIImageView alloc] init];
    _iconBackView = iconBackView;
    iconBackView.backgroundColor = HEX_COLOR_ALPHA(0x000000, 0.2);
    [iconImageView addSubview:iconBackView];
    
    UIImageView *playImageView = [[UIImageView alloc] init];
    _playImageView = playImageView;
    playImageView.image = [UIImage imageNamed:@"mine_draft_play"];
    [iconImageView addSubview:playImageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    titleLabel.text = @"标题为空";
    titleLabel.textColor = HEX_COLOR_ALPHA(0xffffff, 0.6);
    titleLabel.font = MOL_REGULAR_FONT(15);
    titleLabel.numberOfLines = 2;
    [self.contentView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc] init];
    _lineView = lineView;
    lineView.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.1);
    [self.contentView addSubview:lineView];
}

- (void)calculatorMyDraftCellFrame
{
    self.iconImageView.width = 64;
    self.iconImageView.height = 64;
    self.iconImageView.x = 15;
    self.iconImageView.y = 15;
    self.iconImageView.layer.cornerRadius = 2;
    self.iconImageView.clipsToBounds = YES;
    
    self.iconBackView.frame = self.iconImageView.bounds;
    
    self.playImageView.width = 15;
    self.playImageView.height = 18;
    self.playImageView.centerX = self.iconImageView.width * 0.5;
    self.playImageView.centerY = self.iconImageView.height * 0.5;
    
    self.titleLabel.x = self.iconImageView.right + 10;
    self.titleLabel.y = self.iconImageView.y;
    self.titleLabel.width = self.contentView.width - self.titleLabel.x - 10;
    [self.titleLabel sizeToFit];
    self.titleLabel.width = self.contentView.width - self.titleLabel.x - 10;
    
    self.lineView.width = self.contentView.width - 15;
    self.lineView.height = 1;
    self.lineView.x = 15;
    self.lineView.y = self.contentView.height - 1;
}

- (void)layoutSubviews
{
    
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *view in control.subviews)
            {
                if ([view isKindOfClass: [UIImageView class]]) {
                    UIImageView *image=(UIImageView *)view;
                    if (self.selected) {
                        image.image=[UIImage imageNamed:@"mine_round_selected"];
                    }
                    else
                    {
                        image.image=[UIImage imageNamed:@"mine_reward_round"];
                    }
                }
            }
        }
    }
    
    [super layoutSubviews];
    [self calculatorMyDraftCellFrame];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *view in control.subviews)
            {
                if ([view isKindOfClass: [UIImageView class]]) {
                    UIImageView *image=(UIImageView *)view;
                    if (!self.selected) {
                        image.image=[UIImage imageNamed:@"mine_reward_round"];
                    }
                }
            }
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.iconBackView.backgroundColor = HEX_COLOR_ALPHA(0x000000, 0.2);
    self.lineView.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.1);
}

@end
