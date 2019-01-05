//
//  EDPullRefreshView.h
//  aletter
//
//  Created by moli-2017 on 2018/8/27.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EDPullRefreshView : UIView
@property (nonatomic, assign) CGFloat kMQTableViewContentTopOffset;


/**
 *  初始化上拉/下拉刷新
 *
 *  @param scrollView 在哪个scrollView上显示
 *
 *  @return MQPullRefreshView
 */
- (instancetype)initWithSuperScrollView:(UIScrollView *)scrollView;


/**
 *  开始刷新
 */
- (void)startLoading;

/**
 *  结束刷新
 */
- (void)finishLoading;

/**
 *  更新frame
 */
- (void)updateFrame;

@end
