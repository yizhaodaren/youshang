//
//  MOLConstans.m
//  aletter
//
//  Created by moli-2017 on 2018/7/30.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "MOLConstans.h"
/// 正式服
NSString *const MOL_OFFIC_SERVICE = @"http://www.youshang666.com";
NSString *const MOL_OFFIC_SERVICE_H5 = @"http://www.5youshang.com";
/// 测试服
NSString *const MOL_TEST_SERVICE = @"http://dev.reward.yourmoli.com/";

/// code时间
NSInteger const MOL_CODETIME = 60;

/// 消息时间间隔
NSInteger const MOL_TIME_MARGIN = 180;

/// 请求成功code码 10000
NSInteger const MOL_SUCCESS_REQUEST = 10000;
/// 用户登录成功
NSString *const MOL_SUCCESS_USER_LOGIN = @"LOGIN_SUCCESS";
/// 用户修改信息
NSString *const MOL_SUCCESS_USER_CHANGEINFO = @"CHANGEINFO_SUCCESS";

/// 视频贴的数量
NSInteger const MOL_REQUEST_COUNT_VEDIO = 6;
/// 其他列表的数量
NSInteger const MOL_REQUEST_COUNT_OTHER = 20;


NSString *const MOL_NOTI_COUNT_LIKE = @"MOL_NOTI_COUNT_LIKE";     // 用户被赞
NSString *const MOL_NOTI_COUNT_COMMENT = @"MOL_NOTI_COUNT_COMMENT";     // 用户被评论
NSString *const MOL_NOTI_COUNT_FOCUS = @"MOL_NOTI_COUNT_FOCUS";     // 用户被关注
NSString *const MOL_NOTI_COUNT_PUBLISH_REWARD_PRODUCTION = @"MOL_NOTI_COUNT_PUBLISH_REWARD_PRODUCTION";// 用户悬赏被发布作品
NSString *const MOL_NOTI_COUNT_AT = @"MOL_NOTI_COUNT_AT";// 用户被@

NSString *const MOL_SUCCESS_USER_FOCUS = @"MOL_SUCCESS_USER_FOCUS";
NSString *const MOL_SUCCESS_PUBLISH_PRODUCTION = @"MOL_SUCCESS_PUBLISH_PRODUCTION"; // 用户发布作品
NSString *const MOL_SUCCESS_PUBLISH_REWARD = @"MOL_SUCCESS_PUBLISH_REWARD";     // 用户发布悬赏
NSString *const MOL_SUCCESS_PUBLISHED = @"MOL_SUCCESS_PUBLISHED";     // 用户发布悬赏

NSString *const MOL_SUCCESS_USER_LIKE = @"MOL_SUCCESS_USER_LIKE";     // 用户喜欢作品/悬赏
NSString *const MOL_SUCCESS_USER_LIKE_cancle = @"MOL_SUCCESS_USER_LIKE_cancle";     // 用户喜欢作品/悬赏

NSString *const MOL_NOTI_USER_LIKE = @"MOL_NOTI_USER_LIKE";     // 用户被赞
NSString *const MOL_NOTI_USER_COMMENT = @"MOL_NOTI_USER_COMMENT";     // 用户被评论
NSString *const MOL_NOTI_USER_FOCUS = @"MOL_NOTI_USER_FOCUS";     // 用户被关注
NSString *const MOL_NOTI_USER_PUBLISH_REWARD_PRODUCTION = @"MOL_NOTI_USER_PUBLISH_REWARD_PRODUCTION";// 用户悬赏被发布作品
NSString *const MOL_NOTI_LINK_CHEAKPASTBOARD = @"MOL_NOTI_LINK_CHEAKPASTBOARD";//检测粘贴板是否有外链
/// 用户退出成功
NSString *const MOL_SUCCESS_USER_OUT = @"MOL_SUCCESS_USER_OUT";

NSString *const MOL_ReachableViaWWAN = @"MOL_ReachableViaWWAN";

NSString *const MOL_SEND_COMMENT = @"MOL_SEND_COMMENT"; //用于用户评论数据同步通知

NSString *const MOL_HOME_REFRESH = @"MOL_HOME_REFRESH"; //首页刷新通知
NSString *const MOL_HOME_REFRESHED = @"MOL_HOME_REFRESHED"; //首页刷新通知完成
NSString *const MOL_SUCCESS_SHOWAD = @"MOL_SUCCESS_SHOWAD";  //开屏广告展示完成

