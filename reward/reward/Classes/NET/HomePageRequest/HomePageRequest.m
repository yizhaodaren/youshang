//
//  HomePageRequest.m
//  reward
//
//  Created by xujin on 2018/10/8.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "HomePageRequest.h"
#import "RecommendModel.h"
#import "CommentSetModel.h"
#import "MOLVideoOutsideGroupModel.h"
#import "MOLAttentionUsersModel.h"
#import "MOLMsgUserGroupModel.h"
#import "HomeCommentModel.h"
#import "HoursSetModel.h"
#import "MOLVideoOutsideModel.h"

typedef NS_ENUM(NSUInteger, HomePageRequestType) {
    HomePageRequestType_RecommendList, //推荐列表
    HomePageRequestType_CommentList,   //评论列表
    HomePageRequestType_DeleteComment, //删除评论
    HomePageRequestType_SendComment,   //发布评论
    HomePageRequestType_Report,        //举报
    HomePageRequestType_Attention,     //关注
    HomePageRequestType_Praise,        //赞
    HomePageRequestType_Disincline,    //不感兴趣
    HomePageRequestType_AttentionContents, //首页关注内容
    HomePageRequestType_AttentionUsers,  //首页关注用户
    HomePageRequestType_SearchRecommendUsers, //搜索推荐用户列表
    HomePageRequestType_Search,        //首页-搜索🔍
    HomePageRequestType_Hours,         //24小时
    HomePageRequestType_CommentFavor,         //评论点赞
    HomePageRequestType_DeleteStory, //删除作品
    HomePageRequestType_StoryDetail, //作品详情
    HomePageRequestType_PlayDownLoadUrl, //下载地址
};

@interface HomePageRequest ()
@property (nonatomic, assign) HomePageRequestType type;
@property (nonatomic, strong) NSDictionary *parameter;
@property (nonatomic, strong) NSString *parameterId;
@end

@implementation HomePageRequest
/// 获取推荐列表数据
- (instancetype)initRequest_RecommendListParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type = HomePageRequestType_RecommendList;
        _parameter = parameter;
    }
    
    return self;
}

/// 获取评论列表数据
- (instancetype)initRequest_CommentListParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = HomePageRequestType_CommentList;
        _parameter = parameter;
    }
    
    return self;
}


/// 删除评论
- (instancetype)initRequest_DeleteCommentParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId{
    self = [super init];
    if (self) {
        _type = HomePageRequestType_DeleteComment;
        _parameter = parameter;
        _parameterId =parameterId;
    }
    
    return self;
}

/// 评论点赞
- (instancetype)initRequest_CommentFavorParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId{
    self = [super init];
    if (self) {
        _type = HomePageRequestType_CommentFavor;
        _parameter = parameter;
        _parameterId =parameterId;
    }
    
    return self;
}

/// 发布评论
- (instancetype)initRequest_SendCommentParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = HomePageRequestType_SendComment;
        _parameter = parameter;
    }
    
    return self;
    
}

/// 举报
- (instancetype)initRequest_ReportParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = HomePageRequestType_Report;
        _parameter = parameter;
    }
    
    return self;
}

/// 删除作品
- (instancetype)initRequest_DeleteStoryParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId{
    self = [super init];
    if (self) {
        _type = HomePageRequestType_DeleteStory;
        _parameter = parameter;
        _parameterId =parameterId;
    }
    
    return self;
}

/// 关注
- (instancetype)initRequest_AttentionParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId{
    self = [super init];
    if (self) {
        _type = HomePageRequestType_Attention;
        _parameter = parameter;
        _parameterId =parameterId;
    }
    
    return self;
}

/// 赞
- (instancetype)initRequest_PraiseParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = HomePageRequestType_Praise;
        _parameter = parameter;
    }
    
    return self;
}

/// 不感兴趣
- (instancetype)initRequest_DisinclineParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = HomePageRequestType_Disincline;
        _parameter = parameter;
    }
    
    return self;
}

/// 首页关注内容
- (instancetype)initRequest_AttentionContentsParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = HomePageRequestType_AttentionContents;
        _parameter = parameter;
    }
    
    return self;
}

/// 首页关注用户
- (instancetype)initRequest_AttentionUsersParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = HomePageRequestType_AttentionUsers;
        _parameter = parameter;
    }
    
    return self;
}

/// 搜索推荐用户列表
- (instancetype)initRequest_SearchRecommendUsersParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = HomePageRequestType_SearchRecommendUsers;
        _parameter = parameter;
    }
    
    return self;
}

