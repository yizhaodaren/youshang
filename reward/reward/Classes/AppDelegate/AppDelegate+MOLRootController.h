//
//  MOLAppDelegate+MOLRootController.h
//  aletter
//
//  Created by moli-2017 on 2018/8/13.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (MOLRootController)

/// 设置广告跟控制器
- (void)app_setADRootViewController;

/// 设置首页跟控制器
- (void)app_setHomeRootViewController;
//请求开屏广告
-(void)requestBannerData;

// 上报日志
-(void)app_dataLog;
@end
