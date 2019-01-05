//
//  AttentionViewController.m
//  reward
//
//  Created by xujin on 2018/9/12.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "AttentionViewController.h"
#import "MOLLoginViewController.h"
#import "MOLUserRelationCell.h"
#import "MOLExaminePacketModeCell.h"
#import "HomePageRequest.h"
#import "MOLUserModel.h"
#import "MOLAttentionUsersModel.h"
#import "MOLActionRequest.h"
#import "MOLMsgUserModel.h"
#import "MOLMineViewController.h"
#import "MOLOtherUserViewController.h"
#import "MOLGlobalManager.h"
#import "MOLAttentionUsersModel.h"
#import "MOLVideoOutsideModel.h"
#import "MOLVideoOutsideGroupModel.h"
#import "MOLMsgUserGroupModel.h"
#import <TYAttributedLabel/TYAttributedLabel.h>


@interface AttentionViewController ()<UITableViewDelegate,UITableViewDataSource,MOLExaminePacketModeCellDelegate,TYAttributedLabelDelegate>
@property (nonatomic,assign)NSInteger pageIndex;
@property (nonatomic,assign)NSInteger pageNumber;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)AttentionViewControllerType businesstype;
@property (nonatomic,assign)UIBehaviorTypeStyle refreshType;
@property (nonatomic,assign)BOOL isFollowed; //yes 表示已经关注过 no 表示未关注过
@property (nonatomic, strong) NSMutableArray *currentCellsArray;
@property (nonatomic, strong) TYAttributedLabel *label;


@end

@implementation AttentionViewController


//-(instancetype)init{
//    id temp = [super init];
//    return temp;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self registNotif];
    [self layoutUI];
    [self initUI];
    AVAudioSession *session =[AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
}
- (void)initUI{
    [self initData];
    if (![MOLUserManagerInstance user_isLogin]) {
        //未登录
        [self.label setHidden:NO];
        _tableView.mj_header.hidden =YES;
        _tableView.mj_footer.hidden = YES;
        return;
        
    }else{
        //登录
        _tableView.mj_header.hidden =NO;
         _tableView.mj_footer.hidden = NO;
        [self.label setHidden:YES];
        [self getAttentionContentsNetworkData];
        
        // 首先获取关注内容
        // 如果关注内容 有 展示关注内容  没有 获取关注用户
        // 关注用户 - 点击关注 请求关注接口  成功移除
        // 关注用户全部移除，监听最后一个移除 移除后自动刷新关注内容接口
        // 存在已关注则用户手动下拉刷新获取关注内容
        //    [self getAttentionUsersNetworkData];
    }
}

- (TYAttributedLabel *)label{
    if (!_label) {
        _label = [[TYAttributedLabel alloc]init];
        //label.highlightedLinkColor = [UIColor redColor];
        _label.delegate =self;
        [_label setBackgroundColor: [UIColor clearColor]];
        [_label setTextAlignment:kCTTextAlignmentCenter];
        [_label setHidden:NO];
        [self.view addSubview: _label];
        [_label setFrame:CGRectMake(0, MOL_SCREEN_HEIGHT/4.0, MOL_SCREEN_WIDTH, 48)];
        
        NSString *text =@"您还没有登录,请登录";
        
        TYTextContainer *textContainer = [[TYTextContainer alloc]init];
        textContainer.text = text;
        [textContainer setTextAlignment:kCTTextAlignmentCenter];
        [textContainer setStrokeColor: [UIColor clearColor]];
        [textContainer setTextColor:HEX_COLOR_ALPHA(0xffffff, 0.6)];
        [textContainer setFont: MOL_REGULAR_FONT(14)];
        
        
        [textContainer addLinkWithLinkData:@"请登录" linkColor:HEX_COLOR_ALPHA(0xE6594F, 1) underLineStyle:kCTUnderlineStyleSingle range:[text rangeOfString:@"请登录"]];
        _label.textContainer =textContainer;
    }
    return _label;
}

