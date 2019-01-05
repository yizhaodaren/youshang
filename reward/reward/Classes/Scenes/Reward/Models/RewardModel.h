//
//  RewardModel.h
//  reward
//
//  Created by xujin on 2018/9/23.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RewardModel : NSObject
@property (nonatomic, copy)   NSString *userAvatar;//用户头像
@property (nonatomic, copy)   NSString *userName;//用户名称
@property (nonatomic, assign) NSInteger userId; //用户id
@property (nonatomic, assign) NSInteger coin; //金额
@property (nonatomic, assign) NSInteger createTime; //创建时间
@property (nonatomic, assign) NSInteger rewardType; //0 排名悬赏 1红包悬赏
@property (nonatomic, assign) BOOL isExistVideo; //是否存在视频资源
@property (nonatomic, assign) BOOL isUserOneself; //是否是用户自己
@property (nonatomic, assign) NSInteger pIndex; //显示第几个
@property (nonatomic, assign) BOOL best ; //yes手气最佳 no非

@end

NS_ASSUME_NONNULL_END
