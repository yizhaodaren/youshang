//
//  MOLStartRecordViewController.m
//  reward
//
//  Created by apple on 2018/9/22.
//  Copyright © 2018年 reward. All rights reserved.
//
#import "MOLStartRecordViewController.h"
#import "MOLRewardListViewController.h"
#import "MOLRecordViewController.h"
#import "AdScrollerView.h"
#import "BannerModel.h"
#import "RewardRequest.h"
#import "MOLBannerSetModel.h"
#import "MOLVideoOutsideModel.h"
#import "RewardDetailViewController.h"
#import "RewardBannerWebController.h"
#import "MOLMixRecordViewController.h"
@interface MOLStartRecordViewController ()<JAHorizontalPageViewDelegate,SPPageMenuDelegate,DemoScrollerViewDelegate>

@property (nonatomic, strong)UIButton  *nextBtn;
@property (nonatomic, strong) JAHorizontalPageView *pageView;
@property (nonatomic, strong) AdScrollerView *cycleView;//轮播图
@property (nonatomic, strong)NSMutableArray *adArr;
@property (nonatomic, strong) SPPageMenu *pageMenu;//分页
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *headView;


@property (nonatomic, weak) MOLRewardListViewController *rewardVc1;
@property (nonatomic, weak) MOLRewardListViewController *rewardVc2;
@property (nonatomic, weak) MOLRewardListViewController *rewardVc3;

@end

@implementation MOLStartRecordViewController

