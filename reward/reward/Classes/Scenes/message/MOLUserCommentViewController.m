//
//  MOLUserCommentViewController.m
//  reward
//
//  Created by moli-2017 on 2018/9/17.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLUserCommentViewController.h"
#import "MOLUserCommentCell.h"
#import "MOLMessagePageRequest.h"
#import "RecommendViewController.h"
#import "RewardDetailViewController.h"

@interface MOLUserCommentViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation MOLUserCommentViewController
- (BOOL)showNavigationLine
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSourceArray = [NSMutableArray array];
    [self setupNavigation];
    [self setupUserCommentViewControllerUI];
    
    @weakify(self);
    self.tableView.mj_header = [MOLDIYRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        
        [self request_getCommentListWithMore:NO];
    }];
    self.tableView.mj_footer = [MOLDIYRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        
        [self request_getCommentListWithMore:YES];
    }];
    self.tableView.mj_footer.hidden = YES;
    
    
    [self request_getCommentListWithMore:NO];
}

#pragma mark - 网络请求
- (void)request_getCommentListWithMore:(BOOL)isMore
{
    if (!isMore) {
        self.currentPage = 1;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pageNum"] = @(self.currentPage);
    dic[@"pageSize"] = @(MOL_REQUEST_COUNT_OTHER);
    dic[@"msgType"] = @(2);
    MOLMessagePageRequest *r = [[MOLMessagePageRequest alloc] initRequest_commentListWithParameter:dic];;
    
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        
        // 解析数据
        MOLMsgCommentGroupModel *groupModel = (MOLMsgCommentGroupModel *)responseModel;
        
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
            [self basevc_showBlankPageWithY:0 image:nil title:@"你还没有评论\n赶快去拍摄精彩悬赏视频吧！" superView:self.view];
        }else{
            [self basevc_hiddenErrorView];
        }
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self basevc_showErrorPageWithY:0 select:@selector(refresh_again) superView:self.view];
    }];
}

- (void)refresh_again
{
    [self basevc_hiddenErrorView];
    [self request_getCommentListWithMore:NO];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 跳转作品或者悬赏
    MOLMsgCommentModel *m = self.dataSourceArray[indexPath.row];
    
    if (!m.avatar.length) {
        [MBProgressHUD showMessageAMoment:@"视频不见了!"];
        return;
    }
    
    if ([m.type isEqualToString:@"REWARD"]) {

        RecommendViewController *vc = [[RecommendViewController alloc] init];
        PLMediaInfo *info = [[PLMediaInfo alloc] init];
        info.index = 0;
        info.rewardId = [NSString stringWithFormat:@"%@",m.typeId];
        info.userId = @"";
        info.businessType = HomePageBusinessType_RewardDetail;
        info.pageNum =1;
        info.pageSize =MOL_REQUEST_COUNT_VEDIO;
        vc.mediaDto = info;
        
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
        
    }else if([m.type isEqualToString:@"STORY"]){
        RecommendViewController *vc = [[RecommendViewController alloc] init];
        PLMediaInfo *info = [[PLMediaInfo alloc] init];
        info.index = 0;
        info.rewardId = [NSString stringWithFormat:@"%@",m.typeId];
        info.userId = @"";
        info.businessType = HomePageBusinessType_StoryDetail;
        info.pageNum =1;
        info.pageSize =MOL_REQUEST_COUNT_VEDIO;
        vc.mediaDto = info;
        
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
    }
    
    // HomePageBusinessType_RewardDetail, //悬赏详情
//    HomePageBusinessType_StoryDetail,  //作品详情
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
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MOLMsgCommentModel *m = self.dataSourceArray[indexPath.row];
    MOLUserCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MOLUserCommentCell_id"];
    cell.commentModel = m;
    return cell;
}

#pragma mark - UI
- (void)setupUserCommentViewControllerUI
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
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
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[MOLUserCommentCell class] forCellReuseIdentifier:@"MOLUserCommentCell_id"];
    [self.view addSubview:tableView];
    
}

- (void)calculatorUserCommentViewControllerFrame
{
    self.tableView.frame = self.view.bounds;
    self.tableView.height = self.view.height - MOL_StatusBarAndNavigationBarHeight;
    self.tableView.y = MOL_StatusBarAndNavigationBarHeight;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, MOL_TabbarSafeBottomMargin, 0);
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self calculatorUserCommentViewControllerFrame];
}

- (void)setupNavigation
{
    [self basevc_setCenterTitle:@"评论" titleColor:HEX_COLOR(0xffffff)];
}

@end
