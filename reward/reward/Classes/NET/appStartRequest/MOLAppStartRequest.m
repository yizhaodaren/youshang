//
//  MOLAppStartRequest.m
//  reward
//
//  Created by moli-2017 on 2018/10/23.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLAppStartRequest.h"

typedef NS_ENUM(NSUInteger, MOLAppStartRequestType) {
    MOLAppStartRequestType_version,
    MOLAppStartRequestType_switch,
    MOLAppStartRequestType_addLog,
    
};
@interface MOLAppStartRequest ()
@property (nonatomic, assign) MOLAppStartRequestType type;
@property (nonatomic, strong) NSDictionary *parameter;
@property (nonatomic, strong) NSString *parameterId;
@end

@implementation MOLAppStartRequest
/// 获取版本更新
- (instancetype)initRequest_versionCheckWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type = MOLAppStartRequestType_version;
        _parameter = parameter;
    }
    
    return self;
}

/// 获取开关接口
- (instancetype)initRequest_getSwitchActionCommentWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type = MOLAppStartRequestType_switch;
        _parameter = parameter;
    }
    
    return self;
}
//上报日志
- (instancetype)initRequest_addLogWithParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = MOLAppStartRequestType_addLog;
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
        case MOLAppStartRequestType_version:
        {
            NSString *url = @"/version/version";
            return url;
        }
            break;
        case MOLAppStartRequestType_switch:
        {
            NSString *url = @"/version/versionInfo";
            return url;
        }
            break;
        case MOLAppStartRequestType_addLog:
        {
            NSString *url = @"/dataLog/addLog";
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
