//
//  MOLMessagePageRequest.h
//  reward
//
//  Created by moli-2017 on 2018/10/9.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLNetRequest.h"

#import "MOLVideoOutsideGroupModel.h"
#import "MOLMsgUserGroupModel.h"
#import "MOLMsgAgreeGroupModel.h"
#import "MOLMsgCommentGroupModel.h"
#import "MOLAtUserGroupModel.h"

@interface MOLMessagePageRequest : MOLNetRequest
/// 获取用户评选
- (instancetype)initRequest_getExamineListWithParameter:(NSDictionary *)parameter;

/// 点赞列表
- (instancetype)initRequest_likeListWithParameter:(NSDictionary *)parameter;

/// 评论列表
- (instancetype)initRequest_commentListWithParameter:(NSDictionary *)parameter;

/// 关注列表
- (instancetype)initRequest_focusListWithParameter:(NSDictionary *)parameter;

/// 粉丝列表
- (instancetype)initRequest_fansListWithParameter:(NSDictionary *)parameter;

/// @列表
- (instancetype)initRequest_atListWithParameter:(NSDictionary *)parameter;
@end
