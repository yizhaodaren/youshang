//
//  RewardDetailViewController.h
//  reward
//
//  Created by xujin on 2018/9/23.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseViewController.h"
#import "MOLVideoOutsideModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface RewardDetailViewController : MOLBaseViewController
@property (nonatomic, strong) MOLVideoOutsideModel *rewardModel;
@property (nonatomic, strong) NSString *rewardId;

@end

NS_ASSUME_NONNULL_END
