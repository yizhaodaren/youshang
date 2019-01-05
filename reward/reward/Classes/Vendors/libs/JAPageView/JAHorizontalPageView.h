//
//  JAHorizontalPageView.h
//  PageView
//
//  Created by 刘宏亮 on 2017/12/1.
//  Copyright © 2017年 刘宏亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JACollectionView.h"
@class JAHorizontalPageView;
@protocol JAHorizontalPageViewDelegate <NSObject>

// 左右分页数
- (NSInteger)numberOfSectionPageView:(JAHorizontalPageView *)view;
// 返回每个分页的scrollview
- (UIScrollView *)horizontalPageView:(JAHorizontalPageView *)pageView viewAtIndex:(NSInteger)index;

// 设置定位的距离
- (CGFloat)topHeightInPageView:(JAHorizontalPageView *)pageView;

// 设置头部高度
- (CGFloat)headerHeightInPageView:(JAHorizontalPageView *)pageView;
- (UIView *)headerViewInPageView:(JAHorizontalPageView *)pageView;

// 滚动的偏移量（相对位置）
- (void)horizontalPageView:(JAHorizontalPageView *)pageView scrollTopOffset:(CGFloat)offset;
@end

@interface JAHorizontalPageView : UIView

@property (nonatomic, weak) UIScrollView *currentScrollView;                   // 当前的子列表页

@property (nonatomic, assign) BOOL needMiddleRefresh;  // 是否有中间刷新（默认NO）

@property (nonatomic, assign) BOOL hasNavigator;   // 是否有导航条（默认NO）
@property (nonatomic, strong) JACollectionView *horizontalCollectionView;       // 横向的collectionview
@property (nonatomic, assign) BOOL needHeadGestures;   // 是否需要手势
@property (nonatomic, assign) BOOL isDragging;          //                备用（不要设置）
@property (nonatomic, assign) CGFloat maxCacheCount;   // 最大缓存页面数据   备用（不要啊设置）

// 初始化
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<JAHorizontalPageViewDelegate>)delegate;

// 滚动到某个视图
- (void)scrollToIndex:(NSInteger)pageIndex;
- (void)scrollToIndex:(NSInteger)pageIndex animation:(BOOL)animate;

// 是否可左右滚动
- (void)scrollEnable:(BOOL)enable;

// 当前页面上的scrollview
- (UIScrollView *)currentScrollViewAtIndex:(NSInteger)index;

// 页面刷新
- (void)reloadPage;

@end
