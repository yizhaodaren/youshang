//
//  RecommendViewController.m
//  reward
//
//  Created by xujin on 2018/9/12.
//  Copyright © 2018年 reward. All rights reserved.
//
#import "RewardDetailViewController.h"
#import "RecommendViewController.h"
#import "PLShortPlayerViewController.h"
#import "UIView+Alert.h"
#import "HomePageRequest.h"
//#import "UIButton+Animate.h"
#import "MOLVideoOutsideGroupModel.h"
#import "MOLMineViewController.h"
#import "RewardDetailViewController.h"
#import "MOLLoginViewController.h"
#import "MOLOtherUserViewController.h"
#import "MOLVideoOutsideModel.h"
#import "MOLUserPageRequest.h"
#import "RewardRequest.h"
#import "MOLMusicRequest.h"

static const NSInteger RefreshFooterHeight =10;

@interface RecommendViewController ()<UIScrollViewDelegate>
{
    dispatch_semaphore_t _semaphore;
}
@property (nonatomic, strong) PLBaseViewController *emptyController;
@property (nonatomic, strong) PLShortPlayerViewController *shortPlayerVC;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) MOLVideoOutsideGroupModel *mediaInfoList;
@property (nonatomic, strong) UIPageViewController *pageviewController;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UILabel *pullRefreshLabel;
@property (nonatomic, strong) UIScrollView *scroll_view;
@property (nonatomic, assign) UIEdgeInsets scrOriginalInset;// 记录scrollView刚开始的inset
@property (nonatomic, assign) CGPoint scrOriginalOffset;// 记录scrollView刚开始的Offset
@property (nonatomic, assign) BOOL isFirstScroll;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) MJRefreshState refreshState;   //刷新状态
@property (nonatomic, assign) UIBehaviorTypeStyle refreshType; //刷新类型
//视频播放源
@property (nonatomic, strong) NSMutableArray *mediaArray;
//当前播放视频
@property (nonatomic, assign) NSInteger index;
//当前页码
@property (nonatomic, assign) NSInteger pageNum;

//各业务功能模块
@property (nonatomic,assign)HomePageBusinessType businessType;

@property (nonatomic,assign)BOOL isNoMore; //yes 表示不再更多 no 表示还有数据

@end

@implementation RecommendViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self notification];
    [self initData];
    [self layoutUI];
    
    switch (self.businessType) {
        case HomePageBusinessType_HomePageRecommend: //首页推荐
        case HomePageBusinessType_RewardList: //悬赏列表作品
        case HomePageBusinessType_userReward: //用户悬赏作品集
        case HomePageBusinessType_Hours:      //24HOT
        case HomePageBusinessType_RewardDetail:      //悬赏详情
        case HomePageBusinessType_StoryDetail:      //作品详情
        case HomePageBusinessType_sameMusicUserProduction://相同音乐下的作品集
            
        {
            [self getPlayList];
        }
            break;
        case HomePageBusinessType_RewardDetailList: //悬赏详情作品
        case HomePageBusinessType_userProduction: //用户作品
            //        case HomePageBusinessType_sameMusicUserProduction://相同音乐下的作品集
        case HomePageBusinessType_userLike: //用户喜欢作品
        {
            self.mediaArray =[NSMutableArray arrayWithArray:self.mediaDto.dataSource?self.mediaDto.dataSource:@[]];
            [self reloadController];
        }
            break;
    }
}
///退出登录后初始化
- (void)initUIData{
    [self.mediaArray removeAllObjects];
    self.isFirstScroll =NO;
    self.refreshState = MJRefreshStateIdle;
    self.refreshType =UIBehaviorTypeStyle_Normal;
    self.pageNum =1;
    self.pageSize =MOL_REQUEST_COUNT_VEDIO;
    self.index =0;
    self.currentIndex =self.index;
    self.businessType =HomePageBusinessType_HomePageRecommend;
    self.isNoMore =NO;
}

