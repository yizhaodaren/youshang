//
//  MOLAppDelegate+MOLRootController.m
//  aletter
//
//  Created by moli-2017 on 2018/8/13.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "AppDelegate+MOLRootController.h"
#import "MOLHomeViewController.h"
#import "MOLBaseNavigationController.h"
#import "MOLAppStartRequest.h"
#import "MOLLaunchADManager.h"

#import "RewardRequest.h"
#import "MOLBannerSetModel.h"
#import "BannerModel.h"
//获取IP使用
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
//#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@interface AppDelegate()

@end
@implementation AppDelegate (MOLRootController)

/// 设置广告跟控制器
- (void)app_setADRootViewController
{
    
}

//请求开屏广告
-(void)requestBannerData{
//      dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); //创建信号量
//        [[[RewardRequest alloc] initRequest_GreenBannerParameter:@{}] baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
//
//            if (code == MOL_SUCCESS_REQUEST) {
//                if (responseModel) {
//                    // 解析数据
//                    MOLBannerSetModel *mediaInfoList = (MOLBannerSetModel *)responseModel;
//                    if (mediaInfoList.resBody.count > 0) {
//                        [[MOLLaunchADManager shareInstance] setADDate:mediaInfoList.resBody.firstObject];
//
//                    }
//                }
//            }else{
//
//            }
//            [self performSelectorOnMainThread:@selector(goON:) withObject:semaphore waitUntilDone:NO];
//        } failure:^(__kindof MOLBaseNetRequest *request) {
//            [self performSelectorOnMainThread:@selector(goON:) withObject:semaphore waitUntilDone:NO];
//
//        }];
//    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);  //等待
    
    NSString * baseUrl = MOL_OFFIC_SERVICE;  // 正式
#ifdef MOL_TEST_HOST
    baseUrl = MOL_TEST_SERVICE;  // 测试
#endif
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); //创建信号量
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/banner/greenBanner",baseUrl]];
    
    //2.构造Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    //(1)设置为POST请求
    [request setHTTPMethod:@"POST"];

    //(2)超时
    [request setTimeoutInterval:60];

    //(3)设置请求头
    //[request setAllHTTPHeaderFields:nil];

    //(4)设置请求体
//    NSString *bodyStr = @"user_name=admin&user_password=admin";
//    NSData *bodyData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
//
//    //设置请求体
//    [request setHTTPBody:bodyData];

    //3.构造Session
    NSURLSession *session = [NSURLSession sharedSession];

    //4.task
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"dict:%@",dict);
        
        if (dict[@"resBody"]) {
            MOLBannerSetModel *model = [MOLBannerSetModel mj_objectWithKeyValues:dict];
            if (model.resBody.count > 0) {
                [[MOLLaunchADManager shareInstance] setADDate:model.resBody.firstObject];
              }
        }
        dispatch_semaphore_signal(semaphore);   //发送信号
    }];

    [task resume];
    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);  //等待
    
}

-(void)goON:(dispatch_semaphore_t)semaphore{
      dispatch_semaphore_signal(semaphore);   //发送信号
}

/// 设置首页跟控制器
- (void)app_setHomeRootViewController
{
    /* *********************************** 加载主控制器 *********************************** */
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    MOLBaseTabBarController *tabVc = [[MOLBaseTabBarController alloc] init];
    MOLBaseNavigationController *tabNav = [[MOLBaseNavigationController alloc] initWithRootViewController:tabVc];
    tabNav.navigationBar.hidden = YES;

    self.window.rootViewController = tabNav;
    [self.window makeKeyAndVisible];
}
// 上报日志
-(void)app_dataLog{
//    {"platformId":"渠道号","networdType":"连接网络的类型","phoneType":"手机型号","phoneId":"设备ID","edition":"版本号","system":"访问系统","clientPackageName":"客户端包名","type":"手机号、QQ、微信、微博"}
    // 获取当前版本
    NSMutableDictionary *dicinfo = [NSMutableDictionary dictionary];
    NSInteger  isFirstLog =(NSInteger)[[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstLog"];
    if (isFirstLog == 1) {
        dicinfo[@"dataType"] = @(2);//2 app激活
    }else{
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"isFirstLog"];
        dicinfo[@"dataType"] = @(1);//1 app启动
    }
    
    dicinfo[@"platformId"] = @"iOS";
    dicinfo[@"networdType"] = [STSystemHelper getNetworkType];
    dicinfo[@"phoneType"] = [STSystemHelper getDeviceModel];
    dicinfo[@"phoneId"] = [STSystemHelper getDeviceID];
    dicinfo[@"edition"] = [STSystemHelper getApp_version];
    dicinfo[@"system"] = [STSystemHelper getiOSSDKVersion];
    dicinfo[@"clientPackageName"] = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSInteger lastLoginType =(NSInteger)[[NSUserDefaults standardUserDefaults] objectForKey:@"lastLoginType"];
    
    NSString *typeStr = @"";
    switch (lastLoginType) {
        case 1:
            typeStr = @"手机号";
            break;
        case 2:
            typeStr = @"微信";
            break;
        case 3:
            typeStr = @"微博";
            break;
        case 4:
            typeStr = @"qq";
            break;
        case 5:
            typeStr = @"微博";
            break;
        default:
            break;
    }

    dicinfo[@"type"] = typeStr;
    
    MOLAppStartRequest *r = [[MOLAppStartRequest alloc] initRequest_addLogWithParameter:dicinfo];
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
       
    } failure:^(__kindof MOLBaseNetRequest *request) {
        
    }];
}

@end
