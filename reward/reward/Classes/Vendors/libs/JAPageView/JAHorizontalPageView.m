//
//  JAHorizontalPageView.m
//  PageView
//
//  Created by 刘宏亮 on 2017/12/1.
//  Copyright © 2017年 刘宏亮. All rights reserved.
//

#import "JAHorizontalPageView.h"
#import "DynamicItem.h"

@interface JAHorizontalPageView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *headerView;                               // 头部视图
@property (nonatomic, strong) NSMutableArray <UIScrollView *>*contentViewArray;  // 子列表页数组
//@property (nonatomic, strong) JACollectionView *horizontalCollectionView;       // 横向的collectionview

@property (nonatomic, assign) BOOL isScroll;                             // 是否左右滚动
@property (nonatomic, assign) BOOL isSwitching;
@property (nonatomic, assign) CGPoint contentOffset;

@property (nonatomic, assign) CGFloat topHeight;
@property (nonatomic, assign) CGFloat headerViewHeight;       // 头部高度
@property (nonatomic, strong) NSLayoutConstraint *headerOriginYConstraint;
@property (nonatomic, strong) NSLayoutConstraint *headerSizeHeightConstraint;


@property (nonatomic, strong) UIView             *currentTouchView;
@property (nonatomic, assign) CGPoint            currentTouchViewPoint;
@property (nonatomic, strong) UIView             *currentTouchSubSegment;

/*
 * 用于模拟scrollview的滚动
 */
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIDynamicItemBehavior *inertialBehavior;

/*
 *  代理
 */
@property (nonatomic, weak) id <JAHorizontalPageViewDelegate> delegate;
@end

@implementation JAHorizontalPageView