- (void)initData{
    _semaphore = dispatch_semaphore_create(1);
    self.mediaArray = NSMutableArray.new;
    self.isFirstScroll =NO;
    self.refreshState = MJRefreshStateIdle;
    self.refreshType =UIBehaviorTypeStyle_Normal;
    self.pageNum =self.mediaDto.pageNum>0?self.mediaDto.pageNum:1;
    self.pageSize =self.mediaDto.pageSize>0?self.mediaDto.pageSize:MOL_REQUEST_COUNT_VEDIO;
    self.index =self.mediaDto.index;
    self.currentIndex =self.index;
    self.businessType =self.mediaDto.businessType;
    self.isNoMore =NO;
}
- (void)layoutUI{
    //UIPageViewControllerTransitionStyleScroll scroll  UIScrollView滚动效果
    //UIPageViewControllerNavigationOrientationVertical 垂直 上下翻转 垂直导航方式
    //UIPageViewControllerOptionInterPageSpacingKey  间距
    
    self.pageviewController =[[UIPageViewController alloc] initWithTransitionStyle:(UIPageViewControllerTransitionStyleScroll) navigationOrientation:(UIPageViewControllerNavigationOrientationVertical) options:@{UIPageViewControllerOptionInterPageSpacingKey:@(0)}];
    
    self.pageviewController.view.height =MOL_SCREEN_HEIGHT-MOL_TabbarSafeBottomMargin;
    
    [self.view addSubview:self.pageviewController.view];
    
    
    for (UIView *subView in self.pageviewController.view.subviews ) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)subView;
            scrollView.delaysContentTouches = NO;
            scrollView.delegate =self;
            self.scroll_view =scrollView;
            if (@available(iOS 11.0, *)) {
                scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            } else {
                self.automaticallyAdjustsScrollViewInsets = NO;
            }
            
            self.scrOriginalInset =scrollView.contentInset;
            self.scrOriginalOffset =scrollView.contentOffset;
            [self layoutActivityIndicatorView];
            self.isFirstScroll =YES;
            
            
            @weakify(self);
            scrollView.mj_header = [MOLDIYRefreshHeader headerWithRefreshingBlock:^{
                @strongify(self);
                [self.indicatorView startAnimating];
                [self refresh];
            }];
            //            scrollView.mj_footer = [MOLDIYRefreshFooter footerWithRefreshingBlock:^{
            //                @strongify(self);
            //                [self loadMore];
            //            }];
            
        }
    }
    
    self.pageviewController.delegate       = self;
    self.pageviewController.dataSource     = self;
    
    self.emptyController = [[PLBaseViewController alloc] init];
    
}

- (void)onUIApplication:(BOOL)active {
    if (self.shortPlayerVC) {
        self.shortPlayerVC.player.enableRender = active;
    }
}

//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}

- (void)clickReloadButton {
    [self.emptyController hideReloadButton];
    [self getPlayList];
}

#pragma mark -
#pragma mark 网络请求数据

- (void)businessModule{
    [self getPlayList];
}
-(void)refreshHome{
    [self.scroll_view.mj_header beginRefreshing];
}

- (void)refresh{
    self.index =0;
    self.currentIndex =0;
    self.pageNum =1;
    self.refreshType =UIBehaviorTypeStyle_Refresh;
    self.isNoMore =NO;
    [self businessModule];
};

- (void)loadMore{
    self.pageNum++;
    self.refreshType =UIBehaviorTypeStyle_More;
    [self businessModule];
}

