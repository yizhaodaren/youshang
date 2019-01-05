//
//  HomeCommentModel.h
//  reward
//
//  Created by xujin on 2018/9/22.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseModel.h"
#import "ReplyCommentModel.h"
#import "ContentsItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeCommentModel : MOLBaseModel
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat commentHeight;
@property (nonatomic, copy) NSString *avatar; //评论者头像
@property (nonatomic, assign) NSInteger commentId;
@property (nonatomic, copy) NSString *content; //评论者内容
@property (nonatomic, strong) NSMutableArray <ContentsItemModel *>*contents;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger favorCount;
@property (nonatomic, strong) ReplyCommentModel *replyCommentVO; //回复者信息
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) BOOL isExistReviewed; //存在评论
@property (nonatomic, assign) NSInteger userType; //0 普通用户 1作者 2 悬赏主 3用户自己
@property (nonatomic, assign) NSInteger isFavor; //1点赞 2未点赞

@end

NS_ASSUME_NONNULL_END
