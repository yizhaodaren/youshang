//
//  MOLDiscoverViewController.m
//  reward
//
//  Created by moli-2017 on 2018/9/11.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLDiscoverViewController.h"
#import "RewardCell.h"
#import "AdScrollerView.h"
#import "SearchViewController.h"
#import "BannerModel.h"
#import "RewardDetailViewController.h"
#import "MOLUserPageRequest.h"
#import "MOLExamineCardModel.h"
#import "MOLVideoOutsideModel.h"
#import "MOLMineViewController.h"
#import "MOLOtherUserViewController.h"
#import "MOLGlobalManager.h"
#import "RewardRequest.h"
#import "MOLBannerSetModel.h"
#import "MOLWebViewController.h"
#import "MOLVideoOutsideGroupModel.h"

#import "MOLMusicDetailViewController.h"
#import "MOLHotMusicCell.h"
#import "MOLMusicRequest.h"


static CGFloat kHeaderViewHeight =220;

@interface MOLDiscoverViewController ()<UITableViewDelegate,UITableViewDataSource,RewardCellDelegate,DemoScrollerViewDelegate>
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)NSMutableArray *adArr;
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) AdScrollerView *headerView;
@property (nonatomic,strong) UIView *searchView;
@property (nonatomic,assign)NSInteger pageSize;
@property (nonatomic,assign)NSInteger pageNumber;
@property (nonatomic,assign)UIBehaviorTypeStyle refreshType;
@property (nonatomic,strong)UIImageView *searchBackgroundView;
@property (nonatomic,strong)UIView *headerBottom;
@property (nonatomic,strong)UIImageView *emptyImgView;

@end

@implementation MOLDiscoverViewController



- (BOOL)showNavigation{
    return NO;
}

- (UIImageView *)emptyImgView{
    if (!_emptyImgView) {
        _emptyImgView =[UIImageView new];
        [_emptyImgView setImage: [UIImage imageNamed:@"悬赏-敬请期待"]];
        [_emptyImgView setFrame:CGRectMake(0,0, MOL_SCREEN_WIDTH, MOL_SCREEN_HEIGHT)];
        [_emptyImgView setUserInteractionEnabled:YES];
    }
    return _emptyImgView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //    if ([MOLSwitchManager shareSwitchManager].normalStatus != 1) {//审核使用
    //        if (self.emptyImgView.isHidden) {
    //            [self.emptyImgView setHidden:NO];
    //        }
    //
    //    }else{ //正常使用
    //        if (!self.emptyImgView.isHidden) {
    //            [self.emptyImgView setHidden:YES];
    //        }
    //        if (!self.dataSource.count) {
    //            [self getRewardList];
    //            [self getBannerData];
    //        }
    //    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self layoutUI];
    
    //    if ([MOLSwitchManager shareSwitchManager].normalStatus == 1) {//正常使用
    [self getRewardList];
    [self getBannerData];
    
    //    }else{//审核使用
    //        [self.view addSubview:self.emptyImgView];
    //        [self.view bringSubviewToFront:self.emptyImgView];
    //    }
}

- (void)initData{
    self.dataSource = NSMutableArray.new;
    self.adArr =[NSMutableArray new];
    self.pageSize =MOL_REQUEST_COUNT_OTHER;
    self.pageNumber =1;
}

- (void)layoutUI{
    [self.view addSubview:self.tableView];
    
    [self.headerView addSubview:self.headerBottom];
    
    [self.searchBackgroundView setFrame:CGRectMake(0,0, MOL_SCREEN_WIDTH, 130/2.0)];
    [self.view addSubview:self.searchBackgroundView];
}

- (AdScrollerView *)headerView{
    
    if (!_headerView) {
        _headerView =[[AdScrollerView alloc] initWithFrame:CGRectMake(0, 0, MOL_SCREEN_WIDTH, kHeaderViewHeight)];
        _headerView.delegate =self;
    }
    
    return _headerView;
    
}

- (UIImageView *)searchBackgroundView{
    if (!_searchBackgroundView) {
        _searchBackgroundView=[UIImageView new];
        [_searchBackgroundView setImage: [UIImage imageNamed:@"top_shadow"]];
    }
    return _searchBackgroundView;
}

