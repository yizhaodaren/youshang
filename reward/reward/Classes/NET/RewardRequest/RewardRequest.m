//
//  RewardRequest.m
//  reward
//
//  Created by xujin on 2018/10/14.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "RewardRequest.h"
#import "MOLBannerSetModel.h"
#import "MOLVideoOutsideModel.h"
#import "RewardSetModel.h"
typedef NS_ENUM(NSUInteger, RewardRequestType) {
    RewardRequestType_Detail, //悬赏详情
    RewardRequestType_AwardList, //悬赏详情-获奖清单
    RewardRequestType_Banner, //banner
    RewardRequestType_GreenBanner,//开平广告
};

@interface RewardRequest()
@property (nonatomic, assign) RewardRequestType type;
@property (nonatomic, strong) NSDictionary *parameter;
@property (nonatomic, strong) NSString *parameterId;
@end

@implementation RewardRequest

/// banner POST /banner/infos
- (instancetype)initRequest_BannerParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = RewardRequestType_Banner;
        _parameter = parameter;
       
    }
    
    return self;
}
//开屏广告
- (instancetype)initRequest_GreenBannerParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = RewardRequestType_GreenBanner;
        _parameter = parameter;
        
    }
    
    return self;
}

/// 悬赏详情
- (instancetype)initRequest_RewardDetailParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId{
    self = [super init];
    if (self) {
        _type = RewardRequestType_Detail;
        _parameter = parameter;
        _parameterId =parameterId;
    }
    
    return self;
}

/// 悬赏详情-获奖清单
- (instancetype)initRequest_RewardDetail_AwardListParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = RewardRequestType_AwardList;
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
    if (_type ==  RewardRequestType_Detail) {
        return [MOLVideoOutsideModel class];
    }else if (_type == RewardRequestType_AwardList){
        return [RewardSetModel class];
    }else if (_type == RewardRequestType_Banner || _type == RewardRequestType_GreenBanner){
        return [MOLBannerSetModel class];
    }
    return [MOLBaseModel class];
}

- (NSString *)requestUrl
{
    switch (_type) {
        case RewardRequestType_Detail:
        {
            NSString *url = @"/reward/rewardInfo/{rewardId}";
            url = [url stringByReplacingOccurrencesOfString:@"{rewardId}" withString:self.parameterId];
            return url;
        }
            break;
       
        case RewardRequestType_AwardList:
        {
            NSString *url = @"/reward/users";
            return url;
        }
            break;
        
        case RewardRequestType_Banner:
        {
            NSString *url = @"/banner/infos";
            return url;
        }
            break;
        case RewardRequestType_GreenBanner:
        {
            NSString *url = @"/banner/greenBanner";
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
