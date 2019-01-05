//
//  MOLExamineCardModel.m
//  reward
//
//  Created by moli-2017 on 2018/9/15.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLExamineCardModel.h"
#import "OMGAttributedLabel.h"

@implementation MOLExamineCardModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"storyList":[MOLLightVideoModel class],
             @"contents":[ContentsItemModel class]
             };
}

- (NSString *)content
{
    if (_content == nil) {
        _content = @"";
    }
    return _content;
}

- (NSMutableArray *)storyList
{
    if (_storyList == nil) {
        _storyList = [NSMutableArray array];
    }
    
    return _storyList;
}

- (NSArray *)userArray
{
    NSArray *arr = [self.rewardUserVO.userAvatars componentsSeparatedByString:@","];
    return arr;
}

- (NSString *)videodescribe
{
    
    if (!self.rewardUserVO.userNum && !self.rewardUserVO.storyNum) {
        return @"当前还没有人发布新作品(共0个)";
    }else if(!self.rewardUserVO.userNum){
        NSString *t = [NSString stringWithFormat:@"当前还没有人发布新作品(共%ld个)",self.rewardUserVO.storyNum];
        return t;
    }else{
        NSString *t = [NSString stringWithFormat:@"%ld人新发布了你悬赏作品(共%ld个)",self.rewardUserVO.userNum,self.rewardUserVO.storyNum];
        return t;
    }
}

- (NSString *)timeDownTime
{
    NSString *time = [NSString timeGetRewardTimeWithTimestamp:self.finishTime];
    NSString * str = [NSString stringWithFormat:@"剩余%@",time];
    
    NSInteger cur = [NSString mol_timeWithCurrentTimestamp] * 1000;
    BOOL finish = (cur > self.finishTime.integerValue);
    if (finish || self.isFinish){
        str = @"已结束";
    }
    
    return str;
}

- (CGFloat)rewardCellHeight{
    if (_rewardCellHeight == 0) {
        // 计算高度
        /*间距15 + 头像40 + 间距10 + 内容（计算）+ 间距10 + 视频集154 + 间距15+1*/
        CGFloat height = 0;
        
        NSMutableAttributedString *str = [OMGAttributedLabel getJoinerAttributedStr:self];
        
        height = [str mol_getAttributedTextHeightWithMaxWith:MOL_SCREEN_WIDTH - 15 - 15 font:MOL_REGULAR_FONT(15)];
        if (height>=22*3) {//3行限制
            height =66;
        }
        
        _rewardCellHeight = 15 + 40 + 10 + height + 10 + 154 + 15 + 1;
        
     //   NSLog(@"^^^%@---%lf",self.content,_rewardCellHeight);
    }
    return _rewardCellHeight;
}

- (CGFloat)cardHeight
{
    if (_cardHeight == 0) {
        
        // 计算高度
        /*间距30 + 时间20 + 间距20 + 名字20 + 间距20 + 内容（计算 + 间距5 + 倒计时18 + 间距10 + 视频集154*/
        
        CGFloat height = 0;
        if (self.rewardType == 1) {  // 红包悬赏
            NSString *t = nil;
            if (self.isJoiner) {
                t = @"合拍";
            }
            
            NSMutableAttributedString *str = [self getHarmonyTextWitnContent:self.content type:t];
            height = [str mol_getThreeAttributedTextHeightWithMaxWith:MOL_SCREEN_WIDTH - 30 font:MOL_REGULAR_FONT(15)];
        }else{
            NSString *t = nil;
            if (self.isJoiner) {
                t = @"合拍";
            }
            NSMutableAttributedString *str = [self getHarmonyTextWitnContent:self.content type:t];
            height = [str mol_getThreeAttributedTextHeightWithMaxWith:MOL_SCREEN_WIDTH - 30 font:MOL_REGULAR_FONT(15)];
        }
        
        CGFloat height2 = 154;//self.storyList.count > 0 ? 154 : -10;
        
        _cardHeight = 30 + 20 + 20 + 20 + 20 + height + 5 + 18 + 10 + height2;
    }
    
    return _cardHeight;
}
- (CGFloat)startRecordCardHeight
{
    if (_startRecordCardHeight == 0) {
        
        // 计算高度MOLRcRewardCell
        /* 间距10 + 头像40 + 间距10 + 内容（计算）+ 间距10 +礼物图片53 + 间距10 */

        CGFloat height = 20;
        if (self.rewardType == 1) {  // 红包悬赏
            NSMutableAttributedString *str = [self getTextWitnContent:self.content type:nil];
            height = [str mol_getThreeAttributedTextHeightWithMaxWith:MOL_SCREEN_WIDTH - 30 font:MOL_REGULAR_FONT(15)];
        }else{
            NSMutableAttributedString *str = [self getTextWitnContent:self.content type:nil];
            height = [str mol_getThreeAttributedTextHeightWithMaxWith:MOL_SCREEN_WIDTH - 30 font:MOL_REGULAR_FONT(15)];
        }
        
        
        _startRecordCardHeight = 20 + 40 + 10 + height + 5 + 20 + 20;
    }
    
    return _startRecordCardHeight;
}