///首页推荐列表
- (void)getPlayList {
    __weak typeof(self) wself = self;
    [wself basevc_hiddenErrorView];
    //  [self.view showLoadingHUD];
    
    //  NSLog(@"index---%ld,--->currentIndex:%ld--->%lf--->%lf---top%lf---->%lf",self.index,self.currentIndex,self.scroll_view.contentOffset.y,self.scroll_view.contentInset.top,self.scrOriginalOffset.y,self.scrOriginalInset.top);
    
    /*
     需要userid rewardid
     用户作品
     用户喜欢
     
     不需要userid  只需要rewardid
     用户悬赏
     推荐列表
     悬赏列表  sort 3
     悬赏详情列表
     24小时
     
     rewardID
     悬赏详情   sort 3
     作品详情
     */
    NSMutableDictionary *dic =[NSMutableDictionary new];
    
    
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.pageNum] forKey:@"pageNum"];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.pageSize] forKey:@"pageSize"];
    
    id r ;
    if (self.businessType != HomePageBusinessType_HomePageRecommend) {
        
        if (self.businessType == HomePageBusinessType_userLike ||
            self.businessType == HomePageBusinessType_userProduction) {
            //用户作品、用户喜欢作品、用户悬赏  userid
            dic[@"userId"] = self.mediaDto.userId?self.mediaDto.userId:@"";
            dic[@"rewardId"] = self.mediaDto.rewardId?self.mediaDto.rewardId:@"";
            r = [[MOLUserPageRequest alloc] initRequest_getProductionListWithParameter:dic];
        }
        if (self.businessType == HomePageBusinessType_sameMusicUserProduction) {
            //用户作品、用户喜欢作品、用户悬赏  userid
            
            dic[@"musicId"] = self.mediaDto.musicID ?@(self.mediaDto.musicID):@0;
            dic[@"sort"] = self.mediaDto.sortType ?@(self.mediaDto.sortType):@3;
            r = [[MOLUserPageRequest alloc] initRequest_getProductionListWithParameter:dic];
        }
        else if (self.businessType == HomePageBusinessType_RewardList ||
                 self.businessType == HomePageBusinessType_RewardDetailList ||
                 self.businessType == HomePageBusinessType_userReward) {
            dic[@"rewardId"] = self.mediaDto.rewardId?self.mediaDto.rewardId:@"";
            if (self.businessType == HomePageBusinessType_RewardList ||
                self.businessType == HomePageBusinessType_userReward) {
                //                dic[@"sort"] = @"3";
            }
            r = [[MOLUserPageRequest alloc] initRequest_getProductionListWithParameter:dic];
        }
        else if(self.businessType == HomePageBusinessType_RewardDetail){//悬赏详情
            r =[[RewardRequest alloc] initRequest_RewardDetailParameter:@{} parameterId:self.mediaDto.rewardId?self.mediaDto.rewardId:@""];
        }
        else if(self.businessType == HomePageBusinessType_StoryDetail){ //作品详情
            r = [[HomePageRequest alloc] initRequest_StoryDetailParameter:@{} parameterId:self.mediaDto.rewardId?self.mediaDto.rewardId:@""];
        }
        
    }else{
        r = [[HomePageRequest alloc] initRequest_RecommendListParameter:dic];
    }
    
    
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        
        // 通知刷完成
        [[NSNotificationCenter defaultCenter] postNotificationName:MOL_HOME_REFRESHED object:nil];
        // [wself.view hideLoadingHUD];
        
        if (wself.refreshType == UIBehaviorTypeStyle_Refresh) {
            [wself.scroll_view.mj_header endRefreshing];
            [wself.indicatorView stopAnimating];
        }
        
        
        
        if (code  == MOL_SUCCESS_REQUEST) {
            if (responseModel) {
                
                // 解析数据
                if (wself.refreshType != UIBehaviorTypeStyle_More) {
                    [wself.mediaArray removeAllObjects];
                }
                
                NSInteger total =0;
                if(wself.businessType == HomePageBusinessType_RewardDetail ||
                   wself.businessType == HomePageBusinessType_StoryDetail){//悬赏详情、作品详情
                    MOLVideoOutsideModel *mediaInfoList =(MOLVideoOutsideModel *)responseModel;
                    total =mediaInfoList.total;
                    [wself.mediaArray addObject:mediaInfoList];
                    
                    if (!(wself.mediaArray.count && !(mediaInfoList && (mediaInfoList.rewardVO || mediaInfoList.storyVO)))) { //表示源数据有值  返回数据无值则无需reloadController
                        [wself reloadController];
                    }
                    
                    
                }else{
                    MOLVideoOutsideGroupModel *mediaInfoList = (MOLVideoOutsideGroupModel *)responseModel;
                    total =mediaInfoList.total;
                    [wself.mediaArray addObjectsFromArray:mediaInfoList.resBody];
                    
                    if (!(wself.mediaArray.count && !mediaInfoList.resBody.count)) { //表示源数据有值  返回数据无值则无需reloadController
                        [wself reloadController];
                    }
                    
                }
                
                if (wself.mediaArray.count >= total) {
                    wself.isNoMore = YES;
                    
                }else{
                    wself.isNoMore = NO;
                    
                }
                
                
            }
            
        }else{
            
        }
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        
        // 通知刷完成
        [[NSNotificationCenter defaultCenter] postNotificationName:MOL_HOME_REFRESHED object:nil];
        if (wself.refreshType == UIBehaviorTypeStyle_Refresh) {
            [wself.scroll_view.mj_header endRefreshing];
            [wself.indicatorView stopAnimating];
        }
        
        if (!self.mediaArray.count) {
            [self basevc_showErrorPageWithY:0 select:@selector(getPlayList) superView:self.view];
        }
        
    }];
    
}