static void *HHHorizontalPagingViewScrollContext = &HHHorizontalPagingViewScrollContext;
static void *HHHorizontalPagingViewInsetContext  = &HHHorizontalPagingViewInsetContext;
static void *HHHorizontalPagingViewPanContext    = &HHHorizontalPagingViewPanContext;
static NSString *pagingCellIdentifier            = @"PagingCellIdentifier";
static NSInteger pagingScrollViewTag             = 2000;

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<JAHorizontalPageViewDelegate>)delegate
{
    if (self = [super initWithFrame:frame]) {
        self.delegate = delegate;
        // UICollectionView
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing          = 0.0;
        layout.minimumInteritemSpacing     = 0.0;
        layout.scrollDirection             = UICollectionViewScrollDirectionHorizontal;
        self.horizontalCollectionView = [[JACollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        
        // 应当为每一个ScrollView 注册一个唯一的Cell
        NSInteger section = [self.delegate numberOfSectionPageView:self];
        [self registCellForm:0 to:section];
        
        self.horizontalCollectionView.backgroundColor                = [UIColor clearColor];
        self.horizontalCollectionView.dataSource                     = self;
        self.horizontalCollectionView.delegate                       = self;
        self.horizontalCollectionView.pagingEnabled                  = YES;
        self.horizontalCollectionView.showsHorizontalScrollIndicator = NO;
        self.horizontalCollectionView.scrollsToTop                   = NO;
//        self.horizontalCollectionView.panGestureRecognizer.delegate = self;
        self.horizontalCollectionView.bounces = NO;
        // iOS10 上将该属性设置为 NO，就会预取cell了
        if([self.horizontalCollectionView respondsToSelector:@selector(setPrefetchingEnabled:)]) {
            if (@available(iOS 10.0, *)) {
                self.horizontalCollectionView.prefetchingEnabled = NO;
            }
        }
        if (@available(iOS 11.0, *)) {
            self.horizontalCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        UICollectionViewFlowLayout *tempLayout = (id)self.horizontalCollectionView.collectionViewLayout;
        tempLayout.itemSize = self.horizontalCollectionView.frame.size;
        [self addSubview:self.horizontalCollectionView];
        [self configureHeaderView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(releaseCache) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
    }
    
    return self;
}

// 注册cell
- (void)registCellForm:(NSInteger)form to:(NSInteger)to{
    
    for (NSInteger i = form; i < to; i ++) {
        [self.horizontalCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:[self cellReuseIdentifierForIndex:i]];
    }
}

- (NSString *)cellReuseIdentifierForIndex:(NSInteger)aIndex{
    return [NSString stringWithFormat:@"%@_%tu",pagingCellIdentifier,aIndex];
}

#pragma mark - 刷新界面
- (void)reloadPage
{
    self.topHeight                   = [self.delegate topHeightInPageView:self];
    self.headerView                  = [self.delegate headerViewInPageView:self];
    self.headerViewHeight            = [self.delegate headerHeightInPageView:self];
    [self configureHeaderView];
    // 防止该section 是计算得出会改变导致后面崩溃
    NSInteger section = [self.delegate numberOfSectionPageView:self];
    [self registCellForm:0 to:section];
    [self.horizontalCollectionView reloadData];
}

#pragma mark - 设置头部
- (void)configureHeaderView {
    [self.headerView removeFromSuperview];
    if(self.headerView) {
        
        [self.headerView removeConstraint:self.headerSizeHeightConstraint];

        self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.headerView];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        self.headerOriginYConstraint = [NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        [self addConstraint:self.headerOriginYConstraint];

        self.headerSizeHeightConstraint = [NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:self.headerViewHeight];
        [self.headerView addConstraint:self.headerSizeHeightConstraint];
        [self addGestureRecognizerAtHeaderView];
        
        [self.currentScrollView setContentInset:UIEdgeInsetsMake(self.headerViewHeight, 0., self.currentScrollView.contentInset.bottom, 0.)];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.delegate numberOfSectionPageView:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    self.isSwitching = YES;
    NSString* key = [self cellReuseIdentifierForIndex:indexPath.row];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:key forIndexPath:indexPath];
    
    // 获取scrollview
    UIScrollView *v = [self currentScrollViewAtIndex:indexPath.row];
    
    // 只有在cell未添加scrollView时才添加，让以下代码只在需要时执行
    if (cell.contentView.tag != v.tag) {
        
        cell.backgroundColor = [UIColor clearColor];
        for(UIView *v in cell.contentView.subviews) {
            [v removeFromSuperview];
        }
        cell.tag = v.tag;
        UIViewController *vc = [self viewControllerForView:v];
        // 如果为空表示 v还没有响应者，在部分机型上出现该问题，情况不明先这么看看
        [cell.contentView addSubview:vc.view];
        cell.tag = v.tag;
        
        vc.view.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:vc.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:vc.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:vc.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:vc.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        
        [cell layoutIfNeeded];
    }
    
    self.currentScrollView = v;
    [self adjustOffsetContentView:v];
    return cell;
}

#pragma mark - 设置scrollview的偏移量
/// 设置将要展示的scrollview的偏移量
- (void)adjustOffsetContentView:(UIScrollView *)scrollView {
    self.isSwitching = YES;
    
    CGFloat headerViewDisplayHeight = self.headerViewHeight + self.headerView.frame.origin.y;
    [scrollView layoutIfNeeded];
    
    if (headerViewDisplayHeight != self.topHeight) {   // 不在最顶
        [scrollView setContentOffset:CGPointMake(0, -headerViewDisplayHeight)];
    }else if(scrollView.contentOffset.y < -self.topHeight) {
        [scrollView setContentOffset:CGPointMake(0, -headerViewDisplayHeight)];
    }

    if ([scrollView.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [scrollView.delegate scrollViewDidEndDragging:scrollView willDecelerate:NO];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0)), dispatch_get_main_queue(), ^{
        self.isSwitching = NO;
    });
}

#pragma mark - 初始化时设置scrollview的位置 以及 创建监听
/// 设置每个列表分页的偏移量 并监听滚动的手势状态
- (void)configureContentView:(UIScrollView *)scrollView{
    [scrollView  setContentInset:UIEdgeInsetsMake(self.headerViewHeight, 0., scrollView.contentInset.bottom, 0.)];
    scrollView.alwaysBounceVertical = YES;
//    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(self.headerViewHeight, 0., scrollView.contentInset.bottom, 0.);
    scrollView.contentOffset = CGPointMake(0., -self.headerViewHeight);
    [scrollView.panGestureRecognizer addObserver:self forKeyPath:NSStringFromSelector(@selector(state)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:&HHHorizontalPagingViewPanContext];
    [scrollView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:&HHHorizontalPagingViewScrollContext];
    [scrollView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentInset)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:&HHHorizontalPagingViewInsetContext];
    if (scrollView == nil) {
        self.currentScrollView = scrollView;
    }
}

#pragma mark - scrollview的代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    self.isScroll = YES;
    CGFloat offsetpage = scrollView.contentOffset.x/[[UIScreen mainScreen] bounds].size.width;
    CGFloat py = fabs((int)offsetpage - offsetpage);
    if ( py <= 0.3 || py >= 0.7) {
        return;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (!self.isScroll) { // 是否左右滚动  防止上下滚动的触发
        return;
    }
    
    self.isScroll = NO;
    NSInteger currentPage = scrollView.contentOffset.x/[[UIScreen mainScreen] bounds].size.width;
    [self didSwitchPageToIndex:currentPage];
}

#pragma mark - 监听方法scrollview（列表页）的手势监听
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(__unused id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if(context == &HHHorizontalPagingViewPanContext) {
        
//        self.isDragging = YES;
//        self.horizontalCollectionView.scrollEnabled = YES;
//        UIGestureRecognizerState state = [change[NSKeyValueChangeNewKey] integerValue];
//        //failed说明是点击事件
//        if(state == UIGestureRecognizerStateFailed) {
//            if(self.currentTouchSubSegment) {
//                [self segmentViewEvent:self.currentTouchSubSegment];
//            }else if(self.currentTouchView) {
//                [self.currentTouchView viewWasTappedPoint:self.currentTouchViewPoint];
//            }
//            self.currentTouchView = nil;
//            self.currentTouchSubSegment = nil;
//        }else if (state == UIGestureRecognizerStateCancelled || state == UIGestureRecognizerStateEnded) {
//            self.isDragging = NO;
//        }
        
    }else if (context == &HHHorizontalPagingViewScrollContext) {
        
        self.currentTouchView = nil;
        self.currentTouchSubSegment = nil;
        if (self.isSwitching) {
            return;
        }
        
        // 触发如果不是当前 ScrollView 不予响应
        if (object != self.currentScrollView) {
            return;
        }
        
        CGFloat oldOffsetY          = [change[NSKeyValueChangeOldKey] CGPointValue].y;
        CGFloat newOffsetY          = [change[NSKeyValueChangeNewKey] CGPointValue].y;
        CGFloat deltaY              = newOffsetY - oldOffsetY;
        
        CGFloat headerViewHeight    = self.headerViewHeight;
        CGFloat headerDisplayHeight = self.headerViewHeight+self.headerOriginYConstraint.constant;
        
        CGFloat py = 0;
        if(deltaY >= 0) {    //向上滚动
            
            if (self.contentOffset.y < -self.headerViewHeight && self.needMiddleRefresh) {
                
            }else{
                if(headerDisplayHeight - deltaY <= self.topHeight) {     //  // 当头部视图的可展示高度小于 设置的顶部距离的时候就固定
                    //                py = -headerViewHeight+self.topHeight;
                }else {
                }
                py = self.headerOriginYConstraint.constant - deltaY;   // 当头部视图的可展示高度大于设置的顶部距离的时候就跟随上移
                
                if(headerDisplayHeight <= self.topHeight) {  // 当头部视图的可展示高度小于 设置的顶部距离的时候就固定
                    py = -headerViewHeight+self.topHeight;
                }
                self.headerOriginYConstraint.constant = py;
            }
            
        }else {            //向下滚动
            
            if (headerDisplayHeight < -newOffsetY && self.needMiddleRefresh) {
                py = -self.headerViewHeight - self.currentScrollView.contentOffset.y;
                self.headerOriginYConstraint.constant = py >= 0 ? 0 : py;
            }else{
                if (headerDisplayHeight < -newOffsetY) {      // 当头部视图的展示高度大于设置的顶部距离的时候 ，头不是图的Y值跟随向下移动
                    py = -self.headerViewHeight - self.currentScrollView.contentOffset.y;
                    self.headerOriginYConstraint.constant = py;
                }
            }
        }
        
        self.contentOffset = self.currentScrollView.contentOffset;
        if ([self.delegate respondsToSelector:@selector(horizontalPageView:scrollTopOffset:)]) {
            
            CGFloat offY = 0;
            if (self.contentOffset.y > 0) {
                offY = self.contentOffset.y + self.headerViewHeight;
            }else{
                offY = self.contentOffset.y + self.headerViewHeight;
            }
            [self.delegate horizontalPageView:self scrollTopOffset:offY];
        }
        
    }else if(context == &HHHorizontalPagingViewInsetContext) {
        
//        if(self.allowPullToRefresh || self.currentScrollView.contentOffset.y > -self.segmentBarHeight) {
//            return;
//        }
//        [UIView animateWithDuration:0.2 animations:^{
//            self.headerOriginYConstraint.constant = -self.headerViewHeight-self.currentScrollView.contentOffset.y;
//            [self layoutIfNeeded];
//            [self.headerView layoutIfNeeded];
//
//        }];
//
    }
}

// 获取view上的响应者 是控制器的时候返回
- (UIViewController *)viewControllerForView:(UIView *)view {
    for (UIView* next = view; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - 移除超出最大缓存的列表页面
/*************************************************移除超出最大缓存的列表页面*********************************************/
- (void)removeCacheScrollView{
    
    if (self.contentViewArray.count <= self.maxCacheCount) {
        return;
    }
    [self releaseCache];
}

- (void)releaseCache{
    NSInteger currentCount = self.currentScrollView.tag;
    [self.contentViewArray enumerateObjectsUsingBlock:^(UIScrollView * _Nonnull scrollView, NSUInteger idx, BOOL * _Nonnull stop) {
        if (labs(scrollView.tag - currentCount) > 1) {
            [self removeScrollView:scrollView];
        }
    }];
}

- (void)removeScrollView:(UIScrollView *)scrollView{
    
    [self removeObserverFor:scrollView];
    [self.contentViewArray removeObject:scrollView];
    UIViewController *vc = [self viewControllerForView:scrollView];
    vc.view.tag = 0;
    scrollView.superview.tag = 0;
    vc.view.superview.tag = 0;
    [scrollView removeFromSuperview];
    [vc.view removeFromSuperview];
    [vc removeFromParentViewController];
}

- (void)removeObserverFor:(UIScrollView *)scrollView{
    [scrollView.panGestureRecognizer removeObserver:self forKeyPath:NSStringFromSelector(@selector(state)) context:&HHHorizontalPagingViewPanContext];
    [scrollView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) context:&HHHorizontalPagingViewScrollContext];
    [scrollView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentInset)) context:&HHHorizontalPagingViewInsetContext];
}

- (void)dealloc {
    [self.contentViewArray enumerateObjectsUsingBlock:^(UIScrollView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self removeObserverFor:obj];
    }];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 头部视图的手势方法
/*************************************************头部视图手势方法*********************************************/
- (void)addGestureRecognizerAtHeaderView{
    
    if (self.needHeadGestures == NO) {
        return;
    }
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    pan.delegate = self;
    [self.headerView addGestureRecognizer:pan];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [pan translationInView:self.headerView];
//        CGPoint touchPoint = [pan locationInView:self.headerView];
        
        if (fabs(point.y)  <=  fabs(point.x)) {
            return NO;
        }
    }
    
    return YES;
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    return YES;
//}

- (void)pan:(UIPanGestureRecognizer*)pan{
  
    // 偏移计算
    CGPoint point = [pan translationInView:self.headerView];
    
    CGPoint contentOffset = self.currentScrollView.contentOffset;
    CGFloat border = - self.headerViewHeight;
    
    if (self.currentScrollView.contentOffset.y < border) {
        self.currentScrollView.contentOffset = CGPointMake(contentOffset.x, contentOffset.y - point.y * 0.5);
    }else{
        self.currentScrollView.contentOffset = CGPointMake(contentOffset.x, contentOffset.y - point.y);
    }
    
    if (self.needMiddleRefresh) {    
        if (self.contentOffset.y < -self.headerViewHeight) {
            [self.currentScrollView setContentOffset:CGPointMake(contentOffset.x, -self.headerViewHeight) animated:NO];
            return;
        }
    }
    
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateFailed || self.currentScrollView.contentOffset.y >= -self.topHeight) {
        if (contentOffset.y <= border) {
            
            // 模拟弹回效果
            [UIView animateWithDuration:0.35 animations:^{
                self.currentScrollView.contentOffset = CGPointMake(contentOffset.x, border);
                [self layoutIfNeeded];
            }];
            
        }else{
            // 模拟减速滚动效果
            CGFloat velocity = [pan velocityInView:self.headerView].y;
            [self deceleratingAnimator:velocity];
        }
    }
    
    // 清零防止偏移累计
    [pan setTranslation:CGPointZero inView:self.headerView];
    
}

- (void)deceleratingAnimator:(CGFloat)velocity{
    
    if (self.inertialBehavior != nil) {
        [self.animator removeBehavior:self.inertialBehavior];
    }
    DynamicItem *item = [[DynamicItem alloc] init];
    item.center = CGPointMake(0, 0);
    // velocity是在手势结束的时候获取的竖直方向的手势速度
    UIDynamicItemBehavior *inertialBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[ item ]];
    [inertialBehavior addLinearVelocity:CGPointMake(0, velocity * 0.025) forItem:item];
    // 通过尝试取2.0比较像系统的效果
    inertialBehavior.resistance = 2;
    
    __weak typeof(self)weakSelf = self;
    CGFloat h = self.currentScrollView.contentSize.height <= MOL_SCREEN_HEIGHT - self.headerViewHeight ? MOL_SCREEN_HEIGHT - self.headerViewHeight : self.currentScrollView.contentSize.height;
    CGFloat maxOffset = h - self.currentScrollView.bounds.size.height;
    inertialBehavior.action = ^{
        
        CGPoint contentOffset = weakSelf.currentScrollView.contentOffset;
        CGFloat speed = [weakSelf.inertialBehavior linearVelocityForItem:item].y;
        CGFloat offset = contentOffset.y -  speed;
        
        if (speed >= -0.2) {
            
            [weakSelf.animator removeBehavior:weakSelf.inertialBehavior];
            weakSelf.inertialBehavior = nil;
        }else if (offset >= maxOffset){
            
            [weakSelf.animator removeBehavior:weakSelf.inertialBehavior];
            weakSelf.inertialBehavior = nil;
            offset = maxOffset;
            // 模拟减速滚动到scrollView最底部时，先拉一点再弹回的效果
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.currentScrollView.contentOffset = CGPointMake(contentOffset.x, offset - speed);
                [weakSelf layoutIfNeeded];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.currentScrollView.contentOffset = CGPointMake(contentOffset.x, offset);
                    [weakSelf layoutIfNeeded];
                }];
            }];
        }else{
            
            weakSelf.currentScrollView.contentOffset = CGPointMake(contentOffset.x, offset);
        }
    };
    self.inertialBehavior = inertialBehavior;
    [self.animator addBehavior:inertialBehavior];
}

