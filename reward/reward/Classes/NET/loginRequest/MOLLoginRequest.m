//
//  MOLLoginRequest.m
//  reward
//
//  Created by moli-2017 on 2018/9/23.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLLoginRequest.h"

typedef NS_ENUM(NSUInteger, MOLLoginRequestType) {
    MOLLoginRequestType_code,
    MOLLoginRequestType_login,
    MOLLoginRequestType_changeInfo,
    MOLLoginRequestType_binding,
    MOLLoginRequestType_removeBinding,
    MOLLoginRequestType_userInfo,
    MOLLoginRequestType_changePsw,
    MOLLoginRequestType_userAccount,
    MOLLoginRequestType_checkUserAccount,
    MOLLoginRequestType_videoAuth,
};

@interface MOLLoginRequest ()
@property (nonatomic, assign) MOLLoginRequestType type;
@property (nonatomic, strong) NSDictionary *parameter;
@property (nonatomic, strong) NSString *parameterId;
@end

@implementation MOLLoginRequest

/// 获取验证码
- (instancetype)initRequest_getCodeWithParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId
{
    self = [super init];
    if (self) {
        _type = MOLLoginRequestType_code;
        _parameter = parameter;
        _parameterId = parameterId;
    }
    
    return self;
}

/// 登录(快捷登录、三方登录、密码登录、找回密码登录)
- (instancetype)initRequest_loginWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type = MOLLoginRequestType_login;
        _parameter = parameter;
    }
    
    return self;
}

/// 修改用户信息
- (instancetype)initRequest_changeInfoWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type = MOLLoginRequestType_changeInfo;
        _parameter = parameter;
    }
    return self;
}

/// 修改密码
- (instancetype)initRequest_changePasswordWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type = MOLLoginRequestType_changePsw;
        _parameter = parameter;
    }
    return self;
}

/// 绑定（三方+手机）
- (instancetype)initRequest_bindingWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type = MOLLoginRequestType_binding;
        _parameter = parameter;
    }
    
    return self;
}

/// 解除绑定三方
- (instancetype)initRequest_removeBindingWithParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId
{
    self = [super init];
    if (self) {
        _type = MOLLoginRequestType_removeBinding;
        _parameter = parameter;
        _parameterId = parameterId;
    }
    
    return self;
}

/// 获取用户信息
- (instancetype)initRequest_getUserInfoWithParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId
{
    self = [super init];
    if (self) {
        _type = MOLLoginRequestType_userInfo;
        _parameter = parameter;
        _parameterId = parameterId;
    }
    
    return self;
}

/// 用户账户信息
- (instancetype)initRequest_userAccountWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type = MOLLoginRequestType_userAccount;
        _parameter = parameter;
    }
    
    return self;
}

/// 检查是否是注册用户
- (instancetype)initRequest_checkUserAccountWithParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId
{
    self = [super init];
    if (self) {
        _type = MOLLoginRequestType_checkUserAccount;
        _parameter = parameter;
        _parameterId = parameterId;
    }
    
    return self;
}
// 视频认证
- (instancetype)initRequest_videoAuthWithParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = MOLLoginRequestType_videoAuth;
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
    if (_type == MOLLoginRequestType_login ||
        _type == MOLLoginRequestType_userInfo ||
        _type == MOLLoginRequestType_changeInfo) {
        return [MOLUserModel class];
    }

    
    if (_type == MOLLoginRequestType_userAccount) {
        return [MOLAccountModel class];
    }
    return [MOLBaseModel class];
}

- (NSString *)requestUrl
{
    switch (_type) {
        case MOLLoginRequestType_code:
        {
            NSString *url = @"/getPhoneCode/{phone}";
            url = [url stringByReplacingOccurrencesOfString:@"{phone}" withString:self.parameterId];
            return url;
        }
            break;
        case MOLLoginRequestType_login:
        {
            NSString *url = @"/user/login";
            return url;
        }
            break;
        case MOLLoginRequestType_changeInfo:
        {
            NSString *url = @"/user/updateUserInfo";
            return url;
        }
            break;
        case MOLLoginRequestType_changePsw:
        {
            NSString *url = @"/user/updateUserPassword";
            return url;
        }
            break;
        case MOLLoginRequestType_binding:
        {
            NSString *url = @"/user/bindUserInfo";
            return url;
        }
            break;
        case MOLLoginRequestType_removeBinding:
        {
            NSString *url = @"/user/removeLoginInfo/{loginType}";
            url = [url stringByReplacingOccurrencesOfString:@"{loginType}" withString:self.parameterId];
            return url;
        }
            break;
        case MOLLoginRequestType_userInfo:
        {
            NSString *url = @"/user/userInfo/{userId}";
            url = [url stringByReplacingOccurrencesOfString:@"{userId}" withString:self.parameterId];
            return url;
        }
            break;
        case MOLLoginRequestType_userAccount:
        {
            NSString *url = @"/user/accountInfo";
            return url;
        }
            break;
        case MOLLoginRequestType_checkUserAccount:
        {
            NSString *url = @"/getUserInfoByPhone/{phone}";
            url = [url stringByReplacingOccurrencesOfString:@"{phone}" withString:self.parameterId];
            return url;
        }
        case MOLLoginRequestType_videoAuth:
        {
            NSString *url = @"/user/auth";
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
