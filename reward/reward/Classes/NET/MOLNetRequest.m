//
//  MOLNetRequest.m
//  aletter
//
//  Created by moli-2017 on 2018/7/31.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "MOLNetRequest.h"

@implementation MOLNetRequest

- (void)baseNetwork_startRequestWithcompletion:(JARequestSuccessBlock)completion failure:(JARequestFaileBlock)failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSLog(@"%@ \n %@",request,request.responseObject);
        NSInteger code = [request.responseObject[@"code"] integerValue];
        if (code == 11111 && [MOLUserManagerInstance user_isLogin]) {
            [[MOLGlobalManager shareGlobalManager] global_loginOut];
            [[MOLGlobalManager shareGlobalManager] global_modalLogin];
            return;
        }else if(code == 11111){
            return;
        }
        
        Class modelClass = self.modelClass;
        // 获取数据类型
        id resBody = request.responseObject[@"resBody"];
        if (resBody) {
            if ([resBody isKindOfClass:[NSArray class]]) {   // 数组
                MOLBaseModel *model = [modelClass mj_objectWithKeyValues:request.responseObject];
                if (completion) {
                    completion(request,model,model.code,model.message);
                }
            }else if ([resBody isKindOfClass:[NSDictionary class]]){   // 字典
                MOLBaseModel *model = [modelClass mj_objectWithKeyValues:resBody];
                model.code = [request.responseObject[@"code"] integerValue];
                model.message = request.responseObject[@"message"];
                model.total = [request.responseObject mol_jsonInteger:@"total"];
                if (completion) {
                    completion(request,model,model.code,model.message);
                }
            }else{
                MOLBaseModel *model = [modelClass mj_objectWithKeyValues:request.responseObject];
                if (completion) {
                    completion(request,model,model.code,model.message);
                }
            }
        }else{  // 没有 resBody
            MOLBaseModel *model = [modelClass mj_objectWithKeyValues:request.responseObject];
            if (completion) {
                completion(request,model,model.code,model.message);
            }
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSLog(@"%@ \n %@",request, request.error.localizedDescription);
        if (failure) {
            failure(request);
        }
        
        if (self.isToast) {
            [MBProgressHUD showMessageAMoment:@"网络抽搐了"];
        }
    }];
    
    
}
@end
