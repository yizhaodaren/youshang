//
//  MOLMyRewarViewController.m
//  reward
//
//  Created by moli-2017 on 2018/9/12.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLMyRewarViewController.h"
#import "MOLMineRewardCell.h"
#import "MOLUserPageRequest.h"
#import "RewardDetailViewController.h"

@interface MOLMyRewarViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation MOLMyRewarViewController

- (BOOL)showNavigation
{
    return self.showNav;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSourceArray = [NSMutableArray array];
    
    [self setupMyLikeViewControllerUI];
    
    @weakify(self);
    self.tableView.mj_footer = [MOLDIYRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        
        [self request_getRewardDataList:YES];
    }];
    self.tableView.mj_footer.hidden = YES;
    
    [self request_getRewardDataList:NO];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserReward) name:MOL_SUCCESS_PUBLISH_REWARD object:nil];
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
    dic[@"pageNum"] = @(self.currentPage);
    dic[@"pageSize"] = @(MOL_REQUEST_COUNT_VEDIO);
    dic[@"userId"] = self.userId;
    
    MOLUserPageRequest *r = [[MOLUserPageRequest alloc] initRequest_getRewardListWithParameter:dic];
    
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        
        [self.tableView.mj_footer endRefreshing];
        
        // 解析数据
        MOLVideoOutsideGroupModel *groupModel = (MOLVideoOutsideGroupModel *)responseModel;
        
        if (!isMore) {
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
            [self basevc_showBlankPageWithY:-414 image:nil title:@"你还没有发布任何悬赏" superView:self.tableView];
        }else{
            [self basevc_hiddenErrorView];
        }
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        [self.tableView.mj_footer endRefreshing];
        [self basevc_showErrorPageWithY:-414 select:@selector(refresh_again) superView:self.tableView];
    }];
}

- (void)refresh_again
{
    [self basevc_hiddenErrorView];
    [self request_getRewardDataList:NO];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MOLVideoOutsideModel *model = self.dataSourceArray[indexPath.row];
    RewardDetailViewController *vc = [[RewardDetailViewController alloc] init];
    vc.rewardModel = model;
    [self.navigationController pushViewController:vc animated:YES];
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
    return model.rewardVO.cardHeight;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MOLVideoOutsideModel *model = self.dataSourceArray[indexPath.row];
    
    MOLMineRewardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MOLMineRewardCell_id"];
    if (self.isOwner) {
        cell.cellType = MOLMineRewardCellType_mine;
    }else{
        cell.cellType = MOLMineRewardCellType_other;
    }
    cell.cardModel = model.rewardVO;
    cell.videooutModel = model;
    return cell;
}

#pragma mark - UI
- (void)setupMyLikeViewControllerUI
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
    [tableView registerClass:[MOLMineRewardCell class] forCellReuseIdentifier:@"MOLMineRewardCell_id"];
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
