//
//  MOLUserRelationViewController.m
//  reward
//
//  Created by moli-2017 on 2018/9/17.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLUserRelationViewController.h"
#import "MOLUserRelationCell.h"
#import "MOLMessagePageRequest.h"
#import "MOLMineViewController.h"
#import "MOLOtherUserViewController.h"

@interface MOLUserRelationViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation MOLUserRelationViewController
- (BOOL)showNavigationLine
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSourceArray = [NSMutableArray array];
    [self setupNavigation];
    [self setupUserRelationViewControllerUI];
    
    @weakify(self);
    self.tableView.mj_header = [MOLDIYRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        
        [self request_getRelationListWithMore:NO];
    }];
    self.tableView.mj_footer = [MOLDIYRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        
        [self request_getRelationListWithMore:YES];
    }];
    self.tableView.mj_footer.hidden = YES;
    
    [self request_getRelationListWithMore:NO];
}

#pragma mark - 网络请求
- (void)request_getRelationListWithMore:(BOOL)isMore
{
    
    if (!isMore) {
        self.currentPage = 1;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pageNum"] = @(self.currentPage);
    dic[@"pageSize"] = @(MOL_REQUEST_COUNT_OTHER);
    dic[@"userId"] = self.userId;
    MOLMessagePageRequest *r;
    if (self.relationType == MOLUserRelationType_fans || self.relationType == MOLUserRelationType_msgFans) {
        r = [[MOLMessagePageRequest alloc] initRequest_fansListWithParameter:dic];
    }else{
        r = [[MOLMessagePageRequest alloc] initRequest_focusListWithParameter:dic];
    }
    
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        
         // 解析数据
         MOLMsgUserGroupModel *groupModel = (MOLMsgUserGroupModel *)responseModel;
         
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
            if (self.relationType == MOLUserRelationType_fans || self.relationType == MOLUserRelationType_fans) {
              [self basevc_showBlankPageWithY:0 image:nil title:@"你还没有粉丝\n快去拍摄精彩视频吸引粉丝吧！" superView:self.view];
            }else{
                 [self basevc_showBlankPageWithY:0 image:nil title:@"你还没有任何关注" superView:self.view];
            }
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
    [self request_getRelationListWithMore:NO];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MOLMsgUserModel *m = self.dataSourceArray[indexPath.row];
    
    if ([[MOLGlobalManager shareGlobalManager] isUserself:m.userVO]) {
        
        MOLMineViewController *vc = [[MOLMineViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        MOLOtherUserViewController *vc = [[MOLOtherUserViewController alloc] init];
        vc.userId = m.userVO.userId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
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
    MOLMsgUserModel *m = self.dataSourceArray[indexPath.row];
    MOLUserRelationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MOLUserRelationCell_id"];
    cell.type = self.relationType == MOLUserRelationType_msgFans ? 1 : 0;
    cell.userModel = m;
    return cell;
}

#pragma mark - UI
- (void)setupUserRelationViewControllerUI
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
    [tableView registerClass:[MOLUserRelationCell class] forCellReuseIdentifier:@"MOLUserRelationCell_id"];
    [self.view addSubview:tableView];
    
}

- (void)calculatorUserRelationViewControllerFrame
{
    self.tableView.frame = self.view.bounds;
    self.tableView.height = self.view.height - MOL_StatusBarAndNavigationBarHeight;
    self.tableView.y = MOL_StatusBarAndNavigationBarHeight;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, MOL_TabbarSafeBottomMargin, 0);
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self calculatorUserRelationViewControllerFrame];
}


#pragma mark - 导航条
- (void)setupNavigation
{
    NSString *userId = [MOLUserManagerInstance user_getUserId];
    BOOL isMe = [userId isEqualToString:self.userId];
    if (self.relationType == MOLUserRelationType_focus || self.relationType == MOLUserRelationType_fans) {
        NSString *title = isMe ? @"我的关注" : @"Ta的关注";
        [self basevc_setCenterTitle:title titleColor:HEX_COLOR(0xffffff)];
    }else{
        NSString *title = isMe ? @"我的粉丝" : @"Ta的粉丝";
        [self basevc_setCenterTitle:title titleColor:HEX_COLOR(0xffffff)];
    }
}
@end
