//
//  MOLAewardModel.h
//  reward
//
//  Created by apple on 2018/9/28.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef NS_ENUM(NSInteger, RewardType) {
//    RewardType_RedEnvelope = 0,//红包
//    RewardType_Ranking,//排名
//};


//发布时候存数据用的
@class MOLGiftModel;
@interface MOLRewardModel : NSObject
@property(nonatomic,assign)NSInteger rewardType;//悬赏类型 1红包 2排名
@property(nonatomic,copy)NSString *contentStr;//接口传送的Str
@property(nonatomic,copy)NSString *content;//描述内容
@property(nonatomic,assign)MOLGiftModel * gift;//礼物ID
@property(nonatomic,assign)NSInteger gitfNum;//礼物数量
@property(nonatomic,assign)NSInteger isJoiner;//是否合拍 0非合拍,1合拍

//红包悬赏的
@property(nonatomic,assign)NSInteger redEnvelopeNum;//红包个数

//排名悬赏的
@property(nonatomic,copy)NSString *finishTime;//结束时间
@property(nonatomic,copy)NSString *finishDate;
@property(nonatomic,copy)NSString *finishDateStr;

@end
