//
//  HomeGiftView.m
//  reward
//
//  Created by xujin on 2018/9/13.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "HomeGiftView.h"
#import "MOLVideoOutsideModel.h"
#import "MOLVideoModel.h"
#import "MOLExamineCardModel.h"
#import "MOLGiftCountView.h"

@interface HomeGiftView()
@property (nonatomic,strong)MOLVideoOutsideModel *currentModel;
@property (nonatomic,assign)CGRect rect;
@property (nonatomic,weak)UILabel *praiseLable;
@property (nonatomic, strong) MOLVideoModel *storyVO;  //作品模型
@property (nonatomic, strong) MOLExamineCardModel *rewardVO; //悬赏模型



@end

@implementation HomeGiftView

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
    UIImageView *headImage =[UIImageView new];
    [headImage setImage: [UIImage imageNamed:@"00013"]];
    NSString *urlString =@"";
    NSInteger giftNum = 0;
    NSInteger price =0;
    if (model.contentType==1) { //悬赏
        urlString =model.rewardVO.giftVO.giftThumb?model.rewardVO.giftVO.giftThumb:@"";
        giftNum =model.rewardVO.giftVO.giftNum;
        price =model.rewardVO.rewardAmount;
    }else{//作品
        if (model.storyVO.rewardVO) {//悬赏作品
            urlString =model.storyVO.rewardVO.giftVO.giftThumb?model.storyVO.rewardVO.giftVO.giftThumb:@"";
            giftNum =model.storyVO.rewardVO.giftVO.giftNum;
            price =model.storyVO.rewardVO.rewardAmount;
        }
    }
    [headImage sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed];
    //[headImage setFrame:CGRectMake(10, 28,self.rect.size.width-10*2.0,self.rect.size.height-28*2.0)];
    [headImage setFrame:CGRectMake(0, 0,self.rect.size.width,self.rect.size.height)];
    [headImage setContentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:headImage];
    
    UIImageView *bottomImgView =[UIImageView new];
    [bottomImgView setImage: [UIImage imageNamed:@"Group 15"]];
    
    [headImage addSubview:bottomImgView];
    
    MOLGiftCountView *giftCountView = [[MOLGiftCountView alloc] init];
    giftCountView.beginNumber = giftNum;
    CGSize giftSize = [[NSString stringWithFormat:@"X%ld",giftCountView.beginNumber] boundingRectWithSize:CGSizeMake(MAXFLOAT, 17) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : MOL_MEDIUM_FONT(18)} context:nil].size;
    if (giftSize.width > headImage.width-2*2-10) {
        giftSize.width = headImage.width-2*2-10;
    }
    [giftCountView setFrame:CGRectMake(headImage.width-giftSize.width-2*2-10, headImage.height-18-10, giftSize.width, 18)];
    [headImage addSubview:giftCountView];
    
    [bottomImgView setFrame:CGRectMake(giftCountView.left-4, giftCountView.top, giftCountView.width+8, giftCountView.height+1)];
    
    
//    UILabel *describeL=[UILabel new];
//    [describeL setText:[NSString stringWithFormat:@"%ld",price]];
//    CGSize desSize = [describeL.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 17) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : MOL_MEDIUM_FONT(12)} context:nil].size;
//
//    if (desSize.width>63) {
//        desSize.width =63;
//    }else if (desSize.width<20){
//        desSize.width=20;
//    }
//    [describeL setFrame:CGRectMake((self.width-desSize.width)/2.0+14,headImage.bottom+5,desSize.width, 17)];
//    [describeL setTextColor:HEX_COLOR(0xffffff)];
//    [describeL setFont:MOL_MEDIUM_FONT(12)];
//    //[describeL setBackgroundColor:[UIColor redColor]];
//    [describeL setTextAlignment:NSTextAlignmentCenter];
//
//
//    [self addSubview:describeL];
    
//    UIImageView *dollar =[UIImageView new];
//    [dollar setFrame:CGRectMake(describeL.left-14,headImage.bottom, 14, 14)];
//    dollar.centerY=describeL.centerY;
//    [dollar setImage: [UIImage imageNamed:@"mine_money"]];
//    [self addSubview:dollar];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
