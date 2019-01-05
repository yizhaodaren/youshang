//
//  MOLUserManager.h
//  reward
//
//  Created by moli-2017 on 2018/9/15.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOLUserModel.h"

#define MOLUserManagerInstance [MOLUserManager shareUserManager]
@interface MOLUserManager : NSObject

+ (instancetype)shareUserManager;
@property (nonatomic, strong) NSString *platUserId;
@property (nonatomic, strong) NSString *platOpenid;
@property (nonatomic, strong) NSString *platUid;
@property (nonatomic, strong) NSString *platToken;
@property (nonatomic, assign) NSInteger platType;

/// 获取用户是否登录
- (BOOL)user_isLogin;

/// 保存用户信息
- (void)user_saveUserInfoWithModel:(MOLUserModel *)user isLogin:(BOOL)login;

/// 获取用户信息
- (MOLUserModel *)user_getUserInfo;

/// 清除用户信息
- (void)user_resetUserInfo;

/// 获取用户id
- (NSString *)user_getUserId;
@end