#pragma mark - .h 方法的实现
- (void)scrollEnable:(BOOL)enable {
    if(enable) {
        self.horizontalCollectionView.scrollEnabled = YES;
    }else {
        self.horizontalCollectionView.scrollEnabled = NO;
    }
}

- (void)scrollToIndex:(NSInteger)pageIndex {
    
    [self.horizontalCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:pageIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
//    if(self.currentScrollView.contentOffset.y<-(self.headerViewHeight)) {
//        [self.currentScrollView setContentOffset:CGPointMake(self.currentScrollView.contentOffset.x, -(self.headerViewHeight)) animated:NO];
//    }else {
//        [self.currentScrollView setContentOffset:self.currentScrollView.contentOffset animated:NO];
//    }
    
    [self didSwitchPageToIndex:pageIndex];
    
}

- (void)scrollToIndex:(NSInteger)pageIndex animation:(BOOL)animate
{
    [self.horizontalCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:pageIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animate];
    
    //    if(self.currentScrollView.contentOffset.y<-(self.headerViewHeight)) {
    //        [self.currentScrollView setContentOffset:CGPointMake(self.currentScrollView.contentOffset.x, -(self.headerViewHeight)) animated:NO];
    //    }else {
    //        [self.currentScrollView setContentOffset:self.currentScrollView.contentOffset animated:NO];
    //    }
    
    [self didSwitchPageToIndex:pageIndex];
}

#pragma mark - 视图切换时执行代码
- (void)didSwitchPageToIndex:(NSInteger)toIndex{
    self.currentScrollView = [self currentScrollViewAtIndex:toIndex];

    [self removeCacheScrollView];
}

#pragma mark - 获取scrollview  两个作用 1 获取当前的scrollview  2 把ScrollView 添加到容器中
- (UIScrollView *)currentScrollViewAtIndex:(NSInteger)index{
    
    __block UIScrollView *scrollView = nil;
    [self.contentViewArray enumerateObjectsUsingBlock:^(UIScrollView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag == pagingScrollViewTag + index) {
            scrollView = obj;
            *stop = YES;
        }
    }];
    
    if (scrollView == nil) {
        scrollView = [self.delegate horizontalPageView:self viewAtIndex:index];
        [self configureContentView:scrollView];
        scrollView.tag = pagingScrollViewTag + index;
        [self.contentViewArray addObject:scrollView];
    }
    return scrollView;
}

#pragma mark - 懒加载
- (UIDynamicAnimator *)animator{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] init];
    }
    return _animator;
}

- (NSMutableArray<UIScrollView *> *)contentViewArray{
    if (!_contentViewArray) {
        _contentViewArray = [[NSMutableArray alloc] init];
    }
    return _contentViewArray;
}

- (CGFloat)maxCacheCount{
    if (_maxCacheCount == 0) {
        _maxCacheCount = 4;
    }
    return _maxCacheCount;
}

@end
