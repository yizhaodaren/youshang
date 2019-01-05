//
//  MOLExaminePacketModeViewController.m
//  reward
//
//  Created by moli-2017 on 2018/9/15.
//  Copyright © 2018年 reward. All rights reserved.

/*
    审核红包悬赏 悬赏的所有视频
 */

#import "MOLExaminePacketModeViewController.h"
#import "MOLExaminePacketListViewController.h"
#import "CBAutoScrollLabel.h"

@interface MOLExaminePacketModeViewController ()<JAHorizontalPageViewDelegate, SPPageMenuDelegate>
@property (nonatomic, strong) JAHorizontalPageView *pageView;
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic, weak) UIView *lineView;

@property (nonatomic, weak) MOLExaminePacketListViewController *examineVideoVC;
@property (nonatomic, weak) MOLExaminePacketListViewController *prizeVideoVC;
@end

@implementation MOLExaminePacketModeViewController

- (BOOL)showNavigationLine
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupExaminePacketModeViewControllerUI];
    [self setupNavigation];
    
    [self.pageView reloadPage];
    
    [self.pageMenu setItems:@[@"视频",@"获奖视频"] selectedItemIndex:0];
    self.pageMenu.bridgeScrollView = (UIScrollView *)_pageView.horizontalCollectionView;
}

#pragma mark - delegate
- (NSInteger)numberOfSectionPageView:(JAHorizontalPageView *)view   // 返回几个控制器
{
    return 2;
}

- (UIScrollView *)horizontalPageView:(JAHorizontalPageView *)pageView viewAtIndex:(NSInteger)index   // 返回每个控制器的view
{
    MOLExaminePacketListViewController *vc = [[MOLExaminePacketListViewController alloc] init];
    if (index == 0) {
        vc.type = 0;
        self.examineVideoVC = vc;
    }else{
        vc.type = 1;
        self.prizeVideoVC = vc;
    }
    vc.rewardId = self.rewardId;
    vc.view.backgroundColor = [UIColor clearColor];
    [self addChildViewController:vc];
    return (UIScrollView *)vc.packetModeView.tableView;
}

- (UIView *)headerViewInPageView:(JAHorizontalPageView *)pageView     // 返回头部
{
    return [UIView new];
}

- (CGFloat)headerHeightInPageView:(JAHorizontalPageView *)pageView    // 返回头部高度
{
    return 0;
}

- (CGFloat)topHeightInPageView:(JAHorizontalPageView *)pageView   // 控制在什么地方悬停
{
    return 0;
}

// 滚动的偏移量（相对位置）
- (void)horizontalPageView:(JAHorizontalPageView *)pageView scrollTopOffset:(CGFloat)offset{}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    [_pageView scrollToIndex:toIndex];
    if (toIndex == 0) {
        [self.prizeVideoVC.packetModeView play_resume];
    }else{
        [self.examineVideoVC.packetModeView play_resume];
    }
}


#pragma mark - 导航条
- (void)setupNavigation
{
//    [self basevc_setCenterTitle:self.titleString titleColor:HEX_COLOR(0xffffff)];
    CBAutoScrollLabel *contentLabel = [[CBAutoScrollLabel alloc] init];
    contentLabel.textColor = HEX_COLOR(0xffffff);
    contentLabel.font = MOL_REGULAR_FONT(17);
    contentLabel.text = [NSString stringWithFormat:@"%@",self.titleString];
    contentLabel.width = 200;
    contentLabel.height = 30;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = contentLabel;
    
    [contentLabel observeApplicationNotifications];
}

#pragma mark - UI
- (void)setupExaminePacketModeViewControllerUI
{
    SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, MOL_StatusBarAndNavigationBarHeight, MOL_SCREEN_WIDTH, 40) trackerStyle:SPPageMenuTrackerStyleLineAttachment];
    _pageMenu = pageMenu;
    _pageMenu.backgroundColor = HEX_COLOR(0x0E0F1A);
    _pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
    _pageMenu.itemTitleFont = MOL_MEDIUM_FONT(16);
    _pageMenu.selectedItemTitleColor = HEX_COLOR(0xffffff);
    _pageMenu.unSelectedItemTitleColor = HEX_COLOR_ALPHA(0xffffff, 0.6);
    [_pageMenu setTrackerHeight:3 cornerRadius:1.5];
    _pageMenu.tracker.backgroundColor = HEX_COLOR(0xFFEC00);
    _pageMenu.needTextColorGradients = NO;
    _pageMenu.dividingLine.hidden = YES;
    _pageMenu.itemPadding = 20;
    _pageMenu.delegate = self;
    [self.view addSubview:_pageMenu];
    
    UIView *lineView = [[UIView alloc] init];
    _lineView = lineView;
    lineView.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.1);
    lineView.width = MOL_SCREEN_WIDTH;
    lineView.height = 1;
    lineView.y = pageMenu.bottom;
    [self.view addSubview:lineView];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    _pageView = [[JAHorizontalPageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height-pageMenu.bottom) delegate:self];
    _pageView.horizontalCollectionView.scrollEnabled = NO;
    [self.view addSubview:_pageView];
    _pageView.backgroundColor = [UIColor clearColor];
    self.pageView.y = lineView.bottom;
}

- (void)calculatorExaminePacketModeViewControllerFrame{}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self calculatorExaminePacketModeViewControllerFrame];
}

@end
