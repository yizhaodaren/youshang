//
//  MOLActionRequest.m
//  reward
//
//  Created by moli-2017 on 2018/10/11.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLActionRequest.h"
typedef NS_ENUM(NSUInteger, MOLActionRequestType) {
    MOLActionRequest_focus,
    MOLActionRequest_relation,
    MOLActionRequest_payout,
    MOLActionRequest_reportUser,
    MOLActionRequest_blackUser,
};
@interface MOLActionRequest ()
@property (nonatomic, assign) MOLActionRequestType type;
@property (nonatomic, strong) NSDictionary *parameter;
@property (nonatomic, strong) NSString *parameterId;
@end

@implementation MOLActionRequest

/// 关注 / 取关
- (instancetype)initRequest_focusActionWithParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId
{
    self = [super init];
    if (self) {
        _type = MOLActionRequest_focus;
        _parameter = parameter;
        _parameterId = parameterId;
    }
    
    return self;
}

/// 查询关注关系
- (instancetype)initRequest_relationActionWithParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId
{
    self = [super init];
    if (self) {
        _type = MOLActionRequest_relation;
        _parameter = parameter;
        _parameterId = parameterId;
    }
    
    return self;
}


/// 发布红包
- (instancetype)initRequest_payoutActionWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type = MOLActionRequest_payout;
        _parameter = parameter;
    }
    
    return self;
}

/// 举报用户
- (instancetype)initRequest_reportUserActionWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type = MOLActionRequest_reportUser;
        _parameter = parameter;
    }
    
    return self;
}

/// 拉黑用户
- (instancetype)initRequest_blackUserActionWithParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId
{
    self = [super init];
    if (self) {
        _type = MOLActionRequest_blackUser;
        _parameter = parameter;
        _parameterId = parameterId;
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
        case MOLActionRequest_focus:
        {
            NSString *url = @"/friend/concern/{toUserId}";
            url = [url stringByReplacingOccurrencesOfString:@"{toUserId}" withString:self.parameterId];
            return url;
        }
            break;
        case MOLActionRequest_relation:
        {
            NSString *url = @"/friend/queryFriend/{toUserId}";
            url = [url stringByReplacingOccurrencesOfString:@"{toUserId}" withString:self.parameterId];
            return url;
        }
            break;
        case MOLActionRequest_payout:
        {
            NSString *url = @"/reward/drawRedPackage";
            return url;
        }
            break;
        case MOLActionRequest_reportUser:
        {
            NSString *url = @"/report/add";
            return url;
        }
            break;
        case MOLActionRequest_blackUser:
        {
            NSString *url = @"/user/blackUser/{userId}";
            url = [url stringByReplacingOccurrencesOfString:@"{userId}" withString:self.parameterId];
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
