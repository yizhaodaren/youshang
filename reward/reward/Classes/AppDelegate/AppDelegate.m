//
//  AppDelegate.m
//  reward
//
//  Created by apple on 2018/9/7.
//  Copyright © 2018年 reward. All rights reserved.
//
#import "AppDelegate.h"
#import "AppDelegate+MOLRootController.h"
#import "AppDelegate+MOLAppService.h"
#import "AppDelegate+MOLNIMService.h"
#import "MOLBaseTabBarController.h"
#import "MOLBaseNavigationController.h"
#import <XYIAPKit.h>
#import <XYStoreUserDefaultsPersistence.h>
#import "MOLApplePayManager.h"
#import <IQKeyboardManager.h>
#import "WXApi.h"

#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()

@end
//com.moli.reward.app
//com.qbox.PLShortVideoKitDemo
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /******************************************键盘控制****************************************/
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES; // 控制整个功能是否启用。
    manager.enableAutoToolbar =NO; // 控制是否显示键盘上的工具条
    manager.shouldResignOnTouchOutside = YES;
 
    [AvoidCrash becomeEffective];
    
    /* *********************************** 配置ytk *********************************** */
    YTKNetworkAgent *agent = [YTKNetworkAgent sharedAgent];
    NSSet *acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", @"text/css", nil];
    NSString *keypath = @"jsonResponseSerializer.acceptableContentTypes";
    [agent setValue:acceptableContentTypes forKeyPath:keypath];
    
    /* *********************************** 加载三方 *********************************** */
    [self app_registYX];
    [self app_registQiN];
    [self app_registUmeng];
//    [self app_registBugly];
//    [self app_registJpush:launchOptions];
    
    
    /* *********************************** 加载开屏广告 *********************************** */
    [self requestBannerData];
    
    /* *********************************** 加载manager *********************************** */
    [MOLGlobalManager shareGlobalManager];
    
    /* *********************************** 加载跟控制器 *********************************** */
    [self app_setHomeRootViewController];
    
    //上报日志
    [self app_dataLog];
    
    [[XYStore defaultStore] registerTransactionPersistor:[XYStoreUserDefaultsPersistence shareInstance]];
    
    
    // 获取未完成订单
    NSString *product = [[NSUserDefaults standardUserDefaults] objectForKey:@"MOL_IAP_PRO"];

    // 重新发起订单请求
    if (product.length) {
        [[MOLApplePayManager shareApplePayManager] startServiceRecei:product];
    }
    
    [WXApi startLogByLevel:WXLogLevelNormal logBlock:^(NSString *log) {
        NSLog(@"log : %@", log);
    }];
    
    //向微信注册,发起支付必须注册
    [WXApi registerApp:@"wx34ad04b90532e44c" enableMTA:YES];
    
    // 通知权限
    [self registerRemoteNotification];
    return YES;
}



- (void)registerRemoteNotification
{
    UIApplication *application = [UIApplication sharedApplication];
    // iOS8注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    // iOS8之前注册APNS
    else
    {
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
}


// 读取剪切板
- (void)readShearPlate
{
    NSString *pasteboardStr = [UIPasteboard generalPasteboard].string;
    NSString *code = nil;
    if ([pasteboardStr containsString:@"reward:"]) {
        code = [pasteboardStr stringByReplacingOccurrencesOfString:@"reward:" withString:@""];
    }
    
    if (code.length) {
        [[NSUserDefaults standardUserDefaults] setObject:code forKey:@"reward_invite"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    /// Required - 注册 DeviceToken
    [[NIMSDK sharedSDK] updateApnsToken:deviceToken];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
       [[NSNotificationCenter defaultCenter] postNotificationName:MOL_NOTI_LINK_CHEAKPASTBOARD object:nil];
    [self readShearPlate];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}


// iOS 7、8、9收到本地通知
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
}

// iOS 7、8、9收到远程通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}


- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    completionHandler();
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void(^)())completionHandler
{
    completionHandler();
}

@end
