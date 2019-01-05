//
//  SendedRewardView.m
//  reward
//
//  Created by xujin on 2018/11/10.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "SendedRewardView.h"
#import "MOLVideoOutsideModel.h"

@interface  SendedRewardView()
@property (nonatomic,strong)MOLVideoOutsideModel *currentModel;
@property (nonatomic,assign)CGRect rect;


@end
@implementation SendedRewardView
- (void)initData{
    self.currentModel =[MOLVideoOutsideModel new];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.rect =frame;
        [self initData];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.rect =frame;
    [self initData];
}

- (void)content:(MOLVideoOutsideModel *)model{
    
    
    YYLabel *mainCommet =[YYLabel new];
    [mainCommet setBackgroundColor: [UIColor clearColor]];
    [mainCommet setTextColor: HEX_COLOR_ALPHA(0xFFEC00,1)];
    [mainCommet setFont: MOL_MEDIUM_FONT(12)];
    [mainCommet setNumberOfLines:1];
    // [mainCommet setPreferredMaxLayoutWidth:MOL_SCREEN_WIDTH - 80 - 15];
    
    NSString *detailStr=@"发布赏金";
    
    NSMutableAttributedString *desStr = [STSystemHelper attributedContent:[NSString stringWithFormat:@" %@",detailStr] color:HEX_COLOR_ALPHA(0xFFEC00,1) font:MOL_MEDIUM_FONT(12)];
    
    YYAnimatedImageView *desImage= [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"mine_money"]];
    desImage.frame = CGRectMake(0, 0, 14, 14);
    
    NSMutableAttributedString *attachDes =[NSMutableAttributedString yy_attachmentStringWithContent:desImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:desImage.size alignToFont:MOL_MEDIUM_FONT(12) alignment:YYTextVerticalAlignmentCenter];
    
    [desStr appendAttributedString:attachDes];
    NSMutableAttributedString *desStr1 = [STSystemHelper attributedContent:[NSString stringWithFormat:@"%@ ",[STSystemHelper countNumAndChangeformat:[NSString stringWithFormat:@"%ld",model.rewardVO.rewardAmount]]] color:HEX_COLOR_ALPHA(0xFFEC00,1) font:MOL_MEDIUM_FONT(12)];
    [desStr appendAttributedString:desStr1];
    
    mainCommet.attributedText =desStr;
    
    [mainCommet setFrame:CGRectMake(0, 0, self.rect.size.width, self.rect.size.height)];
    
    
   
    [self addSubview:mainCommet];
    
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
