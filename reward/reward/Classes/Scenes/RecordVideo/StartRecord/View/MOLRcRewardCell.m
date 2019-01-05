//
//  MOLRcRewardCell.m
//  reward
//
//  Created by apple on 2018/9/25.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLRcRewardCell.h"
#import "MOLGiftCountView.h"
#import "JAPaddingLabel.h"
#import "MOLMineCollectionViewCell.h"
#import "MOLRecordViewController.h"
#import <TYAttributedLabel/TYAttributedLabel.h>
#import "OMGAttributedLabel.h"
#import "RegexKitLite.h"

#import "MOLMineViewController.h"
#import "MOLOtherUserViewController.h"
@interface MOLRcRewardCell ()<TYAttributedLabelDelegate>

@property (nonatomic, weak) UIView *iconBackView;  // 头像边框
@property (nonatomic, weak) UIImageView *iconImageView;  //  头像
@property (nonatomic, weak) UILabel *nameLabel;    // 名字

@property (nonatomic, weak) UIButton *goldButton0;  // 金币
@property (nonatomic, weak) UIButton *goldButton;  // 金币

@property (nonatomic, weak) UIButton *timeDownButton;  // 倒计时
@property (nonatomic, weak) UIButton *checkButton;  // 红包悬赏才有

@property (nonatomic, weak) YYLabel *contentLabel; // 内容

@property (nonatomic, weak) OMGAttributedLabel *AtrContentLabel;//富文本内容
@property (nonatomic, weak) UIView *lineView;
@end

@implementation MOLRcRewardCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupMineRewardCellUI];
        self.backgroundColor = HEX_COLOR(0x0E0F1A);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)setModel:(MOLVideoOutsideModel *)model{
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.rewardVO.userVO.avatar]];
    self.nameLabel.text = model.rewardVO.userVO.userName;
    NSString *amount = [STSystemHelper countNumAndChangeformat:[NSString stringWithFormat:@"%ld ",model.rewardVO.rewardAmount]];
    [self.goldButton setTitle:amount forState:UIControlStateNormal];
    

    NSString *time =  [NSString stringWithFormat:@" %@",model.rewardVO.timeDownTime];
    [self.timeDownButton setTitle:time forState:UIControlStateNormal];
    
    //自己的悬赏自己不能拍摄作品
    if ([model.rewardVO.userVO.userId isEqualToString:[MOLUserManagerInstance user_getUserInfo].userId]) {
        self.checkButton.hidden = YES;
    }else{
        self.checkButton.hidden = NO;
    }
    
    //老的content
    NSMutableAttributedString *str = [self getTextWith:model.rewardVO];
    self.contentLabel.attributedText = str;
    self.contentLabel.height = [str mol_getThreeAttributedTextHeightWithMaxWith:MOL_SCREEN_WIDTH - 30 font:MOL_REGULAR_FONT(15)];

    
    //设置图片类型
    OMGAttributedLabelImageType imageType =OMGAttributedLabelImageType_Common;
    TYTextContainer *container = [_AtrContentLabel textContainerContents:model imageType:imageType];
    [_AtrContentLabel setTextContainer:container];
    CGFloat textH = [[OMGAttributedLabel getAttributedStr:model] mol_getThreeAttributedTextHeightWithMaxWith:MOL_SCREEN_WIDTH - 30 font:MOL_REGULAR_FONT(15)];
    _AtrContentLabel.height = textH;
}

#pragma mark - 按钮点击
- (void)button_clickCheckButton
{
    //友盟统计
    [MobClick event:ST_c_reward_video_button];
    
    if (![MOLUserManagerInstance user_isLogin]) {
        [[MOLGlobalManager shareGlobalManager] global_modalLogin];
        return;
    }
    
    //如果结束了作出提示
    if (self.model.rewardVO.isFinish) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"当前悬赏已经结束是否继续参与？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            if (self.model.rewardVO.isJoiner) {
                [[MOLRecordManager manager] loadMaterialResourcesWith:[NSURL URLWithString:self.model.rewardVO.audioUrl?self.model.rewardVO.audioUrl:@""] WithRewardID:self.model.rewardVO.rewardId.integerValue];
            }else{
                [MOLReleaseManager manager].rewardID = self.model.rewardVO.rewardId.integerValue;//悬赏ID为0 代表自发的作品没有悬赏
                MOLRecordViewController *vc = [[MOLRecordViewController alloc] init];
                [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
            }
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:okAction];
        [alertController addAction:cancleAction];
        
        UIViewController *vc = [CommUtls topViewController];
        [vc presentViewController:alertController animated:YES completion:nil];
        return;
    }

    if (self.model.rewardVO.isJoiner) {
        [[MOLRecordManager manager] loadMaterialResourcesWith:[NSURL URLWithString:self.model.rewardVO.audioUrl?self.model.rewardVO.audioUrl:@""] WithRewardID:self.model.rewardVO.rewardId.integerValue];
    }else{
        [MOLReleaseManager manager].rewardID = self.model.rewardVO.rewardId.integerValue;//悬赏ID为0 代表自发的作品没有悬赏
        MOLRecordViewController *vc = [[MOLRecordViewController alloc] init];
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
    }

}



