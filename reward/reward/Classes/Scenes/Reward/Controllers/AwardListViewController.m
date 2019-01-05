//
//  AwardListViewController.m
//  reward
//
//  Created by xujin on 2018/9/27.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "AwardListViewController.h"
#import "prizeListCell.h"
#import "RewardModel.h"
#import "RewardRequest.h"
#import "RewardSetModel.h"

@interface AwardListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *awardTableView;
@property (nonatomic,assign)NSInteger pageSize;
@property (nonatomic,assign)NSInteger pageNumber;
@property (nonatomic,assign)UIBehaviorTypeStyle refreshType;

@end

@implementation AwardListViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshAwardListViewController" object:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"refreshAwardListViewController" object:nil];
    [self layoutUI];
    [self initData];
   // [self getNetworkData];
}


- (void)initData{
    self.dataSource =[NSMutableArray new];
    self.pageNumber =1;
    self.pageSize =20;
    self.refreshType = UIBehaviorTypeStyle_Normal;
}

- (void)layoutUI{
    _tableView =self.awardTableView;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

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
    
    return 60;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * const cellId =@"cell";
    prizeListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell =[[prizeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    RewardModel *model =[RewardModel new];
    if (self.dataSource.count>indexPath.row) {
        model =self.dataSource[indexPath.row];
        MOLUserModel *user = [MOLUserManagerInstance user_getUserInfo];
        model.isUserOneself =NO;
        if(model.userId == user.userId.integerValue){ //表示用户自己
            model.isUserOneself =YES;
        }
        model.pIndex =indexPath.row;
        model.rewardType = self.rewardModel.rewardVO.rewardType;
        
    }
    
    [cell prizeListCell:model indexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.rewardModel.rewardVO.rewardType==1) { //红包
        return 50;
    }else{
        return 20;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView =[UIView new];
    [headerView setBackgroundColor: [UIColor clearColor]];
    
    if (self.rewardModel.rewardVO.rewardType==1) { //红包
        UIView *contentView =[UIView new];
        [contentView setBackgroundColor:HEX_COLOR_ALPHA(0xffffff,0.2)];
        [contentView.layer setMasksToBounds:YES];
        [contentView.layer setCornerRadius:3];
        [headerView addSubview:contentView];
        
        UIImageView *redBoxImage =[UIImageView new];
        [redBoxImage setImage: [UIImage imageNamed:@"hongbao"]];
        [contentView addSubview:redBoxImage];
        
        UILabel *tipLable =[UILabel new];
        [tipLable setText: [NSString stringWithFormat:@"%ld/%ld",(self.rewardModel.rewardVO.awardSize-self.rewardModel.rewardVO.remainSize)>=0?(self.rewardModel.rewardVO.awardSize-self.rewardModel.rewardVO.remainSize):0,self.rewardModel.rewardVO.awardSize]];
        [tipLable setTextColor:HEX_COLOR_ALPHA(0xffffff,1)];
        [tipLable setFont:MOL_REGULAR_FONT(12)];
        [contentView addSubview:tipLable];
        CGSize tipLableSize = [tipLable.text?tipLable.text:@"" boundingRectWithSize:CGSizeMake(MAXFLOAT, 17) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName :MOL_REGULAR_FONT(12)} context:nil].size;
        
        [contentView setFrame:CGRectMake(MOL_SCREEN_WIDTH-15-10-14-5-tipLableSize.width-10,10,10+14+5+tipLableSize.width+10 , 26)];
        [redBoxImage setFrame:CGRectMake(10,(contentView.height-32/2.0)/2.0,28/2.0, 32/2.0)];
        [tipLable setFrame:CGRectMake(redBoxImage.right+5,0, tipLableSize.width, contentView.height)];

        [headerView setFrame:CGRectMake(0, 0, MOL_SCREEN_WIDTH,50)];

    }else{ //排名
        [headerView setFrame:CGRectMake(0, 0, MOL_SCREEN_WIDTH,20)];
    }

    return headerView;
}

#pragma mark - UI
- (UITableView *)awardTableView{
    if (!_awardTableView) {
        _awardTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _awardTableView.backgroundColor = [UIColor clearColor];
        if (@available(iOS 11.0, *)) {
            _awardTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _awardTableView.estimatedRowHeight = 0;
        //_awardTableView.estimatedSectionHeaderHeight = 0;
        _awardTableView.estimatedSectionFooterHeight = 0;
        _awardTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_awardTableView registerClass:[prizeListCell class] forCellReuseIdentifier:@"cellId"];
        _awardTableView.contentInset = UIEdgeInsetsMake(0, 0, MOL_TabbarHeight, 0);
        _awardTableView.delegate = self;
        _awardTableView.dataSource = self;
        @weakify(self);
        _awardTableView.mj_header = [MOLDIYRefreshHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self refresh];
        }];
        _awardTableView.mj_footer = [MOLDIYRefreshFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self loadMore];
        }];
    }
    return _awardTableView;
}

#pragma mark-
#pragma mark 获取网络数据
- (void)refresh{
    self.pageNumber =1;
    self.refreshType =UIBehaviorTypeStyle_Refresh;
    [self getNetworkData];
}

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
   
    if (self.rewardModel.rewardVO.rewardType ==1) {//红包
        dic[@"sort"] = @"1";
    }else{//排名
        dic[@"sort"] = @"2";
    }
    dic[@"isReward"] =@"1";
    
    __weak typeof(self) wself = self;
    [[[RewardRequest alloc] initRequest_RewardDetail_AwardListParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        
        if (wself.refreshType != UIBehaviorTypeStyle_Normal) {
            [wself.tableView.mj_header endRefreshing];
            [wself.tableView.mj_footer endRefreshing];
        }
        
        if (code == MOL_SUCCESS_REQUEST) {
            if (responseModel) {

                // 解析数据
                RewardSetModel *mediaInfoL = (RewardSetModel *)responseModel;
                
                
                if (wself.refreshType != UIBehaviorTypeStyle_More) {
                    [wself.dataSource removeAllObjects];
                }
                
                // 添加到数据源
                [wself.dataSource addObjectsFromArray:mediaInfoL.resBody];

                [wself.tableView reloadData];
                
                if (wself.dataSource.count >= mediaInfoL.total) {
                    wself.tableView.mj_footer.hidden = YES;
                    
                }else{
                    wself.tableView.mj_footer.hidden = NO;
                    
                }
            }
            
        }else{
            [OMGToast showWithText:message];
        }
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        
        if (self.refreshType != UIBehaviorTypeStyle_Normal) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        
    }];
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
