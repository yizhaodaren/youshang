//
//  MOLRewardListViewController.m
//  reward
//
//  Created by apple on 2018/9/22.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLRewardListViewController.h"
#import "MOLRcRewardCell.h"
#import "MOLUserPageRequest.h"
#import "RewardDetailViewController.h"
@interface MOLRewardListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation MOLRewardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    self.dataSourceArray = [NSMutableArray array];
    @weakify(self);
    self.tableView.mj_header = [MOLDIYRefreshHeader headerWithRefreshingBlock:^{
        [self request_getRewardDataList:NO];
        //刷新banner
        if (self.requestBannerBlock) {
            self.requestBannerBlock();
        }
    }];
    
    self.tableView.mj_footer = [MOLDIYRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        
        [self request_getRewardDataList:YES];
    }];
    self.tableView.mj_footer.hidden = YES;
    
    [self.tableView.mj_header beginRefreshing];
    
//     [self request_getRewardDataList:NO];
}

- (void)getUserReward
{
    [self request_getRewardDataList:NO];
}
#pragma mark - 网络请求
- (void)request_getRewardDataList:(BOOL)isMore
{
    if (!isMore) {
        self.currentPage = 1;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"isFinish"] = @(0);//0未结束的悬赏 1代表已经结束的
    dic[@"pageNum"] = @(self.currentPage);
    dic[@"pageSize"] = @(MOL_REQUEST_COUNT_OTHER);
    //    sort (integer, optional): 排序规则 1最新排序  3最豪排序 2推荐排序
    if (self.sortType == RewardRecommendType) {
        dic[@"sort"] = @(1);
    }else if(self.sortType == RewardHaoType){
         dic[@"sort"] = @(3);
    }else{
         dic[@"sort"] = @(2);
    }
    
    MOLUserPageRequest *r = [[MOLUserPageRequest alloc] initRequest_getRewardListWithParameter:dic];
    
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        
        [self.tableView.mj_footer endRefreshing];
        
        // 解析数据
        MOLVideoOutsideGroupModel *groupModel = (MOLVideoOutsideGroupModel *)responseModel;
        if (!isMore) {
            [self.tableView.mj_header endRefreshing];
            [self.dataSourceArray removeAllObjects];
        }
        
        // 添加到数据源
        [self.dataSourceArray addObjectsFromArray:groupModel.resBody];
        
        [self.tableView reloadData];
        
        if (self.dataSourceArray.count >= groupModel.total) {
            self.tableView.mj_footer.hidden = YES;
        }else{
            self.tableView.mj_footer.hidden = NO;
            self.currentPage += 1;
        }
        
        if (!self.dataSourceArray.count) {
            [self basevc_showBlankPageWithY:-414 image:nil title:@"暂无数据" superView:self.tableView];
        }else{
            [self basevc_hiddenErrorView];
        }
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}



#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RewardDetailViewController *rewardDetail =[RewardDetailViewController new];
    MOLVideoOutsideModel *model  = self.dataSourceArray[indexPath.row];
    rewardDetail.rewardModel  = model;
    [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:rewardDetail animated:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    MOLVideoOutsideModel *model = self.dataSourceArray[indexPath.row];
    return model.startRecordCardHeight;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MOLRcRewardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MOLRcRewardCell_cell_id"];
    MOLVideoOutsideModel *model = self.dataSourceArray[indexPath.row];
    cell.model = model;
    return cell;
}

#pragma mark - UI
- (void)initUI
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView = tableView;
    tableView.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[MOLRcRewardCell class] forCellReuseIdentifier:@"MOLRcRewardCell_cell_id"];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, MOL_TabbarHeight, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

- (void)calculatorMyLikeViewControllerFrame
{
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self calculatorMyLikeViewControllerFrame];
}

@end
