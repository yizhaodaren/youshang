//
//  MOLStatisticsRequest.m
//  reward
//
//  Created by moli-2017 on 2018/10/26.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLStatisticsRequest.h"

typedef NS_ENUM(NSUInteger, MOLStatisticsRequestType) {
    MOLStatisticsRequestType_Statistics,
};
@interface MOLStatisticsRequest ()
@property (nonatomic, assign) MOLStatisticsRequestType type;
@property (nonatomic, strong) NSDictionary *parameter;
@property (nonatomic, strong) NSString *parameterId;
@end

@implementation MOLStatisticsRequest

- (instancetype)initRequest_StatisticsWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type = MOLStatisticsRequestType_Statistics;
        _parameter = parameter;
    }
    
    return self;
}


- (id)requestArgument
{
    return _parameter;
}

- (Class)modelClass
{
    return [MOLBaseModel class];
}

- (NSString *)requestUrl
{
    switch (_type) {
        case MOLStatisticsRequestType_Statistics:
        {
            NSString *url = @"play/playAudio";
            return url;
        }
            break;
        default:
            return @"";
            break;
    }
}

- (NSString *)parameterId {
    if (!_parameterId.length) {
        return @"";
    }
    return _parameterId;
}
@end