- (void)initAttentionData{
    self.pageIndex =1;
    self.pageNumber = MOL_REQUEST_COUNT_VEDIO;
    self.refreshType =UIBehaviorTypeStyle_Normal;
}

- (void)initAttentionUsersData{
    self.businesstype =AttentionViewControllerType_Fans;
    self.isFollowed =NO;
    [self initAttentionData];
}

- (void)initAttentionContentsData{
    self.businesstype =AttentionViewControllerType_Concerns;
    [self initAttentionData];
}

- (void)initData{
    self.currentCellsArray = [NSMutableArray array];
    self.isFollowed =NO;
    self.dataSource =[NSMutableArray new];
    [self initAttentionContentsData];
   // [self initAttentionUsersData];
}

- (void)layoutUI{
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MOL_StatusBarAndNavigationBarHeight, self.view.width, self.view.height-MOL_StatusBarAndNavigationBarHeight-MOL_TabbarHeight) style:UITableViewStylePlain];
        
        _tableView.backgroundColor = [UIColor clearColor];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        @weakify(self);
        _tableView.mj_header = [MOLDIYRefreshHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self refresh];
        }];
        _tableView.mj_footer = [MOLDIYRefreshFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self loadMore];
        }];
       // _tableView.mj_footer.hidden = YES;
    }
    return _tableView;
}


#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.businesstype ==AttentionViewControllerType_Fans) {
        static NSString * const fansCellID = @"fansCell";
        MOLUserRelationCell *fansCell =[tableView dequeueReusableCellWithIdentifier:fansCellID];
        if (!fansCell) {
            fansCell =[[MOLUserRelationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:fansCellID];
            fansCell.selectionStyle= UITableViewCellSelectionStyleNone;
        }
            MOLMsgUserModel *model =[MOLMsgUserModel new];
        
            if (indexPath.row<self.dataSource.count) {

                model =self.dataSource[indexPath.row];
    
            }
            fansCell.userModel =model;
        
        return fansCell;
        
    }else{
        static NSString * const cellID = @"cell";
        MOLExaminePacketModeCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell =[[MOLExaminePacketModeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellType:MOLExaminePacketModeCellType_normal];
            cell.selectionStyle= UITableViewCellSelectionStyleNone;
            cell.delegate =self;
        }
        
        MOLVideoOutsideModel *model =[MOLVideoOutsideModel new];

        if (indexPath.row<self.dataSource.count) {
            model =self.dataSource[indexPath.row];
        }
        cell.videoOutsideModel =model;
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.businesstype == AttentionViewControllerType_Concerns) {
        // 视频 悬赏
        MOLVideoOutsideModel *model =[MOLVideoOutsideModel new];
        if (indexPath.row<self.dataSource.count) {
            model =self.dataSource[indexPath.row];
        }
        
        return model.contentType==1?model.rewardVO.cellHeight_homeFocus:model.storyVO.cellHeight_examinePackted;
        
    }else{
       return 90;
    }
}



#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.businesstype ==AttentionViewControllerType_Fans) {
        
        MOLMsgUserModel *userDto =[MOLMsgUserModel new];
        if (indexPath.row < self.dataSource.count) {
            userDto = self.dataSource[indexPath.row];
        }
        
        if ([[MOLGlobalManager shareGlobalManager] isUserself:userDto.userVO]) {
            MOLMineViewController *mineView =[MOLMineViewController new];
            [self.navigationController pushViewController:mineView animated:YES];
        }else{
            MOLOtherUserViewController *otherView =[MOLOtherUserViewController new];
            otherView.userId = userDto.userVO.userId?userDto.userVO.userId:@"";
            [self.navigationController pushViewController:otherView animated:YES];
            
        }
    }else{
        
    }
}

