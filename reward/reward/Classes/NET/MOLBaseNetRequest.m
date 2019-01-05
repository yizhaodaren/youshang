//
//  MOLBaseNetRequest.m
//  aletter
//
//  Created by moli-2017 on 2018/7/31.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "MOLBaseNetRequest.h"
#import "STSystemHelper.h"
#import "MOLHostHead.h"

@implementation MOLBaseNetRequest
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"Content-Type"] = @"application/json; charset=UTF-8";
    dic[@"Content-Encoding"] = @"gzip";
    
    
    MOLUserModel *user = [MOLUserManagerInstance user_getUserInfo];
    
    NSString *version = [STSystemHelper getApp_version];
    NSString *distinctId = [STSystemHelper getDeviceID];
    
    NSString *secretKey = @"PaQhbHy3XbH";
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%lld",(long long)interval];
    
    NSString *str1 = [secretKey mol_md5WithOrigin];
    NSString *str2 = [[NSString stringWithFormat:@"%@%@",version,@"iOS"] mol_md5WithOrigin];
    NSString *str3 = [[NSString stringWithFormat:@"%@%@",distinctId.length?distinctId:@"",user.userId.length?user.userId:@""] mol_md5WithOrigin];
    NSString *ticket = [[NSString stringWithFormat:@"%@%@%@%@",str1,str2,str3,timestamp] mol_md5WithOrigin];
    
    if (user) {
        dic[@"x-user-id"] = user.userId;//@"1"
    }
    
    dic[@"x-version"] = version;
    dic[@"x-platform"] = @"iOS";
    dic[@"x-device-id"] = distinctId;
    dic[@"x-timestamp"] = timestamp;
    dic[@"x-ticket"] = ticket;
    dic[@"x-access-token"] = user.accessToken;
    return dic;
}

/*
 NSString *secretKey = @"PaQhbHy3XbH";
 NSString *version = [STSystemHelper getApp_version];
 NSString *distinctId = [[SensorsAnalyticsSDK sharedInstance] distinctId];
 NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
 NSString *timestamp = [NSString stringWithFormat:@"%lld",(long long)interval];
 NSString *userid = [JAUserInfo userInfo_getUserImfoWithKey:User_id];
 NSString *str1 = [secretKey md5_origin];
 NSString *str2 = [[NSString stringWithFormat:@"%@%@",version,JA_PLATFORM] md5_origin];
 NSString *str3 = [[NSString stringWithFormat:@"%@%@",distinctId.length?distinctId:@"",userid.length?userid:@""] md5_origin];
 NSString *ticket = [[NSString stringWithFormat:@"%@%@%@%@",str1,str2,str3,timestamp] md5_origin];
 
 dic[@"x-version"] = version;
 dic[@"x-device-id"] = distinctId;
 dic[@"x-user-id"] = userid;
 dic[@"x-platform"] = JA_PLATFORM;
 dic[@"x-timestamp"] = timestamp;
 dic[@"x-ticket"] = ticket;
 */

- (YTKRequestSerializerType)requestSerializerType
{
    return YTKRequestSerializerTypeJSON;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
        config.baseUrl = MOL_OFFIC_SERVICE;  // 正式
#ifdef MOL_TEST_HOST
        config.baseUrl = MOL_TEST_SERVICE;  // 测试
#endif
    }
    return self;
}

- (Class)modelClass
{
    return [MOLBaseModel class];
}

- (BOOL)isToast
{
    return YES;
}

- (NSTimeInterval)requestTimeoutInterval
{
    return 10;
}

- (BOOL)statusCodeValidator {
    return YES;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

@end
