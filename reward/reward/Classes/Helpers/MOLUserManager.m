//
//  MOLUserManager.m
//  reward
//
//  Created by moli-2017 on 2018/9/15.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLUserManager.h"

@implementation MOLUserManager

+ (instancetype)shareUserManager
{
    static MOLUserManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil)
        {
            instance = [[MOLUserManager alloc] init];
            
        }
    });
    return instance;
}

- (BOOL)user_isLogin
{
    BOOL status = [[NSUserDefaults standardUserDefaults] boolForKey:@"user_loginStatus"];
    MOLUserModel *user = [self user_getUserInfo];
    return status && user.userId.length;
}

/// 保存用户信息
- (void)user_saveUserInfoWithModel:(MOLUserModel *)user isLogin:(BOOL)login
{
    MOLUserModel *oldUser = [self user_getUserInfo];
    if (!user.accessToken.length && oldUser.userId.length && oldUser.accessToken.length) {
        user.accessToken = oldUser.accessToken;
    }
    if (login) {
        [[NSUserDefaults standardUserDefaults] setBool:login forKey:@"user_loginStatus"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *alia = [NSString stringWithFormat:@"yfx%@",user.userId];
        [JPUSHService setAlias:alia completion:nil seq:0];
    }

    NSString *filename = [NSString mol_creatNSDocumentFileWithFileName:@"mol_userInfo"]; // 用户异常退出的bug
    BOOL status = [NSKeyedArchiver archiveRootObject:user toFile:filename];
    if (!status) {
        [self user_resetUserInfo];
    }else{
        if (login) {
            [[NSNotificationCenter defaultCenter] postNotificationName:MOL_SUCCESS_USER_LOGIN object:nil];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:MOL_SUCCESS_USER_CHANGEINFO object:nil];
        }
    }
}

/// 获取用户信息
- (MOLUserModel *)user_getUserInfo
{
    NSString *filename = [NSString mol_creatNSDocumentFileWithFileName:@"mol_userInfo"]; // 用户异常退出的bug
    // 读取本地缓存数据
    MOLUserModel *user = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    if (user) {
        return user;
    }else{
        return nil;
    }
}

/// 获取用户id
- (NSString *)user_getUserId
{
    MOLUserModel *user = [self user_getUserInfo];
    return user.userId;
}

/// 清除用户信息
- (void)user_resetUserInfo
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_lastUserName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_loginStatus"];
    [JPUSHService deleteAlias:nil seq:0];
    NSString *filename = [NSString mol_creatNSDocumentFileWithFileName:@"mol_userInfo"];  // 用户异常退出的bug
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL bRet = [fileMgr fileExistsAtPath:filename];
    if (bRet) {
        NSError *err;
        [fileMgr removeItemAtPath:filename error:&err];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MOL_SUCCESS_USER_OUT object:nil];
}
@end
