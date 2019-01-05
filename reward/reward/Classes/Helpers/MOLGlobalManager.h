//
//  MOLGlobalManager.h
//  reward
//
//  Created by apple on 2018/9/8.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOLBaseViewController.h"
#import "MOLBaseNavigationController.h"
#import "MOLBaseTabBarController.h"

@class MOLUserModel;

@interface MOLGlobalManager : NSObject
+ (instancetype)shareGlobalManager;
// 获取根控制器
- (MOLBaseTabBarController *)global_rootViewControl;
- (MOLBaseNavigationController *)global_rootNavigationViewControl;

// 获取当前控制器
- (UIViewController *)global_currentViewControl;
- (UINavigationController *)global_currentNavigationViewControl;

// 登录控制器
- (void)global_modalLogin;

// 绑定手机控制器
- (void)global_modalBindingPhoneWithAnimate:(BOOL)animate;

/// 强制退出
- (void)global_loginOut;

/// 用户自己
- (BOOL)isUserself:(MOLUserModel *)model;


@end
