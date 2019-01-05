//
//  MOLLoginRequest.h
//  reward
//
//  Created by moli-2017 on 2018/9/23.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLNetRequest.h"
#import "MOLAccountModel.h"

@interface MOLLoginRequest : MOLNetRequest
/// 获取验证码
- (instancetype)initRequest_getCodeWithParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId;

/// 登录(快捷登录、三方登录、密码登录、找回密码登录)
- (instancetype)initRequest_loginWithParameter:(NSDictionary *)parameter;

/// 修改用户信息
- (instancetype)initRequest_changeInfoWithParameter:(NSDictionary *)parameter;

/// 修改密码
- (instancetype)initRequest_changePasswordWithParameter:(NSDictionary *)parameter;

/// 绑定（三方+手机）
- (instancetype)initRequest_bindingWithParameter:(NSDictionary *)parameter;

/// 解除绑定三方
- (instancetype)initRequest_removeBindingWithParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId;

/// 获取用户信息
- (instancetype)initRequest_getUserInfoWithParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId;


/// 用户账户信息
- (instancetype)initRequest_userAccountWithParameter:(NSDictionary *)parameter;

/// 检查是否是注册用户
- (instancetype)initRequest_checkUserAccountWithParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId;

// 视频认证
- (instancetype)initRequest_videoAuthWithParameter:(NSDictionary *)parameter;
@end
