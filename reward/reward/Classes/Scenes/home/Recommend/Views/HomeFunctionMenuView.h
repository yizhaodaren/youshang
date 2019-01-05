//
//  HomeFunctionMenuView.h
//  reward
//
//  Created by xujin on 2018/9/13.
//  Copyright © 2018年 reward. All rights reserved.
//
// 首页-推荐功能组件：发布者头像、赞、发消息、分享

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, HomeFunctionMenuViewType) {
    HomeFunctionMenuViewUndefined,        // 未定义
    HomeFunctionMenuViewAvatars,          // 发布者头像
    HomeFunctionMenuViewAttention,        // 关注
    HomeFunctionMenuViewPraise,           // 赞👍
    HomeFunctionMenuViewComments,         // 评论
    HomeFunctionMenuViewShare,            // 分享
};

typedef void(^HomeFunctionMenuViewBlock)(HomeFunctionMenuViewType type,id parameter,UIButton *sender);

@class MOLVideoOutsideModel;

@interface HomeFunctionMenuView : UIView

@property (nonatomic,weak)UIButton *praiseButton;
@property (nonatomic,strong)NSString *praise;
@property (nonatomic,strong)NSString *comment;
@property (nonatomic,strong)NSString *share;
//当前业务类型 默认未定义
@property (nonatomic,assign) HomeFunctionMenuViewType type;

//返回参数
@property (nonatomic,copy) HomeFunctionMenuViewBlock homeFunctionMenuViewBlock;

- (void)content:(MOLVideoOutsideModel *)model;

- (void)focusHidden:(BOOL)isHidden;

- (void)currentModelSyn:(MOLVideoOutsideModel *)model;

@end
