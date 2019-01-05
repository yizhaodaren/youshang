//
//  MOLRewardListViewController.h
//  reward
//
//  Created by apple on 2018/9/22.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseViewController.h"
typedef NS_ENUM(NSUInteger, RewardSortType) {
    RewardRecommendType,//推荐
    RewardHaoType, //最豪
    RewardNewestType, //最新
};
@interface MOLRewardListViewController : MOLBaseViewController
@property(nonatomic,weak) UITableView *tableView;
@property(nonatomic,assign)RewardSortType sortType;
@property(nonatomic,strong)dispatch_block_t requestBannerBlock;
@end