- (void)reloadController {
    
    // NSLog(@"index ^^^%ld",self.index);
    
    if (self.mediaArray.count) {
        PLShortPlayerViewController* playerController = [[PLShortPlayerViewController alloc] init];
        if (self.index < self.mediaArray.count) {
            playerController.media = [self.mediaArray objectAtIndex:self.index];
        } else {
            playerController.media = [self.mediaArray firstObject];
            self.index = 0;
        }
        
        playerController.indexPL =self.index;
        if (self.mediaDto.businessType == HomePageBusinessType_HomePageRecommend) {
            playerController.fromViewController =100;
        }
        self.shortPlayerVC = playerController;
        [self.pageviewController setViewControllers:@[playerController] direction:(UIPageViewControllerNavigationDirectionForward) animated:NO completion:^(BOOL finished) {
        }];
    } else {
        __weak typeof(self) wself = self;
        [self.pageviewController setViewControllers:@[self.emptyController] direction:(UIPageViewControllerNavigationDirectionForward) animated:NO completion:^(BOOL finished) {
            [wself.emptyController.reloadButton addTarget:wself action:@selector(clickReloadButton) forControlEvents:(UIControlEventTouchUpInside)];
            wself.emptyController.reloadButton.hidden = NO;
        }];
    }
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    if (![viewController isKindOfClass:[PLShortPlayerViewController class]]) return nil;
    
    NSInteger index = [self.mediaArray indexOfObject:[(PLShortPlayerViewController*)viewController media]];
    if (NSNotFound == index) return nil;
    
    index --;
    if (index < 0) return nil;
    
    PLShortPlayerViewController* playerController = [[PLShortPlayerViewController alloc] init];
    playerController.media = [self.mediaArray objectAtIndex:index];
    playerController.indexPL =index;
    self.index = index;
    if (self.mediaDto.businessType == HomePageBusinessType_HomePageRecommend) {
        playerController.fromViewController =100;
    }
    return playerController;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    if (![viewController isKindOfClass:[PLShortPlayerViewController class]]) return nil;
    
    NSInteger index = [self.mediaArray indexOfObject:[(PLShortPlayerViewController*)viewController media]];
    if (NSNotFound == index) return nil;
    
    index ++;
    
    if (self.mediaArray.count > index) {
        PLShortPlayerViewController* playerController = [[PLShortPlayerViewController alloc] init];
        playerController.media = [self.mediaArray objectAtIndex:index];
        self.index = index;
        playerController.indexPL =index;
        if (self.mediaDto.businessType == HomePageBusinessType_HomePageRecommend) {
            playerController.fromViewController =100;
        }
        return playerController;
    }
    return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    PLShortPlayerViewController *vc =(PLShortPlayerViewController *)[pageViewController.viewControllers firstObject];
    if (self.mediaDto.businessType == HomePageBusinessType_HomePageRecommend) {
        vc.fromViewController =100;
    }
    self.currentIndex =vc.indexPL;
    if (self.currentIndex==0) { //表示第一页
        self.scroll_view.mj_header.hidden =NO;
        self.scroll_view.mj_footer.hidden =YES;
        
    }else if (self.currentIndex == self.mediaArray.count-1){//表示最后一页
        self.scroll_view.mj_header.hidden =YES;
        self.scroll_view.mj_footer.hidden =NO;
        
    }else{//其它页
        self.scroll_view.mj_header.hidden =YES;
        self.scroll_view.mj_footer.hidden =YES;
        
    }
    
}



#pragma mark-
#pragma mark 下拉刷新实现逻辑处理
- (void)layoutActivityIndicatorView{
    self.indicatorView =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.indicatorView setCenter:CGPointMake(MOL_SCREEN_WIDTH/2.0, self.scrOriginalOffset.y-17.0)];
    [self.scroll_view addSubview:self.indicatorView];
    [self.scroll_view bringSubviewToFront:self.indicatorView];
}


#if 1
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    //    if (!self.isFirstScroll) {
    //        self.scrOriginalInset =scrollView.contentInset;
    //        self.scrOriginalOffset =scrollView.contentOffset;
    //        [self layoutActivityIndicatorView];
    //        self.isFirstScroll =YES;
    //      //  NSLog(@"scrollViewWillBeginDragging--->%f ---%lf",self.scrOriginalOffset.y,self.scrOriginalInset.top);
    //    }
    
}



