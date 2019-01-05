//
//  MOLGlobalManager.m
//  reward
//
//  Created by apple on 2018/9/8.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLGlobalManager.h"
#import "MOLLoginViewController.h"
#import "MOLLoginBindingPhoneViewController.h"
#import "MOLUserModel.h"

@implementation MOLGlobalManager

+ (instancetype)shareGlobalManager
{
    static MOLGlobalManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil)
        {
            instance = [[MOLGlobalManager alloc] init];
            
        }
    });
    return instance;
}

// 登录控制器
- (void)global_modalLogin
{
    MOLLoginViewController *vc = [[MOLLoginViewController alloc] init];
    MOLBaseNavigationController *nav = [[MOLBaseNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [[self global_rootViewControl] presentViewController:nav animated:YES completion:nil];
}

// 绑定手机控制器
- (void)global_modalBindingPhoneWithAnimate:(BOOL)animate
{
    MOLLoginBindingPhoneViewController *vc = [[MOLLoginBindingPhoneViewController alloc] init];
    MOLBaseNavigationController *nav = [[MOLBaseNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [[self global_rootViewControl] presentViewController:nav animated:animate completion:nil];
}

/// 强制退出
- (void)global_loginOut
{
    [MOLUserManagerInstance user_resetUserInfo];
    MOLBaseTabBarController *tab = [self global_rootViewControl];
    [tab.selectedViewController popToRootViewControllerAnimated:NO];
    tab.selectedIndex = 0;
    [[MOLYXManager shareYXManager] yx_exitYX];
}

// 获取根控制器
- (MOLBaseTabBarController *)global_rootViewControl
{
    MOLBaseNavigationController *nav = (MOLBaseNavigationController *)MOLAppDelegateWindow.rootViewController;
    return (MOLBaseTabBarController *)nav.topViewController;
}
- (MOLBaseNavigationController *)global_rootNavigationViewControl
{
    MOLBaseNavigationController *nav = (MOLBaseNavigationController *)MOLAppDelegateWindow.rootViewController;
    return nav;
}

// 获取当前控制器
- (UIViewController *)global_currentViewControl
{
    return [self currentViewController];
}

- (UINavigationController *)global_currentNavigationViewControl
{
    return [self global_currentViewControl].navigationController;
}

// 获取当前控制器
- (UIViewController *) findBestViewController:(UIViewController *)vc {
    if (vc.presentedViewController) {
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}

- (UIViewController *) currentViewController {
    MOLBaseNavigationController *vc = [[MOLGlobalManager shareGlobalManager] global_rootNavigationViewControl];
    return [self findBestViewController:vc];
}

/// 用户自己
- (BOOL)isUserself:(MOLUserModel *)model{
    BOOL bRet =NO;
    if (model && model.userId && model.userId.length>0) {
        
        MOLUserModel *userModel =[[MOLUserManager shareUserManager] user_getUserInfo];
        
        if (userModel && userModel.userId && userModel.userId.length>0) {
            if (userModel.userId.integerValue == model.userId.integerValue) {
                bRet =YES;
            }
        }
    }

    return bRet;
}
@end