#pragma mark - UI
- (void)setupMineRewardCellUI
{

    UIView *iconBackView = [[UIView alloc] init];
    _iconBackView = iconBackView;
    iconBackView.backgroundColor = HEX_COLOR(0xffffff);
    [self.contentView addSubview:iconBackView];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    _iconImageView = iconImageView;
    iconImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [iconBackView addSubview:iconImageView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    _nameLabel = nameLabel;
    nameLabel.text = @"加载中...";
    nameLabel.textColor = HEX_COLOR(0xffffff);
    nameLabel.font = MOL_MEDIUM_FONT(15);
    [self.contentView addSubview:nameLabel];
    

    
    UIButton *goldButton0 = [UIButton buttonWithType:UIButtonTypeCustom];
    _goldButton0 = goldButton0;
    goldButton0.userInteractionEnabled = NO;
    [goldButton0 setImage:[UIImage imageNamed:@"mine_money"] forState:UIControlStateNormal];
    [goldButton0 setTitle:@"赏金" forState:UIControlStateNormal];
    [goldButton0 setTitleColor:HEX_COLOR(0xFFEC00) forState:UIControlStateNormal];
    goldButton0.titleLabel.font = MOL_MEDIUM_FONT(13);
    [self.contentView addSubview:goldButton0];
    
    UIButton *goldButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _goldButton = goldButton;
    goldButton.userInteractionEnabled = NO;
    [goldButton setImage:[UIImage imageNamed:@"mine_examine_detail"] forState:UIControlStateNormal];
    [goldButton setTitle:@"0" forState:UIControlStateNormal];
    [goldButton setTitleColor:HEX_COLOR(0xFFEC00) forState:UIControlStateNormal];
    goldButton.titleLabel.font = MOL_REGULAR_FONT(13);
    [self.contentView addSubview:goldButton];
    
    UIButton *timeDownButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _timeDownButton = timeDownButton;
    [timeDownButton setImage:[UIImage imageNamed:@"mine_hourglass"] forState:UIControlStateNormal];
    [timeDownButton setTitle:@"还剩 0天0小时0分" forState:UIControlStateNormal];
    [timeDownButton setTitleColor:HEX_COLOR_ALPHA(0xffffff, 0.3) forState:UIControlStateNormal];
    timeDownButton.titleLabel.font = MOL_REGULAR_FONT(13);
    [self.contentView addSubview:timeDownButton];
    
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _checkButton = checkButton;
    [checkButton setTitleColor:HEX_COLOR(0xFFEC00) forState:UIControlStateNormal];
    [checkButton setImage:[UIImage imageNamed:@"rc_kaipai"] forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(button_clickCheckButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:checkButton];
    
    
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"加载中..."];
//    YYLabel *contentLabel = [[YYLabel alloc] init];
//    _contentLabel = contentLabel;
//    contentLabel.numberOfLines = 0;
//    contentLabel.attributedText = str;
//    contentLabel.height = [str mol_getThreeAttributedTextHeightWithMaxWith:MOL_SCREEN_WIDTH - 30 font:MOL_REGULAR_FONT(15)];
//    [self.contentView addSubview:contentLabel];
    
    OMGAttributedLabel *AtrContentLabel =[OMGAttributedLabel new];
    _AtrContentLabel = AtrContentLabel;
    [AtrContentLabel setBackgroundColor: [UIColor clearColor]];
    [AtrContentLabel setTextColor: HEX_COLOR_ALPHA(0xffffff, 0.9)];
    [AtrContentLabel setFont: MOL_MEDIUM_FONT(15)];
    [AtrContentLabel setNumberOfLines:0];
    AtrContentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    AtrContentLabel.delegate =self;
    AtrContentLabel.height =  [str mol_getThreeAttributedTextHeightWithMaxWith:MOL_SCREEN_WIDTH - 30 font:MOL_REGULAR_FONT(15)];
    [self.contentView addSubview:AtrContentLabel];
    
    
    
    
    UIView *lineView = [[UIView alloc] init];
    _lineView = lineView;
    lineView.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.1);
    [self.contentView addSubview:lineView];
}

