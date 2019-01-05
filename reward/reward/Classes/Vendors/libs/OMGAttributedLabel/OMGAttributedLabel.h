//
//  OMGAttributedLabel.h
//  reward
//
//  Created by ACTION on 2018/11/9.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "TYAttributedLabel.h"
@class HomeCommentModel,MOLExamineCardModel;

typedef NS_ENUM(NSInteger, OMGAttributedLabelImageType) {
    OMGAttributedLabelImageType_Undefined,   // 未定义
    OMGAttributedLabelImageType_Reward,      // 悬赏图标
    OMGAttributedLabelImageType_InTune,      // 合拍图标
    OMGAttributedLabelImageType_Common,      // 悬赏图标、合拍图标
    OMGAttributedLabelImageType_RewardWorks,      // 悬赏作品
    OMGAttributedLabelImageType_ReplyComment,      // 回复评论
    
};


@interface OMGAttributedLabel : TYAttributedLabel

- (TYTextContainer *)textContainerContents:(id)model imageType:(OMGAttributedLabelImageType)imageType;
//获取计算高度用的 NSMutableAttributedString WSC
+(NSMutableAttributedString *)getAttributedStr:(MOLVideoOutsideModel *)model;

//获取计算高度用的 NSMutableAttributedString 有可能包含合拍图
+(NSMutableAttributedString *)getJoinerAttributedStr:(MOLExamineCardModel *)model;

//
+(NSMutableAttributedString *)getJoinerCommonAttributedStr:(MOLVideoOutsideModel *)model;
@end
