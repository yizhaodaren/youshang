//
//  MOLUserPageRequest.h
//  reward
//
//  Created by moli-2017 on 2018/10/8.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLNetRequest.h"
#import "MOLVideoOutsideGroupModel.h"
#import "MOLTreasureModel.h"

@interface MOLUserPageRequest : MOLNetRequest

/// 获取用户作品 / 获取用户悬赏下的作品列表
- (instancetype)initRequest_getProductionListWithParameter:(NSDictionary *)parameter;

/// 获取用户悬赏
- (instancetype)initRequest_getRewardListWithParameter:(NSDictionary *)parameter;

/// 获取用户喜欢
- (instancetype)initRequest_getLikeListWithParameter:(NSDictionary *)parameter;

/// 获取我的财富
- (instancetype)initRequest_getTreasureWithParameter:(NSDictionary *)parameter;
@end