#pragma mark - 播放
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[MOLExaminePacketModeCell class]]) {
        MOLExaminePacketModeCell *modecell = (MOLExaminePacketModeCell *)cell;
        if (modecell.player.isPlaying) {
            [modecell.player stop];
        }
        [self.currentCellsArray removeObject:modecell];
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[MOLExaminePacketModeCell class]]) {
        MOLExaminePacketModeCell *modecell = (MOLExaminePacketModeCell *)cell;
        [self.currentCellsArray addObject:modecell];
    }
    
}


- (BOOL)canPlay:(CGRect)rect cell:(MOLExaminePacketModeCell *)cell
{
    // 获取屏幕的两个rect
    CGRect topRect = CGRectMake(0, 0, MOL_SCREEN_WIDTH, MOL_SCREEN_HEIGHT * 0.5);
    CGRect bottomRect = CGRectMake(0, MOL_SCREEN_HEIGHT * 0.5, MOL_SCREEN_WIDTH, MOL_SCREEN_HEIGHT * 0.5);
    
    if (rect.origin.y > MOL_SCREEN_HEIGHT * 0.5 + 80) {  // 传入的rect的y在下半部分
        cell.clickPause = NO;
        return NO;
    }
    
    if (rect.origin.y == MOL_SCREEN_HEIGHT * 0.5 + 80) {
        return YES;
    }
    
    // 传入的rect的y在上半部分
    if (CGRectContainsRect(rect, topRect)) {  // 如果视频包含了topRect 可以播放
        return YES;
    }
    
    if (CGRectContainsRect(rect, bottomRect)) {  // 如果视频和bottomRect 有交集 可以播放
        return YES;
    }
    cell.clickPause = NO;
    return NO;
}

- (void)play_beginOrresume
{
    for (NSInteger i = 0; i < self.currentCellsArray.count; i++) {
        MOLExaminePacketModeCell *cell = self.currentCellsArray[i];
        
        CGRect rect = [cell convertRect:cell.bounds toView:MOLAppDelegateWindow];
        
        
        if ([self canPlay:rect cell:cell]) {
            if (cell.player.status == PLPlayerStatusPaused) {
                if (!cell.clickPause) {
                    [cell.player resume];
                }
                continue;
            }else{
                if (!cell.player.isPlaying) {
                    MOLVideoOutsideModel *model = cell.videoOutsideModel;
                    if (model.contentType == 1) {
                        [cell.player playWithURL:[NSURL URLWithString:model.rewardVO.audioUrl]];
                    }else{
                        [cell.player playWithURL:[NSURL URLWithString:model.storyVO.audioUrl]];
                    }
                }
            }
        }else{
            if (cell.player.playing){
                [cell.player pause];
            }
        }
    }
}

- (void)play_resume
{
    for (NSInteger i = 0; i < self.currentCellsArray.count; i++) {
        MOLExaminePacketModeCell *cell = self.currentCellsArray[i];
        if (cell.player.playing) {
            [cell.player pause];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
  //  NSLog(@"scrollViewDidEndScrollingAnimation");
    if (self.businesstype == AttentionViewControllerType_Concerns) {
      [self play_beginOrresume];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
 //   NSLog(@"scrollViewDidEndDecelerating");
    if (self.businesstype == AttentionViewControllerType_Concerns) {
        [self play_beginOrresume];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    NSLog(@"scrollViewDidEndDragging -- %d",decelerate);
    if (self.businesstype == AttentionViewControllerType_Concerns) {
        if (!decelerate) {
            [self play_beginOrresume];
        }
    }
}

#pragma mark-
#pragma mark NSNotification
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MOL_SUCCESS_PUBLISHED object:nil];
}
- (void)registNotif{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOutEvent:) name:MOL_SUCCESS_USER_OUT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessfulEvent:) name:MOL_SUCCESS_USER_LOGIN object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(focusEventNotif:) name:MOL_SUCCESS_USER_FOCUS object:nil];
    
    // 监听发布成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successPublished) name:MOL_SUCCESS_PUBLISHED object:nil];
}

-(void)successPublished{
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self initUI];
//    });

}

- (void)logOutEvent:(NSNotification *)notif{
    NSLog(@"退出登录事件");
    [self initUI];
    [self.tableView reloadData];
}

