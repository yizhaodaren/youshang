//
//  MOLMusicListViewController.m
//  reward
//
//  Created by apple on 2018/11/17.
//  Copyright © 2018 reward. All rights reserved.
//

#import "MOLMusicListViewController.h"
#import "MOLMusicModel.h"
#import "MOLMuiscCell.h"
#import "MOLMusicRequest.h"

//tag
#define COLL_BtnTag  2030
#define SURE_BtnTag  1030
@interface MOLMusicListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *searchSourceArray;

//音乐
@property(nonatomic,strong)MOLMusicModel  *currentMusic;
@property (nonatomic, strong) NSURL* soundURL;//本地音乐源
@property (nonatomic,strong)AVAudioPlayer *auPlayer;//音乐播放器

//标记cell
@property (nonatomic,assign)NSInteger lastIndex;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation MOLMusicListViewController
-(instancetype)initWithMusicTpey:(MOLMusicType)type TableH:(CGFloat)height{
    self = [super init];
    if (self) {
        self.tableViewHeight = height;
        self.currentMusicType = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self requestData];
}
-(void)requestData{
    self.index = -1;
    self.searchSourceArray = [NSMutableArray array];
    @weakify(self);
    MJRefreshNormalHeader *header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self request_getMusicDataList:NO];
    }];
    header.stateLabel.textColor = [UIColor blackColor];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        @strongify(self);
        
        [self request_getMusicDataList:YES];
    }];
    footer.stateLabel.textColor = [UIColor blackColor];

    self.tableView.mj_footer = footer;
    self.tableView.mj_footer.hidden = YES;
    
    [self request_getMusicDataList:NO];
}
#pragma mark - 网络请求音乐数据
- (void)request_getMusicDataList:(BOOL)isMore
{
    if (self.currentMusicType == MOLMusicType_collect) {
        [self request_getMusiCollectList:isMore];
        return;
    }
    
//    推荐 热门
    if (!isMore) {
        self.currentPage = 1;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pageNum"] = @(self.currentPage);
    dic[@"pageSize"] = @(MOL_REQUEST_COUNT_OTHER);
    
    if (self.currentMusicType == MOLMusicType_recommend) {
        dic[@"sort"] = @1;
    }else if(self.currentMusicType == MOLMusicType_hot){
        dic[@"sort"] = @2;
    }else{
        
    }
    MOLMusicRequest *r = [[MOLMusicRequest alloc] initRequest_MusicListWithParameter:dic];
    
    //用过的
    if (self.currentMusicType == MOLMusicType_log) {
         r = [[MOLMusicRequest alloc] initRequest_MusiclogWithParameter:dic];
    }
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        
        // 解析数据
        MOLMusicGroupModel *groupModel = (MOLMusicGroupModel *)responseModel;
        
        if (!isMore) {
            [self.searchSourceArray removeAllObjects];
        }
        
        // 添加到数据源
        [self.searchSourceArray addObjectsFromArray:groupModel.resBody];
        
        [self.tableView reloadData];
        
        if (self.searchSourceArray.count >= groupModel.total) {
            self.tableView.mj_footer.hidden = YES;
        }else{
            self.tableView.mj_footer.hidden = NO;
            self.currentPage += 1;
        }
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
}
#pragma mark - 网络请求收藏列表
- (void)request_getMusiCollectList:(BOOL)isMore
{
    if (!isMore) {
        self.currentPage = 1;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pageNum"] = @(self.currentPage);
    dic[@"pageSize"] = @(MOL_REQUEST_COUNT_OTHER);

    MOLMusicRequest *r = [[MOLMusicRequest alloc] initRequest_MusicCollectListWithParameter:dic];
    
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        // 解析数据
        MOLMusicGroupModel *groupModel = (MOLMusicGroupModel *)responseModel;
        
        if (!isMore) {
            [self.searchSourceArray removeAllObjects];
        }
        // 添加到数据源
        [self.searchSourceArray addObjectsFromArray:groupModel.resBody];
        [self.tableView reloadData];
        if (self.searchSourceArray.count >= groupModel.total) {
            self.tableView.mj_footer.hidden = YES;
        }else{
            self.tableView.mj_footer.hidden = NO;
            self.currentPage += 1;
        }
    } failure:^(__kindof MOLBaseNetRequest *request) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
}


#pragma mark - 收藏音乐
- (void)collectMusicRequestWith:(MOLMusicModel *)model WithButton:(UIButton *)sender
{
    sender.enabled = NO;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"type"] = @(0);
    dic[@"typeId"] = @(model.musicId);
    
    MOLMusicRequest *r = [[MOLMusicRequest alloc] initRequest_MusicCollectWithParameter:dic];
    
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        MOLCollectResultModel *resultModel = (MOLCollectResultModel *)responseModel;
        sender.enabled = YES;
        if (resultModel.resBody == 1) {
            sender.selected = YES;
            NSLog(@"%ld",sender.tag);
            model.isCollect = 1;
            [MBProgressHUD showMessageAMoment:@"收藏成功!"];
        }else{
            sender.selected = NO;
            NSLog(@"%ld",sender.tag);
            model.isCollect = 0;
            [MBProgressHUD showMessageAMoment:@"取消收藏成功!"];
        }
 
    } failure:^(__kindof MOLBaseNetRequest *request) {
        sender.enabled = YES;
             [MBProgressHUD showMessageAMoment:@"操作失败!"];
    }];
}

