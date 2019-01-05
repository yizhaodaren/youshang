//
//  HomePublisherView.m
//  reward
//
//  Created by xujin on 2018/9/13.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "HomePublisherView.h"
#import "MOLVideoOutsideModel.h"
#import "MOLVideoModel.h"
#import "MOLExamineCardModel.h"
#import "OMGAttributedLabel.h"
#import "MOLMineViewController.h"
#import "MOLOtherUserViewController.h"
@interface HomePublisherView()<TYAttributedLabelDelegate>
@property (nonatomic,strong)MOLVideoOutsideModel *currentModel;
@property (nonatomic,assign)CGRect rect;
@property (nonatomic,weak)UILabel *praiseLable;
@property (nonatomic, strong) MOLVideoModel *storyVO;  //作品模型
@property (nonatomic, strong) MOLExamineCardModel *rewardVO; //悬赏模型



@end

@implementation HomePublisherView
- (void)initData{
    self.currentModel =[MOLVideoOutsideModel new];
    self.storyVO =[MOLVideoModel new];
    self.rewardVO =[MOLExamineCardModel new];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.rect =frame;
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.rect =frame;
    [self initData];
}

- (void)content:(MOLVideoOutsideModel *)model{
    
    if (!model) {
        return;
    }
    

    UIImageView *avatars =[UIImageView new];
    [avatars.layer setMasksToBounds:YES];
    [avatars sd_setImageWithURL:[NSURL URLWithString:model.storyVO.rewardVO.avatar?model.storyVO.rewardVO.avatar:@""] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed];
    avatars.layer.borderColor =[UIColor whiteColor].CGColor;
    [avatars.layer setBorderWidth:1.0];
    [self addSubview:avatars];
    
    UILabel *titleLable =[UILabel new];
    [titleLable setText: @"发布赏金"];
    [titleLable setFont: MOL_MEDIUM_FONT(12)];
    [titleLable setTextColor:HEX_COLOR_ALPHA(0xFFEC00,1)];
    [self addSubview:titleLable];
    
    UIImageView *dollar =[UIImageView new];
    [dollar setImage: [UIImage imageNamed:@"mine_money"]];
    [self addSubview:dollar];
    
    UILabel *moneyLable =[UILabel new];
    [moneyLable setText: [STSystemHelper countNumAndChangeformat:[NSString stringWithFormat:@"%ld",model.storyVO.rewardVO.rewardAmount]]];
    [moneyLable setTextColor:HEX_COLOR_ALPHA(0xFFEC00,1)];
    [moneyLable setFont:MOL_MEDIUM_FONT(12)];
    [moneyLable setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:moneyLable];
    
    

    NSString *questionStr =@"";
    questionStr =model.storyVO.rewardVO.content?model.storyVO.rewardVO.content:@"";
    
    NSMutableAttributedString *questionAttStr = [STSystemHelper attributedContent:[NSString stringWithFormat:@"%@%@", model.storyVO.rewardVO.isJoiner?@" ":@"",questionStr] color:HEX_COLOR_ALPHA(0xffffff, 1) font:MOL_MEDIUM_FONT(13)];
    
    if (model.storyVO.rewardVO.isJoiner) {//是合拍
        YYAnimatedImageView *questionImage= [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"InTune"]];
        questionImage.frame = CGRectMake(0, 0, 19, 18);
        
        NSMutableAttributedString *attachQuestion =[NSMutableAttributedString yy_attachmentStringWithContent:questionImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:questionImage.size alignToFont:MOL_MEDIUM_FONT(13) alignment:YYTextVerticalAlignmentCenter];
        
        [questionAttStr insertAttributedString:attachQuestion atIndex:0];
    }
    
    
    OMGAttributedLabel *describeL=[OMGAttributedLabel new];
    [describeL setBackgroundColor: [UIColor clearColor]];
   
    [describeL setTextColor:HEX_COLOR(0xffffff)];
    [describeL setFont:MOL_MEDIUM_FONT(13)];
   
    [describeL setPreferredMaxLayoutWidth:214];
    describeL.delegate =self;
    [describeL.textContainer setLineBreakMode:kCTLineBreakByTruncatingTail];
    [describeL setTextContainer:[describeL textContainerContents:model imageType:OMGAttributedLabelImageType_RewardWorks]];
    
    [self addSubview:describeL];
    
    __weak typeof(self) wself = self;
    [avatars mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(5);
        make.width.height.mas_equalTo(24);
    }];
    [avatars.layer setCornerRadius: 24/2.0];
    
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(avatars.mas_right).offset(5);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(12);
        make.top.mas_equalTo(11);
    }];
    
    [dollar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLable.mas_right).offset(5);
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(14);
        make.top.mas_equalTo(11);
    }];
    
    [moneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(dollar.mas_right).offset(5);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(12);
        make.top.mas_equalTo(11);
    }];
    
    
    [describeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-18);
        make.height.mas_equalTo(18);
        make.top.mas_equalTo(avatars.mas_bottom).offset(3);
    }];
    
     [describeL setNumberOfLines:1];
    
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


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
