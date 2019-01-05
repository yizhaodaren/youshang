//
//  RewardWorkModel.h
//  reward
//
//  Created by xujin on 2018/9/23.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RewardWorkModel : MOLBaseModel
@property (nonatomic,assign)NSInteger rewardType; //0 排名悬赏 1 红包悬赏
@property (nonatomic,assign)BOOL isExistMark;
@property (nonatomic,copy)NSString *imgPath;


@end

NS_ASSUME_NONNULL_END
