//
//  MOLActionRequest.h
//  reward
//
//  Created by moli-2017 on 2018/10/11.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLNetRequest.h"

@interface MOLActionRequest : MOLNetRequest

/// 关注 / 取关
- (instancetype)initRequest_focusActionWithParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId;

/// 查询关注关系
- (instancetype)initRequest_relationActionWithParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId;

/// 派发红包
- (instancetype)initRequest_payoutActionWithParameter:(NSDictionary *)parameter;

/// 举报用户
- (instancetype)initRequest_reportUserActionWithParameter:(NSDictionary *)parameter;

/// 拉黑用户
- (instancetype)initRequest_blackUserActionWithParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId;
@end
