//
//  MOLWalletViewController.m
//  reward
//
//  Created by moli-2017 on 2018/9/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLWalletViewController.h"
#import "MOLRechargeViewController.h"
#import "MOLWithdrawViewController.h"
#import "MOLWebViewController.h"
#import "MOLHostHead.h"

@interface MOLWalletViewController ()<JAHorizontalPageViewDelegate, SPPageMenuDelegate>
@property (nonatomic, strong) JAHorizontalPageView *pageView;
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic, weak) UIView *lineView;

@end

@implementation MOLWalletViewController

- (BOOL)showNavigationLine
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupWalletViewControllerUI];
    [self setupNavigation];
    
    [self.pageView reloadPage];
    
    [self.pageMenu setItems:@[@"钻石",@"金币"] selectedItemIndex:0];
    self.pageMenu.bridgeScrollView = (UIScrollView *)_pageView.horizontalCollectionView;
}

#pragma mark - 按钮点击
- (void)button_clickJump
{
    MOLWebViewController *vc = [[MOLWebViewController alloc] init];
    NSString *offic = MOL_OFFIC_SERVICE_H5;  // 正式
#ifdef MOL_TEST_HOST
    offic = MOL_TEST_SERVICE;  // 测试
#endif
    vc.urlString = [NSString stringWithFormat:@"%@/static/views/app/bank/bill.html",offic];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - delegate
- (NSInteger)numberOfSectionPageView:(JAHorizontalPageView *)view   // 返回几个控制器
{
    return 2;
}

- (UIScrollView *)horizontalPageView:(JAHorizontalPageView *)pageView viewAtIndex:(NSInteger)index   // 返回每个控制器的view
{
    if (index == 0) {
        MOLRechargeViewController *vc = [[MOLRechargeViewController alloc] init];
        vc.view.backgroundColor = [UIColor clearColor];
        [self addChildViewController:vc];
        return (UIScrollView *)vc.tableView;
    }else{
        MOLWithdrawViewController *vc = [[MOLWithdrawViewController alloc] init];
        vc.view.backgroundColor = [UIColor clearColor];
        [self addChildViewController:vc];
        return (UIScrollView *)vc.tableView;
    }
    
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
}


#pragma mark - 导航条
- (void)setupNavigation
{
    [self basevc_setCenterTitle:@"我的钱包" titleColor:HEX_COLOR(0xffffff)];
    UIBarButtonItem *rightItem = [UIBarButtonItem mol_barButtonItemWithTitleName:@"账单" color:HEX_COLOR_ALPHA(0xffffff, 0.9) disableColor:HEX_COLOR_ALPHA(0xffffff, 0.9) font:MOL_MEDIUM_FONT(14) targat:self action:@selector(button_clickJump)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - UI
- (void)setupWalletViewControllerUI
{
    SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, MOL_StatusBarAndNavigationBarHeight, MOL_SCREEN_WIDTH, 40) trackerStyle:SPPageMenuTrackerStyleLineAttachment];
    _pageMenu = pageMenu;
    _pageMenu.backgroundColor = HEX_COLOR(0x161824);
    _pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
    _pageMenu.itemTitleFont = MOL_MEDIUM_FONT(16);
    _pageMenu.selectedItemTitleColor = HEX_COLOR(0xffffff);
    _pageMenu.unSelectedItemTitleColor = HEX_COLOR_ALPHA(0xffffff, 0.6);
    [_pageMenu setTrackerHeight:3 cornerRadius:1.5];
    _pageMenu.tracker.backgroundColor = HEX_COLOR(0xFFEC00);
    _pageMenu.needTextColorGradients = NO;
    _pageMenu.dividingLine.hidden = YES;
    _pageMenu.itemPadding = 0;
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

- (void)calculatorWalletViewControllerFrame{}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self calculatorWalletViewControllerFrame];
}
@end
