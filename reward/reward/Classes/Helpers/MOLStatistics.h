//
//  MOLStatistics.h
//  reward
//
//  Created by moli-2017 on 2018/10/26.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MOLStatistics : NSObject

/// 统计播放
+ (void)statistics_play:(NSDictionary *)dictionary;
/// 统计分享
+ (void)statistics_share:(NSDictionary *)dictionary;
/// 统计下载
+ (void)statistics_downLoad:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
