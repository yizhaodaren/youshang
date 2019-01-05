//
//  MOLExamineViewController.m
//  reward
//
//  Created by moli-2017 on 2018/9/15.
//  Copyright © 2018年 reward. All rights reserved.

/*
    (评选)审核悬赏列表
 */

#import "MOLExamineViewController.h"
#import "MOLExamineView.h"
#import "MOLExamineViewModel.h"

#import "MOLVideoOutsideGroupModel.h"

@interface MOLExamineViewController ()
@property (nonatomic, strong) MOLExamineViewModel *examineListViewModel;
@property (nonatomic, weak) MOLExamineView *examineView;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL refreshMethodMore;
@end

@implementation MOLExamineViewController

- (BOOL)showNavigationLine
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.examineListViewModel = [[MOLExamineViewModel alloc] init];
    
    [self setupNavigation];
    [self setupExamineViewControllerUI];
    
    [self bindingExamineListViewModel];
    
    @weakify(self);
    self.examineView.tableView.mj_footer = [MOLDIYRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self request_getExamineListData:YES];
    }];
    
    self.examineView.tableView.mj_footer.hidden = YES;
    
    [self request_getExamineListData:NO];
}

#pragma mark - bingdingViewModel
- (void)bindingExamineListViewModel
{
    @weakify(self);
    [self.examineListViewModel.examineListCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        [self.examineView.tableView.mj_footer endRefreshing];
        
        MOLVideoOutsideGroupModel *groupModel = (MOLVideoOutsideGroupModel *)x;
        
        if (groupModel.code != MOL_SUCCESS_REQUEST) {
            [self basevc_showErrorPageWithY:0 select:@selector(refresh_again) superView:self.view];
            return ;
        }
        
        if (!self.refreshMethodMore) {
            [self.examineView.dataSourceArray removeAllObjects];
        }
        
        [self.examineView.dataSourceArray addObjectsFromArray:groupModel.resBody];
        [self.examineView.tableView reloadData];
        
        if (self.examineView.dataSourceArray.count >= groupModel.total) {
            self.examineView.tableView.mj_footer.hidden = YES;
        }else{
            self.examineView.tableView.mj_footer.hidden = NO;
            self.currentPage += 1;
        }
        
        if (!self.examineView.dataSourceArray.count) {
            [self basevc_showBlankPageWithY:0 image:nil title:@"你还有评选\n赶快去发布悬赏视频吧" superView:self.view];
        }else{
            [self basevc_hiddenErrorView];
        }
        
    }];
}

- (void)refresh_again
{
    [self basevc_hiddenErrorView];
    [self request_getExamineListData:NO];
}

#pragma mark - 网络请求
- (void)request_getExamineListData:(BOOL)isMore
{   
    self.refreshMethodMore = isMore;
    if (!isMore) {
        self.currentPage = 1;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pageNum"] = @(self.currentPage);
    dic[@"pageSize"] = @(MOL_REQUEST_COUNT_VEDIO);
    
    [self.examineListViewModel.examineListCommand execute:dic];
}

#pragma mark - 导航条
- (void)setupNavigation
{
    [self basevc_setCenterTitle:@"评选" titleColor:HEX_COLOR(0xffffff)];
}

#pragma mark - UI
- (void)setupExamineViewControllerUI
{
    MOLExamineView *examineView = [[MOLExamineView alloc] init];
    _examineView = examineView;
    [self.view addSubview:examineView];
}

- (void)calculatorExamineViewControllerFrame
{
    self.examineView.frame = self.view.bounds;
    self.examineView.y = MOL_StatusBarAndNavigationBarHeight;
    self.examineView.height = self.view.height - self.examineView.y;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self calculatorExamineViewControllerFrame];
}
@end
