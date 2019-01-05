//
//  ParticipatingWorksController.m
//  reward
//
//  Created by xujin on 2018/9/27.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "ParticipatingWorksController.h"
#import "MOLMineCollectionViewCell.h"
#import "MOLUserPageRequest.h"
#import "RecommendViewController.h"
#import "NSString+StringExtention.h"

#import "NTESTimerHolder.h"

@interface ParticipatingWorksController ()<UICollectionViewDelegate,UICollectionViewDataSource,NTESTimerHolderDelegate>
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic,assign)NSInteger pageSize;
@property (nonatomic,assign)NSInteger pageNumber;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,assign)UIBehaviorTypeStyle refreshType;
@property (nonatomic,strong) UILabel *titleLable;
@property (nonatomic,strong) MOLVideoOutsideGroupModel *mediaInfoList;
@property (nonatomic,strong) NSTimer *timer;        //悬赏结束定时器
@property (nonatomic,assign) NSInteger timeCount;   //倒计时秒数

@property (nonatomic, strong) NTESTimerHolder *timerHolder;

@end

@implementation ParticipatingWorksController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self setupMyLikeViewControllerUI];
    [self getNetworkData];
}

- (void)initData{
    self.refreshType = UIBehaviorTypeStyle_Normal;
    self.pageSize =MOL_REQUEST_COUNT_VEDIO;
    self.pageNumber =1;
    self.dataSource =[NSMutableArray new];
    self.timeCount =self.rewardModel.rewardVO.finishTime.integerValue;
    self.mediaInfoList =[MOLVideoOutsideGroupModel new];
}


#pragma mark - collectionviewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendViewController *vc = [[RecommendViewController alloc] init];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.dataSource];
    PLMediaInfo *info = [[PLMediaInfo alloc] init];
    info.dataSource = arr;
    info.index = indexPath.row;
    info.pageNum = self.pageNumber;
    info.pageSize = MOL_REQUEST_COUNT_VEDIO;
    info.rewardId =self.rewardModel.rewardVO.rewardId?self.rewardModel.rewardVO.rewardId:@"";
    info.userId =self.rewardModel.rewardVO.userVO.userId?self.rewardModel.rewardVO.userVO.userId:@"";
    info.businessType = HomePageBusinessType_RewardDetailList;
    vc.mediaDto = info;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
    return self.dataSource.count;
}

//单元格复用
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MOLMineCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MOLMineCollectionViewCell_Id" forIndexPath:indexPath];
    MOLVideoOutsideModel *model =[MOLVideoOutsideModel new];
    if (indexPath.row<self.dataSource.count) {
        model =self.dataSource[indexPath.row];
        cell.type =MOLMineCollectionViewCellType_normal;
        cell.videoOutsideModel = model;
    }
    return cell;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];

        [header addSubview:self.titleLable];
        
        return header;
    }
    return nil;
    
}

- (UILabel *)titleLable{
    if (!_titleLable) {
        //头视图添加view
        _titleLable =[UILabel new];
        [_titleLable setTextColor:HEX_COLOR(0xffffff)];
        [_titleLable setFont:MOL_REGULAR_FONT(13)];
        [_titleLable setFrame:CGRectMake(0, 0, MOL_SCREEN_WIDTH, 12+18+12)];
        NSInteger cur = [NSString mol_timeWithCurrentTimestamp] * 1000;
        BOOL finish = (cur > self.rewardModel.rewardVO.finishTime.integerValue);
        if (finish || self.rewardModel.rewardVO.isFinish/*self.timeCount <= self.rewardModel.rewardVO.createTime.integerValue*/) {
            //已结束
            [self.titleLable setText:[NSString stringWithFormat:@"%ld人参与 (已结束)",(long)self.mediaInfoList.total]];
            
        }else{
            //未结束
            [_titleLable setText:[NSString stringWithFormat:@"%ld人参与 (距悬赏结束：%@)",(long)self.mediaInfoList.total,[NSString timeGetRewardTimeWithTimestamp:[NSString stringWithFormat:@"%ld",(long)self.timeCount]]]];
            [self startTimer];
        }
        
        
        [_titleLable setTextAlignment:NSTextAlignmentCenter];
    }
    return _titleLable;
}


#pragma mark - UI
- (void)setupMyLikeViewControllerUI
{
    CGFloat itemW = (MOL_SCREEN_WIDTH - 2) / 3;
    CGFloat itemH = itemW * 165 / 124;
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout.minimumLineSpacing = 1;
    self.flowLayout.minimumInteritemSpacing = 1;
    self.flowLayout.itemSize = CGSizeMake(itemW, itemH);
    self.flowLayout.headerReferenceSize = CGSizeMake(MOL_SCREEN_WIDTH, 12+18+12);  //设置headerView大小
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, MOL_SCREEN_WIDTH, MOL_SCREEN_HEIGHT) collectionViewLayout:self.flowLayout];
    
    self.collectionView = collectionView;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerClass:[MOLMineCollectionViewCell class] forCellWithReuseIdentifier:@"MOLMineCollectionViewCell_Id"];
    //注册头视图
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];

    collectionView.contentInset = UIEdgeInsetsMake(0, 0, MOL_TabbarHeight, 0);
    @weakify(self);
    collectionView.mj_header = [MOLDIYRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refresh];
    }];
    collectionView.mj_footer = [MOLDIYRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMore];
    }];
    [self.view addSubview:collectionView];
}

- (void)calculatorMyLikeViewControllerFrame
{
    
}

#pragma mark-
#pragma mark 获取网络数据
- (void)refresh{
    self.pageNumber =1;
    self.refreshType =UIBehaviorTypeStyle_Refresh;
    [self getNetworkData];
};