- (UIView *)headerBottom{
    if (!_headerBottom) {
        _headerBottom =[UIView new];
        [_headerBottom setBackgroundColor: HEX_COLOR(0x0E0F1A)];
        [self.headerBottom setFrame:CGRectMake(0, 210, MOL_SCREEN_WIDTH, 10)];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.headerBottom.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12, 12)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.headerBottom.bounds;
        maskLayer.path = maskPath.CGPath;
        self.headerBottom.layer.mask = maskLayer;
    }
    return _headerBottom;
}


- (UIView *)searchView{
    if (!_searchView) {
        _searchView =[UIView new];
        _searchView.backgroundColor = HEX_COLOR_ALPHA(0x000000, 0.4);
        [_searchView setFrame:CGRectMake(15, MOL_StatusBarHeight+4, MOL_SCREEN_WIDTH-15*2.0, 35)];
        _searchView.layer.masksToBounds=YES;
        _searchView.layer.cornerRadius=35/2.0;
        UITapGestureRecognizer *searchTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchViewEvent:)];
        [_searchView addGestureRecognizer:searchTap];
        
        UIImageView *searchImage =[UIImageView new];
        [searchImage setImage:[UIImage imageNamed:@"search_"]];
        [_searchView addSubview:searchImage];
        
        UILabel *titleLable =[UILabel new];
        [titleLable setTextColor: HEX_COLOR_ALPHA(0xffffff,0.5)];
        [titleLable setFont: MOL_REGULAR_FONT(13)];
        [titleLable setText:@"搜索用户昵称或CCid账号"];
        [_searchView addSubview:titleLable];
        
        [searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo((35-16)/2.0);
            make.width.height.mas_equalTo(16);
        }];
        
        [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(searchImage.mas_right).offset(5);
            make.top.mas_equalTo(self->_searchView);
            make.height.mas_equalTo(35);
            make.right.mas_equalTo(self->_searchView);
        }];
        
    }
    return _searchView;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, MOL_SCREEN_WIDTH, MOL_SCREEN_HEIGHT-MOL_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setBackgroundColor:HEX_COLOR_ALPHA(0x0E0F1A, 1)];
        [_tableView.tableHeaderView setBackgroundColor: [UIColor clearColor]];
        [_tableView.backgroundView setBackgroundColor: [UIColor clearColor]];
        _tableView.tableHeaderView =self.headerView;
        
        
        __weak typeof(self) wself = self;
        _tableView.mj_header = [MOLDIYRefreshHeader headerWithRefreshingBlock:^{
            
            [wself refresh];
        }];
        _tableView.mj_footer = [MOLDIYRefreshFooter footerWithRefreshingBlock:^{
            
            [wself loadMore];
        }];
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets =NO;
        }
        
        _tableView.mj_footer.hidden = YES;
        
    }
    return _tableView;
}
#pragma mark -
#pragma mark UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MOLVideoOutsideModel *model =[MOLVideoOutsideModel new];
    if (indexPath.row<self.dataSource.count) {
        model =self.dataSource[indexPath.row];
    }
    
    if(model.contentType == 1 ){
        return model.rewardVO.rewardCellHeight;
    }else{//音乐
        return 15 + 40 + 10  + 10 + 154 + 15 + 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MOLVideoOutsideModel *model =[MOLVideoOutsideModel new];
    if (indexPath.row<self.dataSource.count) {
        model =self.dataSource[indexPath.row];
    }
    if (model.contentType == 3) {
        //音乐
        static NSString * const MOLHotMusicCellId = @"MOLHotMusicCell";
        MOLHotMusicCell *rewardCell =[tableView dequeueReusableCellWithIdentifier:MOLHotMusicCellId];
        if (rewardCell ==nil) {
            rewardCell =[[MOLHotMusicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MOLHotMusicCellId];
            rewardCell.selectionStyle=UITableViewCellSelectionStyleNone;
            rewardCell.delegate=self;
        }
        [rewardCell rewardCell:model indexPath:indexPath];
        return rewardCell;
    }else{
        
        //悬赏
        static NSString * const rewardCellId = @"rewardCell";
        RewardCell *rewardCell =[tableView dequeueReusableCellWithIdentifier:rewardCellId];
        if (rewardCell ==nil) {
            rewardCell =[[RewardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rewardCellId];
            rewardCell.selectionStyle=UITableViewCellSelectionStyleNone;
            rewardCell.delegate=self;
        }
        [rewardCell rewardCell:model indexPath:indexPath];
        return rewardCell;
    }

    
}

#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MOLVideoOutsideModel *model =[MOLVideoOutsideModel new];
    if (indexPath.row<self.dataSource.count) {
        model =self.dataSource[indexPath.row];
    }
    if(model.contentType == 1 ){
        RewardDetailViewController *rewardDetail =[RewardDetailViewController new];
        rewardDetail.rewardModel =model;
        [self.navigationController pushViewController:rewardDetail
                                             animated:YES];
    }else if(model.contentType == 3){
        //进入音乐
        //WSC
        if (model.musicStoryVO.musicId > 0) {
            MOLMusicDetailViewController * rewardDetail = [MOLMusicDetailViewController new];
            rewardDetail.musicId = model.musicStoryVO.musicId;
            [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:rewardDetail animated:YES];
        }
    }
}

#pragma mark -
#pragma mark RewardCellDelegate
- (void)playCountEvent:(UIButton *)sender indexPath:(nonnull NSIndexPath *)indexPath{
    RewardDetailViewController *rewardDetail =[RewardDetailViewController new];
    MOLVideoOutsideModel *model =[MOLVideoOutsideModel new];
    if (indexPath.row<self.dataSource.count) {
        model =self.dataSource[indexPath.row];
    }
    rewardDetail.rewardModel =model;
    [self.navigationController pushViewController:rewardDetail
                                         animated:YES];
}

- (void)rewardCellAvatarEvent:(NSIndexPath *)indexPath{
    if (indexPath) {
        MOLVideoOutsideModel *model =[MOLVideoOutsideModel new];
        if (indexPath.row<self.dataSource.count) {
            model =self.dataSource[indexPath.row];
        }
        if ([[MOLGlobalManager shareGlobalManager] isUserself:model.rewardVO.userVO]) {
            MOLMineViewController *mineView =[MOLMineViewController new];
            [self.navigationController pushViewController:mineView animated:YES];
        }else{
            MOLOtherUserViewController *otherView =[MOLOtherUserViewController new];
            otherView.userId = model.rewardVO.userVO.userId?model.rewardVO.userVO.userId:@"";
            [self.navigationController pushViewController:otherView animated:YES];
            
        }
    }
}

#pragma mark
#pragma mark 获取悬赏列表
- (void)refresh{
    self.pageNumber =1;
    self.refreshType =UIBehaviorTypeStyle_Refresh;
    [self getRewardList];
    [self getBannerData];
    
};

- (void)loadMore{
    self.pageNumber++;
    self.refreshType =UIBehaviorTypeStyle_More;
    [self getRewardList];
}
//- (void)getRewardList{
//    // MOLUserModel *user = [MOLUserManagerInstance user_getUserInfo];
//
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    dic[@"pageNum"] = @(self.pageNumber);
//    dic[@"pageSize"] = @(MOL_REQUEST_COUNT_VEDIO);
//    // dic[@"userId"] = user.userId?user.userId:@"";
//    dic[@"isFinish"] = @(0);
//    __weak typeof(self) wself = self;
//    [[[MOLUserPageRequest alloc] initRequest_getRewardListWithParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
//        if (wself.refreshType != UIBehaviorTypeStyle_Normal) {
//            [wself.tableView.mj_header endRefreshing];
//            [wself.tableView.mj_footer endRefreshing];
//        }
//        if (code == MOL_SUCCESS_REQUEST) {
//            if (responseModel) {
//                // 解析数据
//                MOLVideoOutsideGroupModel *mediaInfoList = (MOLVideoOutsideGroupModel *)responseModel;
//
//                if (wself.refreshType != UIBehaviorTypeStyle_More) {
//                    [wself.dataSource removeAllObjects];
//                }
//
//                // 添加到数据源
//                [wself.dataSource addObjectsFromArray:mediaInfoList.resBody];
//                [wself.tableView reloadData];
//
//                if (wself.dataSource.count >= mediaInfoList.total) {
//                    wself.tableView.mj_footer.hidden = YES;
//
//                }else{
//                    wself.tableView.mj_footer.hidden = NO;
//
//                }
//            }
//        }else{
//            [OMGToast showWithText:message];
//        }
//
//        if (wself.dataSource.count) {
//            [wself basevc_hiddenErrorView];
//        }
//
//    } failure:^(__kindof MOLBaseNetRequest *request) {
//        if (wself.refreshType != UIBehaviorTypeStyle_Normal) {
//            [wself.tableView.mj_header endRefreshing];
//            [wself.tableView.mj_footer endRefreshing];
//        }
//
//        if (!wself.dataSource.count) {
//            [wself basevc_showErrorPageWithY:0 select:@selector(refresh) superView:wself.view];
//        }else{
//            [wself basevc_hiddenErrorView];
//        }
//    }];
//}
- (void)getRewardList{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pageNum"] = @(self.pageNumber);
    dic[@"pageSize"] = @(MOL_REQUEST_COUNT_VEDIO);
    
    __weak typeof(self) wself = self;
    [[[MOLMusicRequest alloc] initRequest_MusicAndRewardWithParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        if (wself.refreshType != UIBehaviorTypeStyle_Normal) {
            [wself.tableView.mj_header endRefreshing];
            [wself.tableView.mj_footer endRefreshing];
        }
        if (code == MOL_SUCCESS_REQUEST) {
            if (responseModel) {
                // 解析数据
                MOLVideoOutsideGroupModel *mediaInfoList = (MOLVideoOutsideGroupModel *)responseModel;
                
                if (wself.refreshType != UIBehaviorTypeStyle_More) {
                    [wself.dataSource removeAllObjects];
                }
                
                // 添加到数据源
                [wself.dataSource addObjectsFromArray:mediaInfoList.resBody];
                [wself.tableView reloadData];
                
                if (wself.dataSource.count >= mediaInfoList.total) {
                    wself.tableView.mj_footer.hidden = YES;
                    
                }else{
                    wself.tableView.mj_footer.hidden = NO;
                    
                }
            }
        }else{
            [OMGToast showWithText:message];
        }
        
        if (wself.dataSource.count) {
            [wself basevc_hiddenErrorView];
        }
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        if (wself.refreshType != UIBehaviorTypeStyle_Normal) {
            [wself.tableView.mj_header endRefreshing];
            [wself.tableView.mj_footer endRefreshing];
        }
        
        if (!wself.dataSource.count) {
            [wself basevc_showErrorPageWithY:0 select:@selector(refresh) superView:wself.view];
        }else{
            [wself basevc_hiddenErrorView];
        }
    }];
}
- (void)getBannerData{
    __weak typeof(self) wself = self;
    [[[RewardRequest alloc] initRequest_BannerParameter:@{}] baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        
        if (code == MOL_SUCCESS_REQUEST) {
            if (responseModel) {
                // 解析数据
                MOLBannerSetModel *mediaInfoList = (MOLBannerSetModel *)responseModel;
                wself.adArr =[NSMutableArray arrayWithArray:mediaInfoList.resBody];
                
                [wself.headerView setContent:wself.adArr];
                
                [wself.headerView addSubview:wself.searchView];
                [wself.headerView addSubview:wself.headerBottom];
                
            }
        }else{
            
        }
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        
    }];
}

#pragma mark-
#pragma mark 搜索框触发事件
- (void)searchViewEvent:(UITapGestureRecognizer *)sender{
    [self.navigationController pushViewController:SearchViewController.new animated:YES];
}

#pragma mark-
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
            MOLWebViewController *vc = [[MOLWebViewController alloc] init];
            vc.urlString =model.typeInfo?model.typeInfo:@"";
            [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
            
        }
    }
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
