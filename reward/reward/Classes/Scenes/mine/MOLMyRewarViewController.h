//
//  MOLMyRewarViewController.h
//  reward
//
//  Created by moli-2017 on 2018/9/12.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseViewController.h"

@interface MOLMyRewarViewController : MOLBaseViewController
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) BOOL isOwner;  // 是否是自己
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) BOOL showNav;
- (void)getUserReward;
@end
