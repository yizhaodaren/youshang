//
//  MOLStatistics.m
//  reward
//
//  Created by moli-2017 on 2018/10/26.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLStatistics.h"

#import "MOLStatisticsRequest.h"

@implementation MOLStatistics

/// 统计播放
+ (void)statistics_play:(NSDictionary *)dictionary
{
    MOLStatisticsRequest *r = [[MOLStatisticsRequest alloc] initRequest_StatisticsWithParameter:dictionary];
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        
    }];
}
/// 统计分享
+ (void)statistics_share:(NSDictionary *)dictionary
{
    MOLStatisticsRequest *r = [[MOLStatisticsRequest alloc] initRequest_StatisticsWithParameter:dictionary];
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        
    }];
}
/// 统计下载
+ (void)statistics_downLoad:(NSDictionary *)dictionary
{
    MOLStatisticsRequest *r = [[MOLStatisticsRequest alloc] initRequest_StatisticsWithParameter:dictionary];
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        
    }];
}
@end
