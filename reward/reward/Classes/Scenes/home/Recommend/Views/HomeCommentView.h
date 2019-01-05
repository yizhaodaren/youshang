//
//  HomeCommentView.h
//  reward
//
//  Created by xujin on 2018/9/13.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentCell.h"

typedef NS_ENUM(NSUInteger, HomeCommentBusinessType) {
    HomeCommentBusinessType_List,        //获取评论列表
    HomeCommentBusinessType_Delete,      //删除评论
    HomePageBusinessType_SendComment, //发布评论
    HomePageBusinessType_SendComment_Comment, //评论评论
};

@class MOLVideoOutsideModel;
typedef NS_ENUM(NSInteger, HomeCommentViewSelectType) {
    HomeCommentViewSelectOneself,             // 用户自己
    HomeCommentViewSelectOther,               // 非自己
};
@protocol HomeCommentViewDelegate <NSObject>

- (void)homeCommentViewEvent:(HomeCommentModel *)modle eventType:(CommentCellEventType)type;


@end

@interface HomeCommentView : UIView
@property (nonatomic,weak)id<HomeCommentViewDelegate>delegate;

- (void)cottent:(MOLVideoOutsideModel *)model;

@end
