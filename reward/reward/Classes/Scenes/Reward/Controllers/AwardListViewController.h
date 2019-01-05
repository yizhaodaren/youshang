//
//  AwardListViewController.h
//  reward
//
//  Created by xujin on 2018/9/27.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseViewController.h"
#import "MOLVideoOutsideModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AwardListViewController : MOLBaseViewController
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) MOLVideoOutsideModel *rewardModel;
@end

NS_ASSUME_NONNULL_END