-(BOOL)showNavigation{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
//    [self getBannerData];
}
#pragma mark - UI
- (void)initUI
{
    [self.view addSubview:self.pageView];
    [self.pageView reloadPage];
    [self.pageMenu setItems:@[@"推荐",@"最豪",@"最新"] selectedItemIndex:1];
    self.pageMenu.bridgeScrollView = (UIScrollView *)_pageView.horizontalCollectionView;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.nextBtn];
}
#pragma mark - 网络请求
- (void)getBannerData{
    [[[RewardRequest alloc] initRequest_BannerParameter:@{}] baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        
        if (code == MOL_SUCCESS_REQUEST) {
            if (responseModel) {
                // 解析数据
                MOLBannerSetModel *mediaInfoList = (MOLBannerSetModel *)responseModel;
                self.adArr =[NSMutableArray arrayWithArray:mediaInfoList.resBody];
                [self.cycleView setContent:self.adArr];
            }
        }else{
    
        }
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //当前导航栏状态和颜色
    [self.navigationController.navigationBar setTranslucent:NO];
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = HEX_COLOR(0x0F101C);
    //防止导航栏错位
    self.navigationController.navigationBar.frame = CGRectMake(0, MOL_StatusBarHeight, self.navigationController.navigationBar.frame.size.width, 44);
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    //回复默认导航栏状态和颜色
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(void)nextButtonClick{
    //友盟统计
    [MobClick event:ST_c_video_button];
    
    if (![MOLUserManagerInstance user_isLogin]) {
        [[MOLGlobalManager shareGlobalManager] global_modalLogin];
        return;
    }
    
    [MOLReleaseManager manager].rewardID = 0;
    MOLRecordViewController *vc = [[MOLRecordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
//      NSURL *url = [NSURL URLWithString:@"http://file.urmoli.com/reward/audio/iOS_15403638699374C99A7A0-B7CC-41D3-8B3A-7F9183BF66E1.mp4"];
//    [[MOLRecordManager manager] loadMaterialResourcesWith:url];

}
#pragma mark DemoScrollerViewDelegate
-(void)DemoScrollerViewDidClicked:(NSUInteger)index{
    if ((index%1000-1)<self.adArr.count) {
        BannerModel *model =[BannerModel new];
        model =self.adArr[(index%1000-1)];
        if (model.bannerType.integerValue==1) {//跳转到商品详情
            
            RewardDetailViewController *rewardDetail =[RewardDetailViewController new];
            rewardDetail.rewardId =model.typeInfo?model.typeInfo:@"";
            [self.navigationController pushViewController:rewardDetail
                                                  animated:YES];
        }else if(model.bannerType.integerValue==0){ //web页面
            RewardBannerWebController *web =[RewardBannerWebController new];
            web.url =model.typeInfo?model.typeInfo:@"";
            [self.navigationController pushViewController:web animated:YES];
        }
    }
}
#pragma mark - delegate
- (NSInteger)numberOfSectionPageView:(JAHorizontalPageView *)view   // 返回几个控制器
{
    return 3;
}
- (UIScrollView *)horizontalPageView:(JAHorizontalPageView *)pageView viewAtIndex:(NSInteger)index   // 返回每个控制器的view
{
    MJWeakSelf
    if (index == 0) {
        MOLRewardListViewController *vc = [[MOLRewardListViewController alloc] init];
        vc.sortType = RewardRecommendType;
        vc.requestBannerBlock = ^{
            [weakSelf getBannerData];
        };
        _rewardVc1 = vc;
        vc.view.backgroundColor = [UIColor clearColor];
        [self addChildViewController:vc];
        return (UIScrollView *)vc.tableView;
    }else if (index == 1){
        MOLRewardListViewController *vc = [[MOLRewardListViewController alloc] init];
        vc.sortType = RewardHaoType;
        vc.requestBannerBlock = ^{
            [weakSelf getBannerData];
        };
        _rewardVc2 = vc;
        vc.view.backgroundColor = [UIColor clearColor];
        [self addChildViewController:vc];
        return (UIScrollView *)vc.tableView;
    }else{
        MOLRewardListViewController *vc = [[MOLRewardListViewController alloc] init];
        vc.sortType = RewardNewestType;
        vc.requestBannerBlock = ^{
            [weakSelf getBannerData];
        };
        _rewardVc3 = vc;
        vc.view.backgroundColor = [UIColor clearColor];
        [self addChildViewController:vc];
        return (UIScrollView *)vc.tableView;
    }
}
- (UIView *)headerViewInPageView:(JAHorizontalPageView *)pageView     // 返回头部
{
    return self.headView;
}
- (CGFloat)headerHeightInPageView:(JAHorizontalPageView *)pageView    // 返回头部高度
{
    return self.headView.height;
}
- (CGFloat)topHeightInPageView:(JAHorizontalPageView *)pageView   // 控制在什么地方悬停
{
    return 43;
}
- (void)horizontalPageView:(JAHorizontalPageView *)pageView scrollTopOffset:(CGFloat)offset   // 滚动的偏移量
{
    //    if (offset < 0) {
    //
    //    }else{
    //
    //    }
    self.cycleView.alpha = 1 - offset/ (self.headView.height);
}
- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    [_pageView scrollToIndex:toIndex];
}
#pragma mark - 懒加载
-(JAHorizontalPageView *)pageView{
    if (!_pageView) {
        CGSize size = [UIScreen mainScreen].bounds.size;
         _pageView = [[JAHorizontalPageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) delegate:self];
        _pageView.horizontalCollectionView.scrollEnabled = YES;
//        _pageView.needHeadGestures = YES;
        _pageView.needMiddleRefresh = YES;
    }
    return _pageView;
}
- (UIView *)headView
{
    if (_headView == nil) {
        _headView = [[UIView alloc] init];
        [_headView addSubview:self.cycleView];
        SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, _cycleView.bottom, MOL_SCREEN_WIDTH, 43) trackerStyle:SPPageMenuTrackerStyleLine];
        _pageMenu = pageMenu;
        _pageMenu.backgroundColor = HEX_COLOR(0x0E0F1A);
        _pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
        _pageMenu.itemTitleFont = MOL_MEDIUM_FONT(16);
        _pageMenu.selectedItemTitleColor = HEX_COLOR(0xffffff);
        _pageMenu.unSelectedItemTitleColor = HEX_COLOR_ALPHA(0xffffff, 0.6);
        [_pageMenu setTrackerHeight:3 cornerRadius:0];
        _pageMenu.tracker.backgroundColor = HEX_COLOR(0xFFEC00);
        _pageMenu.needTextColorGradients = NO;
        _pageMenu.dividingLine.hidden = YES;
        _pageMenu.itemPadding = 20;
        _pageMenu.delegate = self;
        
        [_headView addSubview:_pageMenu];
      
        _headView.width = MOL_SCREEN_WIDTH;
        _headView.height =(_cycleView.height) + (_pageMenu.height) + 1;
        UIView *line = [[UIView alloc] init];
        _lineView = line;
        line.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.1);
        line.width = MOL_SCREEN_WIDTH;
        line.height = 1;
        line.y = _headView.height - 1;
        [_headView addSubview:line];
    }
    return _headView;
}
- (AdScrollerView *)cycleView{
    
    if (!_cycleView) {
        _cycleView =[[AdScrollerView alloc] initWithFrame:CGRectMake(0, 0,MOL_SCREEN_WIDTH, MOL_SCALEHeight(156))];
        _cycleView.backgroundColor = [UIColor clearColor];
        _cycleView.delegate = self;
    }
    
    return _cycleView;
    
}
-(UIButton *)nextBtn{
    if (!_nextBtn) {
        // 下一步
       _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setTitle:@"直接开拍" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _nextBtn.frame = CGRectMake(MOL_SCREEN_WIDTH - 80, 0, 80, 24);
        _nextBtn.titleLabel.font = MOL_MEDIUM_FONT(15);
        [_nextBtn setTitleColor:HEX_COLOR(0xFFEC00) forState:UIControlStateNormal];
        _nextBtn.layer.cornerRadius = 5;
        [_nextBtn addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}
@end
