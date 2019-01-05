//
//  CommentCell.h
//  reward
//
//  Created by xujin on 2018/9/21.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeCommentModel;

typedef NS_ENUM(NSInteger, CommentCellEventType) {
    CommentCellEventAvatars,             // 用户头像
    CommentCellEventComment,             // 评论者
    CommentCellEventReviewers,           // 被评论者
    CommentCellEventFavor,               // 点赞
    CommentCellEventUser,                //@用户
};

NS_ASSUME_NONNULL_BEGIN

@protocol CommentCellDelegate <NSObject>

- (void)commentCellEvent:(HomeCommentModel *)modle eventType:(CommentCellEventType)type;




@end

@interface CommentCell : UITableViewCell
@property (nonatomic,weak)id<CommentCellDelegate>delegate;
- (void)commentCell:(HomeCommentModel *)model indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
