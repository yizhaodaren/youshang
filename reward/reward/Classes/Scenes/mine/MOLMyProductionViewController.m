//
//  MOLMyProductionViewController.m
//  reward
//
//  Created by moli-2017 on 2018/9/12.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLMyProductionViewController.h"
#import "MOLMineCollectionViewCell.h"
//#import "MOLMyDraftViewController.h"
#import "MOLUserPageRequest.h"
#import "RecommendViewController.h"

@interface MOLMyProductionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation MOLMyProductionViewController

- (BOOL)showNavigation
{
    return self.showNav;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSourceArray = [NSMutableArray array];
    
    [self setupMyProductionViewControllerUI];
    
    @weakify(self);
    self.collectionView.mj_footer = [MOLDIYRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        
        [self request_getProductionDataList:YES];
    }];
    self.collectionView.mj_footer.hidden = YES;
    
    [self request_getProductionDataList:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserProduction) name:MOL_SUCCESS_PUBLISH_PRODUCTION object:nil];
}

- (void)getUserProduction
{
    [self request_getProductionDataList:NO];
}

#pragma mark - 网络请求
- (void)request_getProductionDataList:(BOOL)isMore
{
    if (!isMore) {
        self.currentPage = 1;
    }
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pageNum"] = @(self.currentPage);
    dic[@"pageSize"] = @(MOL_REQUEST_COUNT_VEDIO);
    dic[@"userId"] = self.userId;
    
    MOLUserPageRequest *r = [[MOLUserPageRequest alloc] initRequest_getProductionListWithParameter:dic];
    
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        
        [self.collectionView.mj_footer endRefreshing];
        
        // 解析数据
        MOLVideoOutsideGroupModel *groupModel = (MOLVideoOutsideGroupModel *)responseModel;
        
        if (!isMore) {
            [self.dataSourceArray removeAllObjects];
        }
        
        // 添加到数据源
        [self.dataSourceArray addObjectsFromArray:groupModel.resBody];
        
        [self.collectionView reloadData];
        
        if (self.dataSourceArray.count >= groupModel.total) {
            self.collectionView.mj_footer.hidden = YES;
        }else{
            self.collectionView.mj_footer.hidden = NO;
            self.currentPage += 1;
        }
        
        if (!self.dataSourceArray.count) {
            [self basevc_showBlankPageWithY:-414 image:nil title:@"你还没有发布任何作品" superView:self.collectionView];
        }else{
            [self basevc_hiddenErrorView];
        }
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        [self.collectionView.mj_footer endRefreshing];
        [self basevc_showErrorPageWithY:-414 select:@selector(refresh_again) superView:self.collectionView];
    }];
}

- (void)refresh_again
{
    [self basevc_hiddenErrorView];
     [self request_getProductionDataList:NO];
}

#pragma mark - collectionviewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendViewController *vc = [[RecommendViewController alloc] init];
//    [vc.dataArray addObjectsFromArray:self.dataSourceArray];
//    vc.index = indexPath.row;
//    vc.pageNum = self.currentPage;
//    vc.businessType = HomePageBusinessType_userProduction;
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.dataSourceArray];
    PLMediaInfo *info = [[PLMediaInfo alloc] init];
    info.dataSource = arr;
    info.index = indexPath.row;
    info.pageNum = (self.currentPage-1)>0?(self.currentPage-1):1;
    info.pageSize = MOL_REQUEST_COUNT_VEDIO;
    info.businessType = HomePageBusinessType_userProduction;
    info.userId = self.userId;
    vc.mediaDto = info;
    [self.navigationController pushViewController:vc animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 获取cell
        MOLMineCollectionViewCell *cell = (MOLMineCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        MOLVideoOutsideModel *videoOutsideModel = cell.videoOutsideModel;
        if (videoOutsideModel.contentType == 1) {
            videoOutsideModel.rewardVO.playCount += 1;
            [cell.playCountButton setTitle:[NSString stringWithFormat:@"%ld",videoOutsideModel.rewardVO.playCount] forState:UIControlStateNormal];
        }else{
            videoOutsideModel.storyVO.playCount += 1;
            [cell.playCountButton setTitle:[NSString stringWithFormat:@"%ld",videoOutsideModel.storyVO.playCount] forState:UIControlStateNormal];
        }
        
        [cell layout];
    });
    
}
//分区，组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

//单元格复用
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MOLVideoOutsideModel *model = self.dataSourceArray[indexPath.row];
    
    MOLMineCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MOLMineCollectionViewCell_id" forIndexPath:indexPath];
    cell.type = MOLMineCollectionViewCellType_userProduction;
    cell.videoOutsideModel = model;
    return cell;
}

#pragma mark - UI
- (void)setupMyProductionViewControllerUI
{
    CGFloat itemW = (MOL_SCREEN_WIDTH - 2) / 3;
    CGFloat itemH = itemW * 165 / 124;
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout.minimumLineSpacing = 1;
    self.flowLayout.minimumInteritemSpacing = 1;
    self.flowLayout.itemSize = CGSizeMake(itemW, itemH);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, MOL_SCREEN_WIDTH, MOL_SCREEN_HEIGHT) collectionViewLayout:self.flowLayout];
    _collectionView = collectionView;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, MOL_TabbarHeight, 0);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[MOLMineCollectionViewCell class] forCellWithReuseIdentifier:@"MOLMineCollectionViewCell_id"];
    [self.view addSubview:_collectionView];
}

- (void)calculatorMyProductionViewControllerFrame
{
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self calculatorMyProductionViewControllerFrame];
}
@end
