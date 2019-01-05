//
//  MOLAppDelegate+MOLAppService.m
//  aletter
//
//  Created by moli-2017 on 2018/8/13.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "AppDelegate+MOLAppService.h"
#import "STSystemHelper.h"
#import <UserNotifications/UserNotifications.h>
#import "MOLSystemManager.h"
#import <PLShortVideoKit/PLShortVideoKit.h>
#import "MOLHostHead.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiManager.h"

#define UM_KEY  @"5b9cce8ef43e4858460002f3"
#define UM_WX_KEY @"wx34ad04b90532e44c"
#define UM_WX_SER @"cbffb6f98f1c19391ce2e1a7faece99b"
#define UM_WB_KEY @"2472332550"
#define UM_WB_SER @"644c870f723f551e284620d40ce29112"
#define UM_QQ_KEY @"1107794755"

#define BUGLY_KEY @" "  

#define JPUSH_KEY @" "

#define JPUSH_KEY_DEV @" "

@implementation AppDelegate (MOLAppService)

#pragma mark - 友盟
/// 注册友盟
- (void)app_registUmeng
{
    // 三方分享、登录
    [self Umeng_confitUShareSettings];
    [self Umeng_configUSharePlatforms];
    
    // 友盟统计
    [self Umeng_configAnalyticsPlatforms];
}

- (void)Umeng_configAnalyticsPlatforms
{
    NSInteger platformType = [MOLSystemManager system_platformType];
    if (platformType == UIDeviceSimulator ||
        platformType == UIDeviceSimulatoriPhone ||
        platformType == UIDeviceSimulatoriPad ||
        platformType == UIDeviceSimulatorAppleTV) {
        // 模拟器不初始化友盟统计
        return;
    }
    
    [UMConfigure initWithAppkey:UM_KEY channel:@"App Store"];
}

- (void)Umeng_configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:UM_WX_KEY appSecret:UM_WX_SER redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    /*设置QQ平台的appID*/
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:UM_QQ_KEY  appSecret:@"KAOFNBSWrb2wKDaZ" redirectURL:@"http://mobile.umeng.com/social"];// 3NKle44axynkGeHR
    
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:UM_WB_KEY  appSecret:UM_WB_SER redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
}

- (void)Umeng_confitUShareSettings
{
    [[UMSocialManager defaultManager] openLog:NO];
    [[UMSocialManager defaultManager] setUmSocialAppkey:UM_KEY];
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}

/// 友盟的回调
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
//        BOOL canHandleURL = [Pingpp handleOpenURL:url withCompletion:nil];
//        return canHandleURL;
        
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
            }];
            return YES;
        }else{
            return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
        }
    }
    return result;
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url options:options];
    
    if (!result) {
//        BOOL canHandleURL = [Pingpp handleOpenURL:url withCompletion:nil];
//        return canHandleURL;
        
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
            }];
            
            return YES;
            
        }else{
            return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
        }
    }
    
    return result;
}

#pragma mark - bugly
/// 注册bugly
- (void)app_registBugly
{
    MOLUserModel *user = [MOLUserManagerInstance user_getUserInfo];
    BuglyConfig * config = [[BuglyConfig alloc] init];
    config.reportLogLevel = BuglyLogLevelWarn;
    config.blockMonitorEnable = YES;
    config.blockMonitorTimeout = 2;
    config.unexpectedTerminatingDetectionEnable = YES;
    config.version = [STSystemHelper getApp_version];
    config.deviceIdentifier = [NSString stringWithFormat:@"%@ %@",[STSystemHelper iphoneNameAndVersion], [[UIDevice currentDevice] systemVersion]];
    if (user.userId.length) {
        [Bugly setUserIdentifier:user.userId];
    }
    [Bugly startWithAppId:BUGLY_KEY config:config];
}

#pragma mark - 七牛
/// 注册七牛
- (void)app_registQiN
{
    [PLShortVideoKitEnv initEnv];
    [PLShortVideoKitEnv setLogLevel:PLShortVideoLogLevelOff];
}

#pragma mark - 极光
/// 注册极光
- (void)app_registJpush:(NSDictionary *)launchOptions
{
    // 初始化APNS
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    BOOL isP = NO;
#ifdef MOL_TEST_HOST
    isP = YES;
#endif
    // 初始化极光push
    NSString *jpushKey = JPUSH_KEY;
    // 获取bundleId
    NSString *bundleId = [STSystemHelper getApp_bundleid];
    if ([bundleId containsString:@"Dev"]) {
        jpushKey = JPUSH_KEY_DEV;
    }
    [JPUSHService setupWithOption:launchOptions appKey:jpushKey
                          channel:MOL_APPStore
                 apsForProduction:isP
            advertisingIdentifier:nil];
    [JPUSHService setLogOFF];
    
    if (iOS10) {}else{  // ios10 以下的系统kill掉app收到推送后走这
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
        if (userInfo[@"_j_business"]) {
            // 处理极光push消息
        }
    }
    
    // 极光透传消息
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}

// 极光透传
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    // 解析服务器数据
    NSDictionary *dic = notification.userInfo;
    
    // msgType :1系统推送 2评论推送 3点赞推送 4私聊推送5关闭会话 6重新发起会话
    // type    : chat /
    if (dic[@"_j_msgid"]) {
        
    }
    
}

#pragma mark - JPUSHRegisterDelegate
// iOS 10 Support 前台
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler
{
    NSDictionary * userInfo = notification.request.content.userInfo;

    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [self push_receiveService:userInfo];
    }
    
}

// iOS 10 Support 后台 或者 kill掉
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [self push_receiveService:userInfo];
    }
    
    completionHandler();  // 系统要求执行这个方法
}

// iOS 7、8、9收到远程通知（后台）
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    if (application.applicationState == UIApplicationStateActive) {  // 前台
        
    }else{   // 后台
        
    }
    [self push_receiveService:userInfo];
}

// 处理服务器消息体
- (void)push_receiveService:(NSDictionary *)userInfo{}
@end
