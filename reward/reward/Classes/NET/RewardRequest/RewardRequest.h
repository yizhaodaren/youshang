//
//  RewardRequest.h
//  reward
//
//  Created by xujin on 2018/10/14.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLNetRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface RewardRequest : MOLNetRequest

/// 悬赏详情
- (instancetype)initRequest_RewardDetailParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId;

/// 悬赏详情-获奖清单
- (instancetype)initRequest_RewardDetail_AwardListParameter:(NSDictionary *)parameter;


/// banner POST /banner/infos
- (instancetype)initRequest_BannerParameter:(NSDictionary *)parameter;
//开屏广告
- (instancetype)initRequest_GreenBannerParameter:(NSDictionary *)parameter;

@end

NS_ASSUME_NONNULL_END
