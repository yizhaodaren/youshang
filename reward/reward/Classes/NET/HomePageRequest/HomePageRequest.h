//
//  HomePageRequest.h
//  reward
//
//  Created by xujin on 2018/10/8.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLNetRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomePageRequest : MOLNetRequest
/// 获取推荐列表数据
- (instancetype)initRequest_RecommendListParameter:(NSDictionary *)parameter;

/// 获取评论列表数据
- (instancetype)initRequest_CommentListParameter:(NSDictionary *)parameter;

/// 删除评论
- (instancetype)initRequest_DeleteCommentParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId;

/// 评论点赞
- (instancetype)initRequest_CommentFavorParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId;

/// 发布评论
- (instancetype)initRequest_SendCommentParameter:(NSDictionary *)parameter;

/// 举报
- (instancetype)initRequest_ReportParameter:(NSDictionary *)parameter;

/// 关注
- (instancetype)initRequest_AttentionParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId;

/// 赞
- (instancetype)initRequest_PraiseParameter:(NSDictionary *)parameter;

/// 不感兴趣
- (instancetype)initRequest_DisinclineParameter:(NSDictionary *)parameter;

/// 首页关注内容
- (instancetype)initRequest_AttentionContentsParameter:(NSDictionary *)parameter;

/// 首页关注用户
- (instancetype)initRequest_AttentionUsersParameter:(NSDictionary *)parameter;

/// 搜索推荐用户列表
- (instancetype)initRequest_SearchRecommendUsersParameter:(NSDictionary *)parameter;

/// 首页-搜索🔍
- (instancetype)initRequest_SearchParameter:(NSDictionary *)parameter;

/// 删除作品
- (instancetype)initRequest_DeleteStoryParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId;

/// 24小时
- (instancetype)initRequest_HoursParameter:(NSDictionary *)parameter;

/// 作品详情
- (instancetype)initRequest_StoryDetailParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId;

/// 下载地址 POST /play/downLoadUrl
- (instancetype)initRequest_palyDownLoadUrlParameter:(NSDictionary *)parameter;

@end

NS_ASSUME_NONNULL_END
