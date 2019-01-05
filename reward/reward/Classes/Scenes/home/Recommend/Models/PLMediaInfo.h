//
//  PLMediaInfo.h
//  NiuPlayer
//
//  Created by hxiongan on 2018/3/7.
//  Copyright © 2018年 hxiongan. All rights reserved.
//
//  用于各业务功能模块复用首页-推荐类，传递数据模型  统一管理


#import <Foundation/Foundation.h>
#import "MOLBaseModel.h"
typedef NS_ENUM(NSUInteger, HomePageBusinessType) {
    HomePageBusinessType_HomePageRecommend, //首页-推荐
    HomePageBusinessType_RewardList,        //悬赏列表作品
    HomePageBusinessType_RewardDetailList,  //悬赏详情下的作品集
    HomePageBusinessType_userProduction, //用户作品集
    HomePageBusinessType_sameMusicUserProduction,//相同音乐下的作品集
    HomePageBusinessType_userReward, //用户悬赏作品集
    HomePageBusinessType_userLike, //用户喜欢作品集
    HomePageBusinessType_Hours, //24HOT
    HomePageBusinessType_RewardDetail, //悬赏详情
    HomePageBusinessType_StoryDetail,  //作品详情
};

@interface PLMediaInfo : MOLBaseModel

//当前播放视频
@property (nonatomic, assign) NSInteger index;

//视频播放源
@property (nonatomic, strong) NSMutableArray *dataSource;

//当前页码
@property (nonatomic, assign) NSInteger pageNum;

//请求数量
@property (nonatomic, assign) NSInteger pageSize;

//用户id
@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) NSString *rewardId;


//同一音乐的作品所需要的字段
@property (nonatomic, assign) NSInteger musicID;//音乐ID
@property (nonatomic, assign) NSInteger sortType;//排序方式


//业务功能模块
@property (nonatomic,assign)HomePageBusinessType businessType;

@end
