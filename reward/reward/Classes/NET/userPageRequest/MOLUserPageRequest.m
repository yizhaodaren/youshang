//
//  MOLUserPageRequest.m
//  reward
//
//  Created by moli-2017 on 2018/10/8.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLUserPageRequest.h"

typedef NS_ENUM(NSUInteger, MOLUserPageRequestType) {
    MOLUserPageRequestType_productionList,
    MOLUserPageRequestType_rewardList,
    MOLUserPageRequestType_likeList,
    MOLUserPageRequestType_treasure,
};

@interface MOLUserPageRequest ()
@property (nonatomic, assign) MOLUserPageRequestType type;
@property (nonatomic, strong) NSDictionary *parameter;
@property (nonatomic, strong) NSString *parameterId;
@end

@implementation MOLUserPageRequest

/// 获取用户作品
- (instancetype)initRequest_getProductionListWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type = MOLUserPageRequestType_productionList;
        _parameter = parameter;
    }
    
    return self;
}

/// 获取用户悬赏
- (instancetype)initRequest_getRewardListWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type = MOLUserPageRequestType_rewardList;
        _parameter = parameter;
    }
    
    return self;
}

/// 获取用户喜欢
- (instancetype)initRequest_getLikeListWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type = MOLUserPageRequestType_likeList;
        _parameter = parameter;
    }
    
    return self;
}


/// 获取我的财富
- (instancetype)initRequest_getTreasureWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type = MOLUserPageRequestType_treasure;
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
    if (_type == MOLUserPageRequestType_likeList ||
        _type == MOLUserPageRequestType_rewardList ||
        _type == MOLUserPageRequestType_productionList) {
        return [MOLVideoOutsideGroupModel class];
    }
    
    if (_type == MOLUserPageRequestType_treasure) {
        return [MOLTreasureModel class];
    }
    
    return [MOLBaseModel class];
}

- (NSString *)requestUrl
{
    switch (_type) {
        case MOLUserPageRequestType_productionList:
        {
            NSString *url = @"/story/stories";
            return url;
        }
            break;
        case MOLUserPageRequestType_rewardList:
        {
            NSString *url = @"/reward/rewards";
            return url;
        }
            break;
        case MOLUserPageRequestType_likeList:
        {
            NSString *url = @"/favor/list";
            return url;
        }
            break;
        case MOLUserPageRequestType_treasure:
        {
            NSString *url = @"/user/userWallet";
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