//开始减速
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (((self.scrOriginalOffset.y - scrollView.contentOffset.y)<=(-RefreshFooterHeight)) && self.mediaArray.count>0 && (self.currentIndex == self.mediaArray.count-1)) { //上拉加载更多
        //     NSLog(@"scrollViewWillBeginDecelerating上拉加载更多");
        self.refreshState = MJRefreshStatePulling;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //  NSLog(@"scrollViewDidScroll--->%f ---%lf---%f",self.scroll_view.contentInset.top,self.scroll_view.contentOffset.y,self.scroll_view.contentSize.height);
    
    
    if (((self.scrOriginalOffset.y - scrollView.contentOffset.y)<=(-RefreshFooterHeight)) && self.mediaArray.count>0 && (self.currentIndex == self.mediaArray.count-1)) { //上拉加载更多
        //  NSLog(@"上拉加载更多");
        
        if (self.refreshState == MJRefreshStatePulling) {
            dispatch_semaphore_wait(self->_semaphore, DISPATCH_TIME_FOREVER);
            self.refreshState = MJRefreshStateRefreshing;
            dispatch_semaphore_signal(self->_semaphore);
            //如果没有数据则不再加载
            if (!self.isNoMore) {
                [self loadMore];
            }
            
        }
        
        
    }
    
    
}

#endif

#pragma mark-
#pragma mark NSNotification
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MOL_SUCCESS_USER_OUT object:nil];
    // [[NSNotificationCenter defaultCenter] removeObserver:self name:MOL_SUCCESS_USER_FOCUS object:nil];
#if    !OS_OBJECT_USE_OBJC
    dispatch_release(_semaphore);
#endif
}

- (void)notification{
    
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loseInterest:) name:@"PLPlayViewControllerLoseInterest" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOutEvent:) name:MOL_SUCCESS_USER_OUT object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(focusEventNotif:) name:MOL_SUCCESS_USER_FOCUS object:nil];
}

#if 0
- (void)focusEventNotif:(NSNotification *)notif{
    
    if (notif.object) {
        NSArray *arr =[NSArray new];
        arr =(NSArray *)notif.object;
        if (arr.count<2) { //表示关注必须存在userid和关注状态
            return;
        }
        
        
        NSString *toUserId =arr[0];
        BOOL isFocus =[arr[1] boolValue];
        
        NSMutableArray *vArr =[NSMutableArray arrayWithArray:self.mediaArray];
        __weak typeof(self) wself = self;
        for (NSInteger i=0; i<vArr.count; i++) {
            MOLVideoOutsideModel*obj =[MOLVideoOutsideModel new];
            obj=vArr[i];
            
            NSInteger userId =0;
            if (obj.contentType ==1) { //悬赏
                userId =obj.rewardVO.userVO.userId.integerValue;
            }else if (obj.contentType ==2){ //作品
                userId =obj.storyVO.userVO.userId.integerValue;
            }
            if (userId ==toUserId.integerValue) { //表示找到了相同用户
                // dispatch_async(dispatch_get_main_queue(), ^{
                if (isFocus==1) { //表示关注
                    if (obj.contentType ==1) { //悬赏
                        obj.rewardVO.userVO.isFriend =1;
                    }else if (obj.contentType ==2){ //作品
                        obj.storyVO.userVO.isFriend =1;
                    }
                }else{//表示取消关注
                    if (obj.contentType ==1) { //悬赏
                        obj.rewardVO.userVO.isFriend =0;
                    }else if (obj.contentType ==2){ //作品
                        obj.storyVO.userVO.isFriend =0;
                    }
                }
                [wself.mediaArray replaceObjectAtIndex:i withObject:obj];
                
                //    });
            }
        }
    }
}
#endif

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loseInterest:) name:@"PLPlayViewControllerLoseInterest" object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PLPlayViewControllerLoseInterest" object:nil];

}





#pragma mark-
#pragma mark 不感兴趣、删除视频
- (void)loseInterest:(NSNotification *)notif{
    MOLVideoOutsideModel *model =(MOLVideoOutsideModel *)notif.object;
    if (!model) {
        return;
    }
    NSInteger index=0;
    index=[self.mediaArray indexOfObject:model];
    [self.mediaArray removeObjectAtIndex:index];
    [self reloadController];
}

- (void)logOutEvent:(NSNotification *)notif{
    NSLog(@"退出登录事件");
    [self initUIData];
    [self getPlayList];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