- (void)loginSuccessfulEvent:(NSNotification *)notif{
    NSLog(@"登录成功事件");
    [self initUI];
}

- (void)focusEventNotif:(NSNotification *)notif{
    if (self.businesstype !=AttentionViewControllerType_Fans) {
        return;
    }
    if (notif.object) {
        NSArray *arr =[NSArray new];
        arr =(NSArray *)notif.object;
        NSString *toUserId =arr[0];
        if (![arr.lastObject boolValue]) {
            return;
        }
        __weak typeof(self) wself = self;
        for (MOLMsgUserModel*  obj in self.dataSource) {
            if (obj.userVO.userId.integerValue ==toUserId.integerValue) { //表示移除
                dispatch_async(dispatch_get_main_queue(), ^{
                    [wself.dataSource removeObject:obj];
                    [wself.tableView reloadData];
                    
                    if (wself.dataSource.count<=0) {
                        [wself initAttentionContentsData];
                        [wself.tableView.mj_header beginRefreshing];
                    }else{
                        wself.isFollowed =YES;
                    }
                });
            }
        }
        
        
        
        
//        if(arr.count>0){
//
//            NSMutableDictionary *dic =[NSMutableDictionary new];
//            [dic setObject:[NSString stringWithFormat:@"%@",toUserId] forKey:@"toUserId"];
//             __weak typeof(self) wself = self;
//            [[[MOLActionRequest alloc] initRequest_focusActionWithParameter:@{} parameterId:toUserId] baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
//                
//                if (code  != MOL_SUCCESS_REQUEST) {
//                    [OMGToast showWithText:message];
//                }else{
//                    for (MOLUserModel*  obj in self.dataSource) {
//                        if (obj.userId.integerValue ==toUserId.integerValue) { //表示移除
//                            dispatch_async(dispatch_get_main_queue(), ^{
//                                [wself.dataSource removeObject:obj];
//                                [wself.tableView reloadData];
//                                
//                                if (wself.dataSource.count<=0) {
//                                    [wself initAttentionContentsData];
//                                    [wself getAttentionUsersNetworkData];
//                                    [wself.tableView.mj_header beginRefreshing];
//                                }else{
//                                    wself.isFollowed =YES;
//                                }
//                            });
//                        }
//                    }
//                }
//
//            } failure:^(__kindof MOLBaseNetRequest *request) {
//               
//            }];
//        }
    }
}

#pragma mark -
#pragma mark 网络请求数据
- (void)refreshHome{
    [self.tableView.mj_header beginRefreshing];
}
- (void)refresh{
    self.pageIndex =1;
    self.refreshType =UIBehaviorTypeStyle_Refresh;
    self.dataSource =[NSMutableArray new];
    if (self.businesstype == AttentionViewControllerType_Fans) {
        [self getAttentionUsersNetworkData];
    }else{
        [self getAttentionContentsNetworkData];
    }
    
};

- (void)loadMore{
    self.pageIndex++;
    self.refreshType =UIBehaviorTypeStyle_More;
    if (self.businesstype == AttentionViewControllerType_Fans) {
        [self getAttentionUsersNetworkData];
    }else{
        [self getAttentionContentsNetworkData];
    }
}

