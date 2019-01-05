//
//  MOLLightRewardModel.h
//  reward
//
//  Created by xujin on 2018/10/10.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseModel.h"
#import "MOLGiftModel.h"
#import "ContentsItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MOLLightRewardModel : MOLBaseModel
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSMutableArray <ContentsItemModel *>*contents;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) NSInteger rewardId;
@property (nonatomic, assign) NSInteger rewardType;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) NSInteger rewardAmount; // 金币总数
@property (nonatomic, strong) MOLGiftModel *giftVO;
@property (nonatomic, assign) BOOL isFinish;
@property (nonatomic, assign) NSInteger awardSize; // 获奖清单 总数
@property (nonatomic, assign) NSInteger remainSize;// 获奖清单 剩余数
@property (nonatomic, assign) BOOL isJoiner;
@end

NS_ASSUME_NONNULL_END