///search/recommendUsers   搜索推荐用户列表

/// 首页-搜索🔍
- (instancetype)initRequest_SearchParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = HomePageRequestType_Search;
        _parameter = parameter;
    }
    
    return self;
}

/// 24小时
- (instancetype)initRequest_HoursParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = HomePageRequestType_Hours;
        _parameter = parameter;
    }
    
    return self;
}

/// 作品详情
- (instancetype)initRequest_StoryDetailParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId{
    self = [super init];
    if (self) {
        _type = HomePageRequestType_StoryDetail;
        _parameter = parameter;
        _parameterId =parameterId;
    }
    
    return self;
}

/// 下载地址 POST /play/downLoadUrl
- (instancetype)initRequest_palyDownLoadUrlParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = HomePageRequestType_PlayDownLoadUrl;
        _parameter = parameter;
    }
    
    return self;
}


- (id)requestArgument
{
    return _parameter;
}

- (Class)modelClass
{
    if (_type ==  HomePageRequestType_RecommendList || _type == HomePageRequestType_AttentionContents) {
        return [MOLVideoOutsideGroupModel class];
    }else if (_type == HomePageRequestType_CommentList){
        return [CommentSetModel class];
    }else if (_type == HomePageRequestType_AttentionUsers ||
              _type == HomePageRequestType_Search ||
              _type == HomePageRequestType_SearchRecommendUsers){
        return [MOLMsgUserGroupModel class];
    }else if (_type == HomePageRequestType_CommentFavor || _type == HomePageRequestType_SendComment){
        return [HomeCommentModel class];
    }else if (_type == HomePageRequestType_Hours){
        return [HoursSetModel class];
    }else if (_type == HomePageRequestType_StoryDetail){
        return [MOLVideoOutsideModel class];
    }
    return [MOLBaseModel class];
}

- (NSString *)requestUrl
{
    switch (_type) {
        case HomePageRequestType_RecommendList:
        {
            NSString *url = @"/content/recommends";
            return url;
        }
            break;
        case HomePageRequestType_CommentList:
        {
            NSString *url = @"/comment/comments";
            return url;
        }
            break;
        case HomePageRequestType_DeleteComment:
        {
            NSString *url = @"/comment/deleteComment/{id}";
            url = [url stringByReplacingOccurrencesOfString:@"{id}" withString:self.parameterId];
            return url;
        }
            break;
        case HomePageRequestType_SendComment:
        {
            NSString *url = @"/comment/publish";
            return url;
        }
            break;
        case HomePageRequestType_Praise:
        {
            NSString *url = @"/record/like";
            return url;
        }
            break;
        case HomePageRequestType_Report:
        {
            NSString *url = @"/report/add";
            return url;
        }
            break;
        case HomePageRequestType_AttentionContents:
        {
            NSString *url = @"/content/attentionContents";
            return url;
        }
            break;
        case HomePageRequestType_AttentionUsers:
        {
            NSString *url = @"/content/attentionUsers";
            return url;
        }
            break;
        case HomePageRequestType_Search:
        {
            NSString *url = @"/search/info";
            return url;
        }
            break;
        case HomePageRequestType_CommentFavor:
        {
            NSString *url = @"/record/likeComment/{commentId}";
            url = [url stringByReplacingOccurrencesOfString:@"{commentId}" withString:self.parameterId];
            return url;
        }
            break;
        case HomePageRequestType_DeleteStory:
        {
            NSString *url = @"/story/deleteStory/{id}";
            url = [url stringByReplacingOccurrencesOfString:@"{id}" withString:self.parameterId];
            return url;
        }
            break;
        case HomePageRequestType_Hours:
        {
            NSString *url = @"/dynamic/dynamicInfos";
            return url;
        }
            break;

        case HomePageRequestType_StoryDetail:
        {
            NSString *url = @"/story/storyInfo/{storyId}";
            url = [url stringByReplacingOccurrencesOfString:@"{storyId}" withString:self.parameterId];
            return url;
        }
            break;
        case HomePageRequestType_SearchRecommendUsers:
        {
            NSString *url = @"/search/recommendUsers";
            return url;
        }
            break;
        case HomePageRequestType_PlayDownLoadUrl:
        {
            NSString *url = @"/play/downLoadUrl";
            return url;
        }
            break;
            
        default:
            return @"";
            break;
    }
}

- (NSString *)parameterId {
    if (!_parameterId.length) {
        return @"";
    }
    return _parameterId;
}
@end
