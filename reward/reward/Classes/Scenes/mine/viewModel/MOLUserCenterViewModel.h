//
//  MOLUserCenterViewModel.h
//  reward
//
//  Created by moli-2017 on 2018/9/15.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOLUserCenterViewModel : NSObject
@property (nonatomic, strong) RACCommand *userInfoCommand;  // 用户个人信息
@property (nonatomic, strong) RACCommand *userProductionCommand;  // 用户的作品
@property (nonatomic, strong) RACCommand *userRewardCommand;  // 用户的悬赏
@property (nonatomic, strong) RACCommand *userLikeCommand;  // 用户的喜欢
@end
