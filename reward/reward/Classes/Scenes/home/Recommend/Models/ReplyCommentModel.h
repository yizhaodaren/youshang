//
//  ReplyCommentModel.h
//  reward
//
//  Created by xujin on 2018/10/18.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class ContentsItemModel;
@interface ReplyCommentModel : MOLBaseModel
@property (nonatomic, strong) NSMutableArray <ContentsItemModel *>*contents;
@property (nonatomic, copy) NSString *content; //评论者内容
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, assign) CGFloat replyCommentHeight;

@end

NS_ASSUME_NONNULL_END
