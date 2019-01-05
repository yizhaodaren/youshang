//
//  HoursCell.h
//  reward
//
//  Created by xujin on 2018/9/19.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RewardType) {
    RewardOfficialRewardType,   //官方悬赏任务
    RewardOfficialActivityType, //官方活动
    RewardUserRewardType,       //用户悬赏发布
    RewardLotteryType,          //悬赏任务完成开奖
    RewardTOP3Type,             //排位悬赏TOP3作品推荐
    RewardRedPacketBestuckType, //红包悬赏手气最佳的作品推荐
    RewardSuperPopularType,     //作品获得超级多人气
    RewardLotsPeopleType, //悬赏得到非常多人参加
};
@class HoursModel;
@interface HoursCell : UITableViewCell
- (void)contentCell:(HoursModel *)model indexPath:(NSIndexPath *)indexPath;
@end
