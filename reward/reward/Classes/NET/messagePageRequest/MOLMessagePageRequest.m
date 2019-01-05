//
//  MOLMessagePageRequest.m
//  reward
//
//  Created by moli-2017 on 2018/10/9.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLMessagePageRequest.h"

typedef NS_ENUM(NSUInteger, MOLMessagePageRequestType) {
    MOLMessagePageRequestType_focus,
    MOLMessagePageRequestType_fans,
    MOLMessagePageRequestType_like,
    MOLMessagePageRequestType_comment,
    MOLMessagePageRequestType_examine,
    MOLMessagePageRequestType_at,
};
@interface MOLMessagePageRequest ()
@property (nonatomic, assign) MOLMessagePageRequestType type;
@property (nonatomic, strong) NSDictionary *parameter;
@property (nonatomic, strong) NSString *parameterId;
@end
@implementation MOLMessagePageRequest


/// 获取用户评选
- (instancetype)initRequest_getExamineListWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type = MOLMessagePageRequestType_examine;
        _parameter = parameter;
    }
    return self;
}

/// 点赞列表
- (instancetype)initRequest_likeListWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type = MOLMessagePageRequestType_like;
        _parameter = parameter;
    }
    return self;
}

/// 评论列表
- (instancetype)initRequest_commentListWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type = MOLMessagePageRequestType_comment;
        _parameter = parameter;
    }
    return self;
}

/// 关注列表
- (instancetype)initRequest_focusListWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type = MOLMessagePageRequestType_focus;
        _parameter = parameter;
    }
    return self;
}

/// 粉丝列表
- (instancetype)initRequest_fansListWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type = MOLMessagePageRequestType_fans;
        _parameter = parameter;
    }
    return self;
}

/// @列表
- (instancetype)initRequest_atListWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type = MOLMessagePageRequestType_at;
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
    if (_type == MOLMessagePageRequestType_examine) {
        return [MOLVideoOutsideGroupModel class];
    }
    
    if (_type == MOLMessagePageRequestType_focus ||
        _type == MOLMessagePageRequestType_fans) {
        return [ MOLMsgUserGroupModel class];
    }
    
    if (_type == MOLMessagePageRequestType_like) {
        return [MOLMsgAgreeGroupModel class];
    }
    
    if (_type == MOLMessagePageRequestType_comment) {
        return [MOLMsgCommentGroupModel class];
    }
    
    if (_type == MOLMessagePageRequestType_at) {
        return [MOLAtUserGroupModel class];
    }
    
    return [MOLBaseModel class];
}

- (NSString *)requestUrl
{
    switch (_type) {
        case MOLMessagePageRequestType_focus:
        {
            NSString *url = @"/friend/concerns";
            return url;
        }
            break;
        case MOLMessagePageRequestType_fans:
        {
            NSString *url = @"/friend/fans";
            return url;
        }
            break;
        case MOLMessagePageRequestType_like:
        {
            NSString *url = @"/pushMsg/list";
            return url;
        }
            break;
        case MOLMessagePageRequestType_comment:
        {
            NSString *url = @"/pushMsg/list";
            return url;
        }
            break;
        case MOLMessagePageRequestType_examine:
        {
            NSString *url = @"/reward/redBags";
            return url;
        }
            break;
            
        case MOLMessagePageRequestType_at:
        {
            NSString *url = @"/pushMsg/list";
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
