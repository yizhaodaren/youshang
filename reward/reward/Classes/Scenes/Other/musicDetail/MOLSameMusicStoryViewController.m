//
//  MOLSameMusicStoryViewController.m
//  reward
//
//  Created by apple on 2018/11/20.
//  Copyright © 2018 reward. All rights reserved.
//

#import "MOLSameMusicStoryViewController.h"
#import "MOLMineCollectionViewCell.h"
#import "MOLVideoOutsideGroupModel.h"
#import "RecommendViewController.h"
#import "MOLUserPageRequest.h"
@interface MOLSameMusicStoryViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, assign) NSInteger musicId;//音乐ID
//作品列表
@property (nonatomic,strong) NSMutableArray  *dataSourceArray;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation MOLSameMusicStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self request_getProductionDataList:NO];
}
-(instancetype)initWith:(NSInteger)musicID{
    self = [super init];
if (self) {
      self.musicId = musicID;
}
    return self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUI{

    [self.view addSubview:self.collectionView];
    
    
    @weakify(self);
//    self.collectionView.mj_header = [MOLDIYRefreshHeader headerWithRefreshingBlock:^{
//        @strongify(self);
//        
//        [self request_getProductionDataList:NO];
//    }];
    self.collectionView.mj_footer = [MOLDIYRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        
        [self request_getProductionDataList:YES];
    }];
    self.collectionView.mj_footer.hidden = YES;
}

#pragma mark - 网络请求产品列表
- (void)request_getProductionDataList:(BOOL)isMore
{
    if (!isMore) {
        self.currentPage = 1;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pageNum"] = @(self.currentPage);
    dic[@"pageSize"] = @(MOL_REQUEST_COUNT_OTHER);

    dic[@"musicId"] = @(self.musicId);
    dic[@"sort"] = @3;
    
    MOLUserPageRequest *r = [[MOLUserPageRequest alloc] initRequest_getProductionListWithParameter:dic];
    
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
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
            [self basevc_showBlankPageWithY:-150 image:nil title:@"没有任何作品" superView:self.collectionView];
        }else{
            [self basevc_hiddenErrorView];
        }
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
        [self basevc_showErrorPageWithY:-150 select:@selector(refresh_again) superView:self.collectionView];
    }];
}
- (void)refresh_again
{
    [self basevc_hiddenErrorView];
    [self request_getProductionDataList:NO];
}
#pragma mark collectionviewDelegate代理方法
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
    
    //首发
    if (indexPath.row == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 30, 16)];
        label.backgroundColor = HEX_COLOR(0xFFCE35);
        label.layer.cornerRadius = 2;
        label.clipsToBounds= YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"首发";
        label.textColor = HEX_COLOR(0xFFFFFF);
        label.font = MOL_MEDIUM_FONT(10);
        [cell addSubview:label];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendViewController *vc = [[RecommendViewController alloc] init];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.dataSourceArray];
    PLMediaInfo *info = [[PLMediaInfo alloc] init];
    info.dataSource = arr;
    info.index = indexPath.row;
    info.pageNum = (self.currentPage-1)>0?(self.currentPage-1):1;
    info.pageSize = MOL_REQUEST_COUNT_OTHER;
    info.musicID = self.musicId;
    info.sortType = 3;//时间排序
    info.businessType = HomePageBusinessType_sameMusicUserProduction;
    info.userId = self.userId;
    vc.mediaDto = info;
    
    //暂停音乐的播放
    if (self.stopMusicBlock) {
        self.stopMusicBlock();
    }
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
#pragma mark 懒加载
-(NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
    //作品列表
    CGFloat itemW = (MOL_SCREEN_WIDTH - 2) / 3;
    CGFloat itemH = itemW * 165 / 124;
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout.minimumLineSpacing = 1;
    self.flowLayout.minimumInteritemSpacing = 1;
    self.flowLayout.itemSize = CGSizeMake(itemW, itemH);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, MOL_SCREEN_WIDTH,MOL_SCREEN_HEIGHT) collectionViewLayout:self.flowLayout];
    _collectionView = collectionView;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[MOLMineCollectionViewCell class] forCellWithReuseIdentifier:@"MOLMineCollectionViewCell_id"];
    }
    
    return _collectionView;
}
@end
