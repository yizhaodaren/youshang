//
//  MOLSwitchManager.m
//  aletter
//
//  Created by moli-2017 on 2018/9/10.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "MOLSwitchManager.h"
#import "MOLAppStartRequest.h"
#import "STSystemHelper.h"
@implementation MOLSwitchManager
+ (instancetype)shareSwitchManager
{
    static MOLSwitchManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil)
        {
            instance = [[MOLSwitchManager alloc] init];
        }
    });
    return instance;
}

//- (void)switch_check:(void(^)(void))resultBlock;
//{
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    NSString *version = [STSystemHelper getApp_version];
//    dic[@"version"] = version;
//    dic[@"platForm"] = @"iOS";
//    MOLAppStartRequest *r = [[MOLAppStartRequest alloc] initRequest_getSwitchActionCommentWithParameter:dic];
//    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
//        
//        if (code == 10000) {
//            NSDictionary *res = request.responseObject;
//            NSDictionary *dic = res[@"resBody"];
//            NSInteger status = [dic[@"isDebug"] integerValue];
//            if (status == 0) {
//                self.normalStatus = 1;
//            }else{
//                self.normalStatus = 0;
//            }
//        }
//        if (resultBlock) {
//            resultBlock();
//        }
//    } failure:^(__kindof MOLBaseNetRequest *request) {
//        
//        if (resultBlock) {
//            resultBlock();
//        }
//        
//    }];
//}
@end
