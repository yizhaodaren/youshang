//
//  AppDelegate+MOLNIMService.m
//  reward
//
//  Created by moli-2017 on 2018/9/26.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "AppDelegate+MOLNIMService.h"
#import "MOLHostHead.h"
#import "MOLCustomAttachmentDecoder.h"

@implementation AppDelegate (MOLNIMService)
/// 注册云信
- (void)app_registYX
{

    NSString *appKey        = @"f5fe4acc05208974ed1225c3efe973f3";
    NSString *yxApnsCername = @"rewardDistributionPush";
    
#ifdef MOL_TEST_HOST
    appKey        = @"a14e5c4cf4d5b1fd1924c6fe78c82cb3";
    yxApnsCername      = @"rewardDevelopPush";
//    yxApnsCername     = @"qiyeDevelopPush";
    
#endif
    NIMSDKOption *option    = [NIMSDKOption optionWithAppKey:appKey];
    option.apnsCername      = yxApnsCername;
    option.pkCername = yxApnsCername;

    
    [[NIMSDK sharedSDK] registerWithOption:option];
    
    //需要自定义消息时使用
    [NIMCustomObject registerCustomDecoder:[[MOLCustomAttachmentDecoder alloc]init]];
}
@end
