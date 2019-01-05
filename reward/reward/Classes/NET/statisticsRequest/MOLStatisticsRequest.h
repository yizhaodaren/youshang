//
//  MOLStatisticsRequest.h
//  reward
//
//  Created by moli-2017 on 2018/10/26.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLNetRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MOLStatisticsRequest : MOLNetRequest

/// 获取版本更新
/*
 operateType (integer, optional): 类型 1播放 2分享 3下载 ,
 recordType (integer, optional): 类型 1悬赏 2作品 ,
 typeId (integer, optional): 类型ID 悬赏或者作品的ID
 */
- (instancetype)initRequest_StatisticsWithParameter:(NSDictionary *)parameter;
@end

NS_ASSUME_NONNULL_END