- (void)getAttentionUsersNetworkData{
    [self basevc_hiddenErrorView];
    if (self.isFollowed && self.refreshType == UIBehaviorTypeStyle_Refresh) {
        //已关注且是下拉刷新事件，则请求关注内容接口否则请求关注用户接口
        [self initAttentionContentsData];
        self.refreshType =UIBehaviorTypeStyle_Refresh;
        [self getAttentionContentsNetworkData];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pageNum"] = @(self.pageIndex);
    dic[@"pageSize"] = @(self.pageNumber);
    __weak typeof(self) wself = self;
    [[[HomePageRequest alloc] initRequest_AttentionUsersParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        // 通知刷完成
        [[NSNotificationCenter defaultCenter] postNotificationName:MOL_HOME_REFRESHED object:nil];
       // if (wself.refreshType != UIBehaviorTypeStyle_Normal) {
            [wself.tableView.mj_header endRefreshing];
            [wself.tableView.mj_footer endRefreshing];
       // }

        if (code == MOL_SUCCESS_REQUEST) {
            if (responseModel) {
                // 解析数据
                MOLMsgUserGroupModel *groupModel = (MOLMsgUserGroupModel *)responseModel;
                
                //if (wself.refreshType != UIBehaviorTypeStyle_More) {
                    [wself.dataSource removeAllObjects];
                //}
                
                // 添加到数据源
                [wself.dataSource addObjectsFromArray:groupModel.resBody];
                
                [wself.tableView reloadData];
                
//                if (wself.dataSource.count >= groupModel.total) {
//                    wself.tableView.mj_footer.hidden = YES;
//
//                }else{
                      wself.tableView.mj_footer.hidden = NO;
//
//                }
                
            }
        }else{
            
        }
        

    } failure:^(__kindof MOLBaseNetRequest *request) {
        // 通知刷完成
        [[NSNotificationCenter defaultCenter] postNotificationName:MOL_HOME_REFRESHED object:nil];
        
       // if (self.refreshType != UIBehaviorTypeStyle_Normal) {
            [wself.tableView.mj_header endRefreshing];
            [wself.tableView.mj_footer endRefreshing];
       // }
        
        if (!self.dataSource.count) {
            [self basevc_showErrorPageWithY:0 select:@selector(getAttentionUsersNetworkData) superView:self.view];
        }
    }];
}

- (void)getAttentionContentsNetworkData{
    [self basevc_hiddenErrorView];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pageNum"] = @(self.pageIndex);
    dic[@"pageSize"] = @(self.pageNumber);
    __weak typeof(self) wself = self;
    [[[HomePageRequest alloc] initRequest_AttentionContentsParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        // 通知刷完成
        [[NSNotificationCenter defaultCenter] postNotificationName:MOL_HOME_REFRESHED object:nil];
        
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
                
                if (wself.dataSource.count<=0) { //表示没有关注内容
                    [wself initAttentionUsersData];
                    [wself getAttentionUsersNetworkData];
                }
                
                if (wself.dataSource.count >= mediaInfoList.total) {
                    wself.tableView.mj_footer.hidden = YES;

                }else{
                    wself.tableView.mj_footer.hidden = NO;

                }
            }
            
        }else{
            [OMGToast showWithText:message];
        }
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        // 通知刷完成
        [[NSNotificationCenter defaultCenter] postNotificationName:MOL_HOME_REFRESHED object:nil];
        if (wself.refreshType != UIBehaviorTypeStyle_Normal) {
            [wself.tableView.mj_header endRefreshing];
            [wself.tableView.mj_footer endRefreshing];
        }
        
        if (!self.dataSource.count) {
            [self basevc_showErrorPageWithY:0 select:@selector(getAttentionContentsNetworkData) superView:self.view];
        }
        
    }];
}

#pragma mark-
#pragma mark MOLExaminePacketModeCellDelegate
- (void)MOLExaminePacketModeCellEvent:(MOLVideoOutsideModel *)model{
    if (!model) {
        return;
    }
    NSInteger index=0;
    index=[self.dataSource indexOfObject:model];
    [self.dataSource removeObjectAtIndex:index];
    [self.tableView reloadData];
}

- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)textStorage atPoint:(CGPoint)point{
    if ([textStorage isKindOfClass:[TYLinkTextStorage class]])
    {
        NSString *title = ((TYLinkTextStorage*)textStorage).linkData;
        if (title && [title isEqualToString:@"请登录"]) {
            NSLog(@"用户事件触发");
            if (![MOLUserManagerInstance user_isLogin]) {
                [[MOLGlobalManager shareGlobalManager] global_modalLogin];
                return;
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self play_resume];
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