#pragma mark 确认使用
-(void)sureBtnAction:(UIButton *)sender{
    NSLog(@"@%ld",sender.tag - SURE_BtnTag);
//    BOOL isHave = [[NSFileManager defaultManager] fileExistsAtPath:self.soundURL.absoluteString];
    if (self.useMusicBlock) {
          [self.auPlayer stop];
         self.useMusicBlock(self.soundURL,self.currentMusic);
      
    }
}
#pragma mark 收藏
-(void)collectAction:(UIButton *)sender{
    NSInteger index = sender.tag - COLL_BtnTag;
    MOLMusicModel *model = self.searchSourceArray[index];
    [self collectMusicRequestWith:model WithButton:sender];
}

- (void)setupPlayerWith:(NSString *)path{
    self.soundURL = [NSURL fileURLWithPath:path];
    self.auPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.soundURL error:nil];
    self.auPlayer.numberOfLoops = -1;
    if (self.auPlayer) {
        [self.auPlayer play];
    }
}

-(void)stopMusic{
    [self.auPlayer stop];
    self.index = -1;
    [self.tableView reloadData];
}
#pragma mark 懒加载

-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MOL_SCREEN_WIDTH, self.view.height - self.tableViewHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView registerNib:[UINib nibWithNibName:@"MOLMuiscCell" bundle:nil] forCellReuseIdentifier:@"MOLMuiscCell"];
    }
    return _tableView;
    
    
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.searchSourceArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MOLMuiscCell * Cell  = [tableView dequeueReusableCellWithIdentifier:@"MOLMuiscCell"];
    Cell.musciModel = self.searchSourceArray[indexPath.row];
    if (self.index == indexPath.row) {
        Cell.sureBtn.hidden = NO;
    }else{
        Cell.sureBtn.hidden = YES;
    }
    Cell.sureBtn.tag =  SURE_BtnTag + indexPath.row;
    [Cell.sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    Cell.collectBtn.tag = COLL_BtnTag + indexPath.row;
    [Cell.collectBtn addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];

    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return Cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.index == indexPath.row) {
        return 160;
    }else{
        return 100;
    }
    
    
}

#pragma mark 选择音乐
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.lastIndex = self.index;
    self.index = indexPath.row;
    
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.lastIndex inSection:0];
    
    if (self.lastIndex == self.index) {
        return;
    }else{
        self.selectedBlock();
    }
    
    MOLMusicModel *model = self.searchSourceArray[indexPath.row];
    self.currentMusic = model;
    NSString *ad_voice = model.url;
    NSString *filePath =[MOLCacheFileManager getMusicFilePath:[NSString stringWithFormat:@"%ld.mp3",(long)model.musicId]] ;
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {//如果不存在就存储 存在就不存
        
        [MBProgressHUD showMessage:@"加载中..."];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *urlStr = [NSString stringWithFormat:@"%@",ad_voice];
            NSURL *url1 = [[NSURL alloc]initWithString:urlStr];
            NSData * audioData = [NSData dataWithContentsOfURL:url1];
            [audioData writeToFile:filePath atomically:YES];
            [self setupPlayerWith:filePath];
            [MBProgressHUD hideHUD];
        });
    }
    
    [self setupPlayerWith:filePath];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadRowsAtIndexPaths:@[lastIndexPath,indexPath] withRowAnimation:UITableViewRowAnimationFade];
    });
    
}

@end