- (CGFloat)cardHeight_check
{
    if (_cardHeight_check == 0) {
        
        // 计算高度
        /* 间距20 + 图片高112 + 间距10 + 倒计时18 + 间距10 + 线1 + 间距10 + 内容（计算） + 间距10 + 线1 + 间距10 + 介绍文字(计算) + 间距10 + collectionview（MOL_SCREEN_ADAPTER(25)） + 间距10 */
        CGFloat height = 0;
        if (self.rewardType == 1) {  // 红包悬赏
            NSMutableAttributedString *str = [self getTextWitnContent:self.content type:@"红包悬赏"];
            height = [str mol_getAttributedTextHeightWithMaxWith:MOL_SCREEN_ADAPTER(345) - 20 font:MOL_REGULAR_FONT(15)];
        }else{
            NSMutableAttributedString *str = [self getTextWitnContent:self.content type:@"排位悬赏"];
            height = [str mol_getAttributedTextHeightWithMaxWith:MOL_SCREEN_ADAPTER(345) - 20 font:MOL_REGULAR_FONT(15)];
        }
        
        height = height > 44 ? 44 : height;
        
        CGFloat height1 = [self.videodescribe mol_getTextHeightWithMaxWith:MOL_SCREEN_ADAPTER(345) - 20 font:MOL_REGULAR_FONT(13)];
        
        CGFloat height2 = self.userArray.count > 0 ? MOL_SCREEN_ADAPTER(25) : -10;
        
        _cardHeight_check = 20 + 112 + 10 + 18 + 10 + 1 + 10 + height + 10 + 1 + 10 + height1 + 10 + height2 + 10;
    }
    
    return _cardHeight_check;
}

- (CGFloat)cardHeight_noBottom
{
    if (_cardHeight_noBottom == 0) {
        
        // 计算高度
        /* 间距20 + 图片高112 + 间距10 + 倒计时18 + 间距10 + 线1 + 间距10 + 内容（计算） + 间距10 */
        
        CGFloat height = 0;
        if (self.rewardType == 1) {  // 红包悬赏
            NSMutableAttributedString *str = [self getTextWitnContent:self.content type:@"红包悬赏"];
            height = [str mol_getAttributedTextHeightWithMaxWith:MOL_SCREEN_ADAPTER(300) - 20 font:MOL_REGULAR_FONT(15)];
        }else{
            NSMutableAttributedString *str = [self getTextWitnContent:self.content type:@"排位悬赏"];
            height = [str mol_getAttributedTextHeightWithMaxWith:MOL_SCREEN_ADAPTER(300) - 20 font:MOL_REGULAR_FONT(15)];
        }
        
        height = height > 44 ? 44 : height;
        
        _cardHeight_noBottom = 20 + 112 + 10 + 18 + 10 + 1 + 10 + height + 10;
    }
    
    return _cardHeight_noBottom;
}


- (CGFloat)scaleVideoH
{
    return MOL_SCREEN_ADAPTER(430);
}

- (CGFloat)scaleVideoW
{
    return MOL_SCREEN_ADAPTER(242);
}

