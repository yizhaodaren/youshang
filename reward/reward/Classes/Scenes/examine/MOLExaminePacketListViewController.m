//
//  MOLExaminePacketListViewController.m
//  reward
//
//  Created by moli-2017 on 2018/9/18.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLExaminePacketListViewController.h"
#import "MOLExamineViewModel.h"

#import "MOLVideoOutsideGroupModel.h"

@interface MOLExaminePacketListViewController ()
@property (nonatomic, strong) MOLExamineViewModel *packetListViewModel;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL refreshMethodMore;
@end

@implementation MOLExaminePacketListViewController

- (BOOL)showNavigationLine
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.packetListViewModel = [[MOLExamineViewModel alloc] init];
    [self setupExaminePacketListViewControllerUI];
    [self bindingViewModel];
    
    @weakify(self);
    self.packetModeView.tableView.mj_footer = [MOLDIYRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self request_getExaminePacketListDataWithMore:YES];
    }];
    
    self.packetModeView.tableView.mj_footer.hidden = YES;
    
    [self request_getExaminePacketListDataWithMore:NO];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 友盟统计
    [MobClick beginLogPageView:@"_pv_vote_satisfaction"];
    [MobClick event:@"_pv_vote_satisfaction"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 友盟统计
    [MobClick endLogPageView:@"_pv_vote_satisfaction"];
}

#pragma mark - 网络请求
- (void)request_getExaminePacketListDataWithMore:(BOOL)isMore
{
    
    self.refreshMethodMore = isMore;
    if (!isMore) {
        self.currentPage = 1;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.type == 0) {
        dic[@"pageNum"] = @(self.currentPage);
        dic[@"pageSize"] = @(MOL_REQUEST_COUNT_VEDIO);
        dic[@"rewardId"] = self.rewardId;
//        dic[@"sort"] = @(3);
    }else{
        dic[@"pageNum"] = @(self.currentPage);
        dic[@"pageSize"] = @(MOL_REQUEST_COUNT_VEDIO);
        dic[@"rewardId"] = self.rewardId;
        dic[@"isReward"] = @(1);
    }
    // 获取视频
    [self.packetListViewModel.examinePacketCommand execute:dic];
}

#pragma mark - bindingViewModel
- (void)bindingViewModel
{
    @weakify(self);
    [self.packetListViewModel.examinePacketCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        [self.packetModeView.tableView.mj_footer endRefreshing];
        
        MOLVideoOutsideGroupModel *groupModel = (MOLVideoOutsideGroupModel *)x;
        
        if (groupModel.code != MOL_SUCCESS_REQUEST) {
            return ;
        }
        
        if (!self.refreshMethodMore) {
            [self.packetModeView.dataSourceArray removeAllObjects];
        }
        
        [self.packetModeView.dataSourceArray addObjectsFromArray:groupModel.resBody];
        [self.packetModeView.tableView reloadData];
        
        if (self.packetModeView.dataSourceArray.count >= groupModel.total) {
            self.packetModeView.tableView.mj_footer.hidden = YES;
        }else{
            self.packetModeView.tableView.mj_footer.hidden = NO;
            self.currentPage += 1;
        }
        
        if (!self.packetModeView.dataSourceArray.count) {
            [self basevc_showBlankPageWithY:0 image:nil title:@"暂无任何作品" superView:self.packetModeView.tableView];
        }else{
            [self basevc_hiddenErrorView];
        }
    }];
}

#pragma mark - 按钮点击


#pragma mark - UI
- (void)setupExaminePacketListViewControllerUI
{
    MOLExaminePacketModeView *packetModeView = [[MOLExaminePacketModeView alloc] init];
    _packetModeView = packetModeView;
    [self.view addSubview:packetModeView];
}

- (void)calculatorExaminePacketListViewControllerFrame
{
    self.packetModeView.frame = self.view.bounds;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self calculatorExaminePacketListViewControllerFrame];
}
@end
