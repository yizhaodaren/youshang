//
//  HoursViewController.m
//  reward
//
//  Created by xujin on 2018/9/12.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "HoursViewController.h"
#import "HoursCell.h"
#import "HoursTimeCell.h"
#import "HomePageRequest.h"
#import "HoursSetModel.h"
#import "HoursModel.h"
#import "HoursGroupModel.h"
#import "RewardDetailViewController.h"
#import "RecommendViewController.h"
#import "MOLWebViewController.h"

@interface HoursViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *sourceData;
@property (nonatomic,strong)NSMutableArray *hoursArr;
@property (nonatomic,assign)NSInteger pageSize;
@property (nonatomic,assign)NSInteger pageNumber;
@property (nonatomic,assign)UIBehaviorTypeStyle refreshType;
@property (nonatomic,strong)UIImageView *emptyImgView;

@end

@implementation HoursViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self layoutNavigation];
    [self layoutUI];
    [self getHoursNetData];

}

- (void)initData{
    self.sourceData =[NSMutableArray new];
    self.hoursArr =[NSMutableArray new];
    self.refreshType = UIBehaviorTypeStyle_Normal;
    self.pageNumber =1;
    self.pageSize =20;
}
- (void)layoutNavigation{
    self.showNavigationLine= YES;
    [self basevc_setCenterTitle:@"CC头条24小时" titleColor:HEX_COLOR(0xffffff)];
}
- (void)layoutUI{
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.emptyImgView];
}

- (void)getRecommendNetData{
    
}

- (UIImageView *)emptyImgView{
    if (!_emptyImgView) {
        _emptyImgView =[UIImageView new];
        [_emptyImgView setImage: [UIImage imageNamed:@"search_empty"]];
        [_emptyImgView setFrame:CGRectMake((MOL_SCREEN_WIDTH-308/2.0)/2.0,80+MOL_StatusBarAndNavigationBarHeight, 308/2.0, 188/2.0)];
        [_emptyImgView setAlpha:0];
    }
    return _emptyImgView;
}

