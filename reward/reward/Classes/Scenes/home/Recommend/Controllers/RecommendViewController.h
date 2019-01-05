//
//  RecommendViewController.h
//  reward
//
//  Created by xujin on 2018/9/12.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseViewController.h"
#import "PLMediaInfo.h"
//typedef NS_ENUM(NSUInteger, HomePageBusinessType) {
//    HomePageBusinessType_HomePageRecommend, //首页-推荐
//    HomePageBusinessType_RewardList,        //悬赏列表作品
//    HomePageBusinessType_RewardDetailList,  //悬赏详情作品
//    HomePageBusinessType_userProduction, //用户作品
//    HomePageBusinessType_userReward, //用户悬赏作品集
//    HomePageBusinessType_userLike, //首页喜欢
//};

@interface RecommendViewController : MOLBaseViewController
<
UIPageViewControllerDelegate,
UIPageViewControllerDataSource
>

/// 统一传递参数
@property (nonatomic, strong) PLMediaInfo *mediaDto;
- (void)reloadController;
- (void)onUIApplication:(BOOL)active;
- (void)refreshHome;

@end
