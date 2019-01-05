//
//  MOLAppStartRequest.h
//  reward
//
//  Created by moli-2017 on 2018/10/23.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLNetRequest.h"

@interface MOLAppStartRequest : MOLNetRequest

/// 获取版本更新
- (instancetype)initRequest_versionCheckWithParameter:(NSDictionary *)parameter;

/// 获取开关接口
- (instancetype)initRequest_getSwitchActionCommentWithParameter:(NSDictionary *)parameter;

//上报日志
- (instancetype)initRequest_addLogWithParameter:(NSDictionary *)parameter;
@end