- (void)calculatorMineRewardCellFrame
{
    
    self.iconBackView.width = 40;
    self.iconBackView.height = 40;
    self.iconBackView.x = 15;
    self.iconBackView.y = 20; //self.timeLabel.bottom + 10;
    self.iconBackView.layer.cornerRadius = self.iconBackView.height * 0.5;
    self.iconBackView.clipsToBounds = YES;
    
    self.iconImageView.width = 40;
    self.iconImageView.height = 40;
    self.iconImageView.centerX = self.iconBackView.width * 0.5;
    self.iconImageView.centerY = self.iconBackView.height * 0.5;
    self.iconImageView.layer.cornerRadius = self.iconImageView.height * 0.5;
    self.iconImageView.clipsToBounds = YES;
    
    [self.nameLabel sizeToFit];
    if (self.nameLabel.width > self.contentView.width * 0.4) {
        self.nameLabel.width = self.contentView.width * 0.4;
    }
    
    self.nameLabel.x = self.iconBackView.right + 10;
    self.nameLabel.centerY = self.iconBackView.centerY;
    
    [self.goldButton sizeToFit];
    self.goldButton.height = 18;
    self.goldButton.right = self.contentView.width - 15;
    self.goldButton.centerY = self.nameLabel.centerY;
    [self.goldButton mol_setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:2];
    
    [self.goldButton0 sizeToFit];
    self.goldButton0.height = 18;
    self.goldButton0.right = self.goldButton.x - 2;
    self.goldButton0.centerY = self.nameLabel.centerY;
    [self.goldButton0 mol_setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:2];
    

    
    self.contentLabel.width = MOL_SCREEN_WIDTH - 30;
    self.contentLabel.x = self.iconBackView.left;
    self.contentLabel.y = self.iconBackView.bottom + 10;
    
    self.AtrContentLabel.width = MOL_SCREEN_WIDTH - 30;
    self.AtrContentLabel.x = self.iconBackView.left;
    self.AtrContentLabel.y = self.iconBackView.bottom + 10;
    
    
    self.timeDownButton.y = self.AtrContentLabel.bottom + 5;
    self.timeDownButton.x = self.iconBackView.left;
    [self.timeDownButton sizeToFit];
    [self.timeDownButton mol_setButtonImageTitleStyle:ButtonImageTitleStyleDefault padding:0];
    
    
    [self.checkButton sizeToFit];
    self.checkButton.right = self.contentView.width - 15;
    self.checkButton.centerY = self.timeDownButton.centerY;
    [self.checkButton mol_setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:3];

    
    
    self.lineView.width = self.contentView.width - 30;
    self.lineView.height = 1;
    self.lineView.x = 15;
    self.lineView.y = self.contentView.height - 1;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorMineRewardCellFrame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (NSMutableAttributedString *)getTextWith:(MOLExamineCardModel *)model
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:model.content];
    text.yy_color = HEX_COLOR_ALPHA(0xffffff, 0.8);
    text.yy_font = MOL_REGULAR_FONT(15);
    
    UIImage *image;
    if (model.rewardType == 1) {
        //红包悬赏
       image  = [UIImage imageNamed:@"reward_type1"];
    }else{
        //排名悬赏
       image  = [UIImage imageNamed:@"reward_type0"];
    }
    image = [UIImage imageWithCGImage:image.CGImage scale:MOL_SCREEN_SCALE orientation:UIImageOrientationUp];
    
    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:MOL_REGULAR_FONT(15) alignment:YYTextVerticalAlignmentCenter];
     [text insertAttributedString:attachText atIndex:0];
    
    
    //是否合拍
    if (model.isJoiner) {
        UIImage *image2 = [UIImage imageNamed:@"mine_ harmony"];
        image2 = [UIImage imageWithCGImage:image2.CGImage scale:MOL_SCREEN_SCALE orientation:UIImageOrientationUp];
        NSMutableAttributedString *attachText2 = [NSMutableAttributedString yy_attachmentStringWithContent:image2 contentMode:UIViewContentModeCenter attachmentSize:image2.size alignToFont:MOL_REGULAR_FONT(15) alignment:YYTextVerticalAlignmentCenter];
        [text insertAttributedString:[[NSMutableAttributedString alloc] initWithString:@" "] atIndex:1];
        [text insertAttributedString:attachText2 atIndex:2];
        [text insertAttributedString:[[NSMutableAttributedString alloc] initWithString:@" "] atIndex:3];
    }else{
        [text insertAttributedString:[[NSMutableAttributedString alloc] initWithString:@" "] atIndex:1];
    }
    return text;
}


- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)textStorage atPoint:(CGPoint)point{
    if ([textStorage isKindOfClass:[TYLinkTextStorage class]])
    {
        ContentsItemModel *model = ((TYLinkTextStorage*)textStorage).linkData;
        if (model && [model isKindOfClass: [ContentsItemModel class]] && model.type == 2) {
            
            MOLUserModel *userVO =[MOLUserModel new];
            userVO.userId = [NSString stringWithFormat:@"%ld",model.typeId];
            
            if ([[MOLGlobalManager shareGlobalManager] isUserself:userVO]) {
                MOLMineViewController *vc = [[MOLMineViewController alloc] init];
                [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
            }else{
                MOLOtherUserViewController *vc = [[MOLOtherUserViewController alloc] init];
                vc.userId = userVO.userId;
                [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
            }
            
        }
    }
}

@end
