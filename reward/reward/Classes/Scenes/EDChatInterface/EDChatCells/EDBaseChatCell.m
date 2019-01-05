//
//  EDBaseChatCell.m
//  aletter
//
//  Created by moli-2017 on 2018/8/24.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "EDBaseChatCell.h"
#import "MOLMineViewController.h"
#import "MOLOtherUserViewController.h"

@interface EDBaseChatCell ()
@property (nonatomic, strong) EDBaseMessageModel *model;
@end

@implementation EDBaseChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupBaseChatCellUI];
    }
    return self;
}

- (void)updateCellWithCellModel:(EDBaseMessageModel *)model{
    _model = model;
    if (model.fromType == MessageFromType_me) {
        
        UIImage *image = [UIImage imageNamed:@"message_bubble_r"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 30, 20, 30) resizingMode:UIImageResizingModeStretch];
        self.bubbleImageView.image = image;
    }else{
        
        UIImage *image = [UIImage imageNamed:@"message_bubble_l"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 30, 20, 30) resizingMode:UIImageResizingModeStretch];
        self.bubbleImageView.image = image;
    }
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.userImage]];
}

#pragma mark - 点击头像
- (void)clickIconImageView
{
    MOLUserModel *user = [MOLUserManagerInstance user_getUserInfo];
    if ([self.model.userId isEqualToString:@"0"] ||
        [self.model.userId isEqualToString:@"00"]) {
        return;
    }
    if ([self.model.userId isEqualToString:user.userId]) {
        MOLMineViewController *vc = [[MOLMineViewController alloc] init];
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
    }else{
        MOLOtherUserViewController *vc = [[MOLOtherUserViewController alloc] init];
        vc.userId = self.model.userId;
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
    }
}

#pragma mark - UI
- (void)setupBaseChatCellUI
{
    UIImageView *iconImageView = [[UIImageView alloc] init];
    _iconImageView = iconImageView;
    iconImageView.layer.cornerRadius = 20;
    iconImageView.clipsToBounds = YES;
    iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIconImageView)];
    [iconImageView addGestureRecognizer:tap];
    [self.contentView addSubview:iconImageView];
    
    UIImageView *bubbleImageView = [[UIImageView alloc] init];
    self.bubbleImageView = bubbleImageView;
    [self.contentView addSubview:bubbleImageView];
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _sendIndicatorView = indicatorView;
    [self.contentView addSubview:indicatorView];
    
}

- (void)calculatorBaseChatCellFrame{}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorBaseChatCellFrame];
}
@end
