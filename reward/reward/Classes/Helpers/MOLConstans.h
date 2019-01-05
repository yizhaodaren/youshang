//
//  MOLConstans.h
//  aletter
//
//  Created by moli-2017 on 2018/7/30.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import <UIKit/UIKit.h>
/// 正式服
UIKIT_EXTERN NSString *const MOL_OFFIC_SERVICE;
UIKIT_EXTERN NSString *const MOL_OFFIC_SERVICE_H5;
/// 测试服
UIKIT_EXTERN NSString *const MOL_TEST_SERVICE;

/// 消息时间间隔
UIKIT_EXTERN NSInteger const MOL_TIME_MARGIN;
/// 验证码倒计时
UIKIT_EXTERN NSInteger const MOL_CODETIME;
/// 请求成功code码 10000
UIKIT_EXTERN NSInteger const MOL_SUCCESS_REQUEST;
/// 用户登录成功
UIKIT_EXTERN NSString *const MOL_SUCCESS_USER_LOGIN;         // 用户登录成功通知
/// 用户修改信息
UIKIT_EXTERN NSString *const MOL_SUCCESS_USER_CHANGEINFO;


/// 视频贴的数量
UIKIT_EXTERN NSInteger const MOL_REQUEST_COUNT_VEDIO;
/// 其他列表的数量
UIKIT_EXTERN NSInteger const MOL_REQUEST_COUNT_OTHER;


UIKIT_EXTERN NSString *const MOL_NOTI_COUNT_LIKE;     // 用户被赞
UIKIT_EXTERN NSString *const MOL_NOTI_COUNT_COMMENT;     // 用户被评论
UIKIT_EXTERN NSString *const MOL_NOTI_COUNT_FOCUS;     // 用户被关注
UIKIT_EXTERN NSString *const MOL_NOTI_COUNT_PUBLISH_REWARD_PRODUCTION;// 用户悬赏被发布作品
UIKIT_EXTERN NSString *const MOL_NOTI_COUNT_AT;// 用户被@


/// 自定义通知名字
UIKIT_EXTERN NSString *const MOL_SUCCESS_USER_FOCUS;         // 用户关注/取关成功通知
UIKIT_EXTERN NSString *const MOL_SUCCESS_PUBLISH_PRODUCTION; // 用户发布作品
UIKIT_EXTERN NSString *const MOL_SUCCESS_PUBLISH_REWARD;     // 用户发布悬赏
UIKIT_EXTERN NSString *const MOL_SUCCESS_PUBLISHED; // 用户后跳转页面
UIKIT_EXTERN NSString *const MOL_SUCCESS_USER_LIKE;     // 用户喜欢作品/悬赏
UIKIT_EXTERN NSString *const MOL_SUCCESS_USER_LIKE_cancle;

UIKIT_EXTERN NSString *const MOL_NOTI_USER_LIKE;     // 用户被赞
UIKIT_EXTERN NSString *const MOL_NOTI_USER_COMMENT;     // 用户被评论
UIKIT_EXTERN NSString *const MOL_NOTI_USER_FOCUS;     // 用户被关注
UIKIT_EXTERN NSString *const MOL_NOTI_USER_PUBLISH_REWARD_PRODUCTION;// 用户悬赏被发布作品
UIKIT_EXTERN NSString *const MOL_NOTI_LINK_CHEAKPASTBOARD;// 检测粘贴板是否有外链
/// 用户退出成功
UIKIT_EXTERN NSString *const MOL_SUCCESS_USER_OUT;

/// 流量网络
UIKIT_EXTERN NSString *const MOL_ReachableViaWWAN;

/// 自定义通知名字
UIKIT_EXTERN NSString *const MOL_SUCCESS_USER_FOCUS;         // 用户关注/取关成功通知

/// 推荐评论
UIKIT_EXTERN NSString *const MOL_SEND_COMMENT;         //用于用户评论数据同步通知

UIKIT_EXTERN NSString *const MOL_HOME_REFRESH; //首页刷新

UIKIT_EXTERN NSString *const MOL_HOME_REFRESHED; //首页刷新完成
UIKIT_EXTERN NSString *const MOL_SUCCESS_SHOWAD; //开屏广告展示完成