- (CGFloat)cellHeight_homeFocus
{
    if (_cellHeight_homeFocus == 0) {
        
        // 间距 25 + 头像 40 + 间距 10 + 文字（计算） + 间距 10 + 视频（计算）+ 间距 10 + 时间 20 + 间距 20 + 按钮 40 + 间距 20
        
        // 计算文字高度
        NSMutableAttributedString *str = [self getTextWitnContent:self.content type:self.rewardType == 1?@"红包悬赏":@"排名悬赏"];
        CGFloat textH = [str mol_getAttributedTextHeightWithMaxWith:MOL_SCREEN_WIDTH - 15 * 2 font:MOL_REGULAR_FONT(15)];
        
        // 视频高度
        CGFloat videoH = 0;
        
        CGFloat maxW = MOL_SCREEN_WIDTH - 15;
        CGFloat maxH = MOL_SCREEN_ADAPTER(430);
        CGFloat scaleW = MOL_SCREEN_ADAPTER(self.scaleVideoW);
        CGFloat scaleH = MOL_SCREEN_ADAPTER(self.scaleVideoH);
        
        if (scaleW > maxW) {  // 判断是不是超过最大的宽度
            // 计算高度
            videoH = maxW * self.scaleVideoH / self.scaleVideoW;
            self.scaleVideoW = maxW;
            self.scaleVideoH = videoH;
        }else{
            self.scaleVideoW = scaleW;
            
            if (scaleH > maxH) {
                videoH = maxH;
                self.scaleVideoH = videoH;
            }else{
                videoH = scaleH;
                self.scaleVideoH = videoH;
            }
        }
        
        _cellHeight_homeFocus = 25 + 40 + 10 + textH + 10 + videoH + 10 + 20 + 20 + 30 + 10;
    }
    
    return _cellHeight_homeFocus;
}

- (NSMutableAttributedString *)getTextWitnContent:(NSString *)content type:(NSString *)type   // type  红包悬赏 排位悬赏
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:content];
    text.yy_color = HEX_COLOR_ALPHA(0xffffff, 0.6);
    text.yy_font = MOL_REGULAR_FONT(15);
    
    if (!type.length) {
        return text;
    }
    
    UIImage *image = [UIImage imageNamed:@"mine_ harmony"];
    
    if ([type isEqualToString:@"红包悬赏"]) {
        image = [UIImage imageNamed:@"packet_type"];
    }else if ([type isEqualToString:@"排名悬赏"]){
        image = [UIImage imageNamed:@"ranking_type"];
    }
    
    image = [UIImage imageWithCGImage:image.CGImage scale:MOL_SCREEN_SCALE orientation:UIImageOrientationUp];
    
    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:MOL_REGULAR_FONT(15) alignment:YYTextVerticalAlignmentCenter];
    
//    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@  ",type]];
//    one.yy_font = [UIFont boldSystemFontOfSize:10];
//    one.yy_color = [UIColor whiteColor];
//    
//    YYTextBorder *border = [YYTextBorder new];
//    border.cornerRadius = 2;
//    border.insets = UIEdgeInsetsMake(-3, -3, -3, -3);
//    if ([type isEqualToString:@"红包悬赏"]) {
//        border.fillColor = HEX_COLOR(0xFE6257);
//    }else{
//        border.fillColor = HEX_COLOR(0x74BDF5);
//    }
//    border.lineStyle = YYTextLineStyleSingle;
//    [one yy_setTextBackgroundBorder:border range:[one.string rangeOfString:type]];
    
    [text insertAttributedString:attachText atIndex:0];
    
    return text;
}

- (NSMutableAttributedString *)getHarmonyTextWitnContent:(NSString *)content type:(NSString *)type   // type  红包悬赏 排位悬赏
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:content];
    text.yy_color = HEX_COLOR_ALPHA(0xffffff, 0.8);
    text.yy_font = MOL_REGULAR_FONT(15);
    
    if (!type.length) {
        return text;
    }
    
    UIImage *image = [UIImage imageNamed:@"mine_ harmony"];
    image = [UIImage imageWithCGImage:image.CGImage scale:2 orientation:UIImageOrientationUp];
    
    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:MOL_REGULAR_FONT(15) alignment:YYTextVerticalAlignmentCenter];
    
    [text insertAttributedString:attachText atIndex:0];
    return text;
}
@end