- (void)loadMore{
    self.pageNumber++;
    self.refreshType =UIBehaviorTypeStyle_More;
    [self getNetworkData];
}
- (void)getNetworkData{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pageNum"] = @(self.pageNumber);
    dic[@"pageSize"] = @(self.pageSize);
    dic[@"rewardId"] = self.rewardModel.rewardVO.rewardId?self.rewardModel.rewardVO.rewardId:@"";
   // dic[@"userId"] = self.rewardModel.rewardVO.userVO.userId?self.rewardModel.rewardVO.userVO.userId:@"";
    __weak typeof(self) wself = self;
    [[[MOLUserPageRequest alloc] initRequest_getProductionListWithParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        
        if (wself.refreshType != UIBehaviorTypeStyle_Normal) {
            [wself.collectionView.mj_header endRefreshing];
            [wself.collectionView.mj_footer endRefreshing];
        }
        
        if (code == MOL_SUCCESS_REQUEST) {
            if (responseModel) {
                // 解析数据
                MOLVideoOutsideGroupModel *mediaInfoL = (MOLVideoOutsideGroupModel *)responseModel;
                wself.mediaInfoList = mediaInfoL;
                
                if (wself.refreshType != UIBehaviorTypeStyle_More) {
                    [wself.dataSource removeAllObjects];
                }
                
                // 添加到数据源
                [wself.dataSource addObjectsFromArray:mediaInfoL.resBody];
                
                if (wself.refreshType != UIBehaviorTypeStyle_More && wself.dataSource.count>0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [wself.titleLable setText:[NSString stringWithFormat:@"%ld人参与 (距悬赏结束：%@)",(long)self.mediaInfoList.total,[NSString timeGetRewardTimeWithTimestamp:[NSString stringWithFormat:@"%ld",(long)self.timeCount]]]];
                        
                        
                        
                        NSInteger cur = [NSString mol_timeWithCurrentTimestamp] * 1000;
                        BOOL finish = (cur > self.rewardModel.rewardVO.finishTime.integerValue);
                        if (finish || self.rewardModel.rewardVO.isFinish/*self.timeCount <= self.rewardModel.rewardVO.createTime.integerValue*/) {
                            [self stopTimer];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.titleLable setText:[NSString stringWithFormat:@"%ld人参与 (已结束)",(long)self.mediaInfoList.total]];
                            });
                            
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.titleLable setText:[NSString stringWithFormat:@"%ld人参与 (距悬赏结束：%@)",(long)self.mediaInfoList.total,[NSString timeGetRewardTimeWithTimestamp:[NSString stringWithFormat:@"%ld",(long)self.timeCount]]]];
                            });
                        }
                        
                        
                        
                    });
                    
                }
                
                [wself.collectionView reloadData];
                
                if (wself.dataSource.count >= mediaInfoL.total) {
                    wself.collectionView.mj_footer.hidden = YES;
                    
                }else{
                    wself.collectionView.mj_footer.hidden = NO;
                    
                }
                
            }
            
        }else{
            [OMGToast showWithText:message];
        }
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        
        if (self.refreshType != UIBehaviorTypeStyle_Normal) {
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
        }
        
    }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self calculatorMyLikeViewControllerFrame];
}


/**
 定时器倒计时
 */
- (void)startTimer{
//    self.timer =[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFunction:) userInfo:@"1000" repeats:YES];
//    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    _timerHolder = [[NTESTimerHolder alloc] init];
    [_timerHolder startTimer:1.0 delegate:self repeats:YES];
    
}

- (void)onNTESTimerFired:(NTESTimerHolder *)holder
{
    // 返回是毫秒，1000 表示每次减1秒
    self.timeCount -=1000;
    
    NSInteger cur = [NSString mol_timeWithCurrentTimestamp] * 1000;
    BOOL finish = (cur > self.rewardModel.rewardVO.finishTime.integerValue);
    if (finish || self.rewardModel.rewardVO.isFinish/*self.timeCount <= self.rewardModel.rewardVO.createTime.integerValue*/) {
        [self stopTimer];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.titleLable setText:[NSString stringWithFormat:@"%ld人参与 (已结束)",(long)self.mediaInfoList.total]];
        });
        
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.titleLable setText:[NSString stringWithFormat:@"%ld人参与 (距悬赏结束：%@)",(long)self.mediaInfoList.total,[NSString timeGetRewardTimeWithTimestamp:[NSString stringWithFormat:@"%ld",(long)self.timeCount]]]];
        });
    }
}

//- (void)timerFunction:(NSTimer *)timer{
//
//    // 返回是毫秒，1000 表示每次减1秒
//    self.timeCount -=1000;
//
//    NSInteger cur = [NSString mol_timeWithCurrentTimestamp] * 1000;
//    BOOL finish = (cur > self.rewardModel.rewardVO.finishTime.integerValue);
//    if (finish || self.rewardModel.rewardVO.isFinish/*self.timeCount <= self.rewardModel.rewardVO.createTime.integerValue*/) {
//        [self stopTimer];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.titleLable setText:[NSString stringWithFormat:@"%ld人参与 (已结束)",(long)self.mediaInfoList.total]];
//        });
//
//    } else {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.titleLable setText:[NSString stringWithFormat:@"%ld人参与 (距悬赏结束：%@)",(long)self.mediaInfoList.total,[NSString timeGetRewardTimeWithTimestamp:[NSString stringWithFormat:@"%ld",(long)self.timeCount]]]];
//        });
//    }
//
//}

- (void)stopTimer{
//    if ([self.timer isValid]) {
//        [self.timer invalidate];
//        self.timer = nil;
//    }
    if (self.timerHolder) {
        
        [self.timerHolder stopTimer];
        self.timerHolder = nil;
    }
    
}

- (void)dealloc{
    [self stopTimer];
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