-(UITableView *)tableview{
    
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0,MOL_StatusBarAndNavigationBarHeight, MOL_SCREEN_WIDTH, MOL_SCREEN_HEIGHT-MOL_StatusBarAndNavigationBarHeight-MOL_TabbarSafeBottomMargin) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.estimatedRowHeight = 0;
        _tableview.estimatedSectionHeaderHeight = 0;
        _tableview.estimatedSectionFooterHeight = 0;
        [_tableview setBackgroundColor:[UIColor clearColor]];
        @weakify(self);
        _tableview.mj_header = [MOLDIYRefreshHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self refresh];
        }];
        _tableview.mj_footer = [MOLDIYRefreshFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self loadMore];
        }];
    }
    
    _tableview.mj_footer.hidden = YES;
    
    return _tableview;
    
    
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.hoursArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.hoursArr.count>section) {
        HoursGroupModel *model =[HoursGroupModel new];
        model =self.hoursArr[section];
        return model.hoursArr.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * const hoursCellID = @"hoursCell";
    HoursCell *hoursCell =[tableView dequeueReusableCellWithIdentifier:hoursCellID];
    if (!hoursCell) {
        
        hoursCell =[[HoursCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hoursCellID];
        hoursCell.selectionStyle= UITableViewCellSelectionStyleNone;
        
    }
    
   
        HoursModel *goodsDto =[HoursModel new];
    
        if (self.hoursArr.count>indexPath.section) {
            HoursGroupModel *model =[HoursGroupModel new];
            model =self.hoursArr[indexPath.section];
            if (model.hoursArr.count>indexPath.row) {
                goodsDto =model.hoursArr[indexPath.row];
            }
        }
    
    [hoursCell contentCell:goodsDto indexPath:indexPath];

    return hoursCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.hoursArr.count>indexPath.section) {
        HoursGroupModel *model =[HoursGroupModel new];
        model =self.hoursArr[indexPath.section];
        
        if (model.hoursArr.count>indexPath.row) {
            HoursModel *hoursDto =[HoursModel new];
            hoursDto =model.hoursArr[indexPath.row];
            return hoursDto.hourscellHeight;
        }
    }
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *timeLable =[UILabel new];
    [timeLable setBackgroundColor: HEX_COLOR(0x0F101C)];
    [timeLable setTextAlignment:NSTextAlignmentCenter];
    [timeLable setTextColor: HEX_COLOR_ALPHA(0xffffff, 0.6)];
    [timeLable setFont:MOL_MEDIUM_FONT(18)];
    if (self.hoursArr.count>section) {
        HoursGroupModel *model =[HoursGroupModel new];
        model =self.hoursArr[section];
        [timeLable setText: model.text?model.text:@""];
    }
    
    return timeLable;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    HoursModel *goodsDto =[HoursModel new];
    
    if (self.hoursArr.count>indexPath.section) {
        HoursGroupModel *model =[HoursGroupModel new];
        model =self.hoursArr[indexPath.section];
        if (model.hoursArr.count>indexPath.row) {
            goodsDto =model.hoursArr[indexPath.row];
        }
    }
    //内容类型(0=标题头1=悬赏,2=作品,3=网页链接)
    switch (goodsDto.dynamicType) {
        case 1: //悬赏
        {
                RewardDetailViewController *rewardDetail =[RewardDetailViewController new];
                rewardDetail.rewardId =[NSString stringWithFormat:@"%ld",goodsDto.ext.rewardId];
                [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:rewardDetail animated:YES];
           
        }
            break;
            
        case 2://作品
        {
            RecommendViewController *vc = [[RecommendViewController alloc] init];
            PLMediaInfo *info = [[PLMediaInfo alloc] init];
            info.index = 0;
            info.rewardId = [NSString stringWithFormat:@"%ld",goodsDto.ext.storyId];
            info.userId = @"";
            info.businessType = HomePageBusinessType_StoryDetail;
            info.pageNum =1;
            info.pageSize =MOL_REQUEST_COUNT_VEDIO;
            vc.mediaDto = info;
            
            [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
        }
            break;
            
        case 3://网页链接
        {
            MOLWebViewController *vc = [[MOLWebViewController alloc] init];
            vc.urlString =goodsDto.ext.url?goodsDto.ext.url:@"";
            [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
        }
            break;
    }
}

#pragma mark-
#pragma mark 网络请求
- (void)refresh{
    self.pageNumber =1;
    self.refreshType =UIBehaviorTypeStyle_Refresh;
    [self getHoursNetData];
};

- (void)loadMore{
    self.pageNumber++;
    self.refreshType =UIBehaviorTypeStyle_More;
    [self getHoursNetData];
}
- (void)getHoursNetData{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pageNum"] = @(self.pageNumber);
    dic[@"pageSize"] = @(self.pageSize);
   // dic[@"pageSize"] = @(6);
    if (self.refreshType == UIBehaviorTypeStyle_More) {//上拉加载更多
        
        if (self.sourceData.count>0) {
            HoursModel *model =[HoursModel new];
            model =[self.sourceData lastObject];
            dic[@"lastTime"] = [NSString stringWithFormat:@"%ld",model.createTime];
        }
        
    }
    
    
    __weak typeof(self) wself = self;
    
    [[[HomePageRequest alloc] initRequest_HoursParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        if (wself.refreshType != UIBehaviorTypeStyle_Normal) {
            [wself.tableview.mj_header endRefreshing];
            [wself.tableview.mj_footer endRefreshing];
        }
        
        if (code == MOL_SUCCESS_REQUEST) {
            if (responseModel) {
                // 解析数据
                HoursSetModel *groupModel = (HoursSetModel *)responseModel;

                if (wself.refreshType != UIBehaviorTypeStyle_More) {
                    [wself.sourceData removeAllObjects];
                    [wself.hoursArr removeAllObjects];
                    
                }
                
                
                if (groupModel.resBody.count) {
                    // 添加到数据源
                    [wself.sourceData addObjectsFromArray:groupModel.resBody];
                    
                    NSString *textString;
                    NSMutableArray *listArr;
                    for (NSInteger i=0; i<wself.sourceData.count; i++) {
                        HoursModel *hoursDto =[HoursModel new];
                        hoursDto =wself.sourceData[i];
                        
                        if (hoursDto.dynamicType == 0) { //表示新组
                            
                            if (i != 0) { //表示非第一个数据事件处理
                                HoursGroupModel *groupModel =[HoursGroupModel new];
                                groupModel.text =textString;
                                groupModel.hoursArr =listArr;
                                [wself.hoursArr addObject:groupModel];
                                
                                listArr =[NSMutableArray new];
                                
                            }else{
                                listArr =[NSMutableArray new];
                                
                            }
                            textString =[NSString stringWithString:hoursDto.text?hoursDto.text:@""];
                        }else{
                            
                            if (!listArr) {
                                listArr =[NSMutableArray new];
                            }
                            
                            [listArr addObject:hoursDto];
                            
                            if (i == wself.sourceData.count-1) { //表示最后一个数据事件处理
                                HoursGroupModel *groupModel =[HoursGroupModel new];
                                groupModel.text =textString;
                                groupModel.hoursArr =listArr;
                                [wself.hoursArr addObject:groupModel];
                                //[listArr removeAllObjects];
                            }
                        }
                    }
                }

       //         NSLog(@"%@",wself.hoursArr);

                [wself.tableview reloadData];
                
                if (wself.sourceData.count-wself.hoursArr.count >= groupModel.total) {
                    wself.tableview.mj_footer.hidden = YES;
                    
                }else{
                    wself.tableview.mj_footer.hidden = NO;
                }
            }
            
        }else{
            [OMGToast showWithText:message];
        }
        
//        if (wself.sourceData.count) {
//            [wself basevc_hiddenErrorView];
//        }
             [wself emptyDataShow];
       
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        
        if (wself.refreshType != UIBehaviorTypeStyle_Normal) {
            [wself.tableview.mj_header endRefreshing];
            [wself.tableview.mj_footer endRefreshing];
        }
        
//        if (!wself.sourceData.count) {
//            [wself basevc_showErrorPageWithY:0 select:@selector(refresh) superView:wself.view];
//        }else{
//            [wself basevc_hiddenErrorView];
//        }
       
            [wself emptyDataShow];
       
    }];
}

/// 搜索🔍空数据显示
- (void)emptyDataShow{
    if (!self.sourceData.count) { //表示无数据
        [self.emptyImgView setAlpha:1];
    }else{
        [self.emptyImgView setAlpha:0];
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
