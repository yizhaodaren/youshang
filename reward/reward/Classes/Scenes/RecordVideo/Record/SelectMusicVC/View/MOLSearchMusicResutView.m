//
//  MOLSearchResutView.m
//  reward
//
//  Created by apple on 2018/11/17.
//  Copyright © 2018 reward. All rights reserved.
//

#import "MOLSearchMusicResutView.h"
#import "MOLMusicModel.h"
#import "MOLMuiscCell.h"
#import "MOLMusicRequest.h"
@interface MOLSearchMusicResutView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIView  *lineView;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *searchSourceArray;
@property(nonatomic,strong)UIButton  *errorImageView;

//音乐
@property(nonatomic,strong)MOLMusicModel  *currentMusic;
@property (nonatomic, strong) NSURL* soundURL;//本地音乐源
@property (nonatomic,strong)AVAudioPlayer *auPlayer;//音乐播放器

//标记cell
@property (nonatomic,assign)NSInteger lastIndex;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic, assign) NSInteger currentPage;

//
@property(nonatomic,copy)NSString  *searchString;
@end

@implementation MOLSearchMusicResutView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.lineView];
        [self addSubview:self.tableview];
        [self showBlankPageimage:@"search_empty"];
        
    }
    return self;
}
-(void)removeData{
    [self.searchSourceArray removeAllObjects];
    [self.tableview reloadData];
    [self showBlankPageimage:@"search_empty"];
    [self.auPlayer stop];
}

-(void)getSearchNetDataWith:(NSString *)searchStr{
    self.searchString = searchStr;
    [self requestData];
}
-(void)requestData{
    self.index = -1;
    self.searchSourceArray = [NSMutableArray array];
    @weakify(self);
    self.tableview.mj_footer = [MOLDIYRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        
        [self request_getProductionDataList:YES];
    }];
    self.tableview.mj_footer.hidden = YES;
    
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
    dic[@"pageSize"] = @(MOL_REQUEST_COUNT_OTHER);
    dic[@"content"] = self.searchString;
    dic[@"type"] = @"music";
    
    MOLMusicRequest *r = [[MOLMusicRequest alloc] initRequest_MusicSearchWithParameter:dic];
    
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        
        [self.tableview.mj_footer endRefreshing];
        
        // 解析数据
        MOLMusicGroupModel *groupModel = (MOLMusicGroupModel *)responseModel;
        
        if (!isMore) {
            [self.searchSourceArray removeAllObjects];
        }
        
        // 添加到数据源
        [self.searchSourceArray addObjectsFromArray:groupModel.resBody];
        
        if (self.searchSourceArray.count > 0) {
            [self hiddenErrorView];
        }else{
            [self showBlankPageimage:@"search_empty"];
        }
        
        [self.tableview reloadData];
        
        if (self.searchSourceArray.count >= groupModel.total) {
            self.tableview.mj_footer.hidden = YES;
        }else{
            self.tableview.mj_footer.hidden = NO;
            self.currentPage += 1;
        }
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        [self.tableview.mj_footer endRefreshing];
        [self showBlankPageimage:@"network_error"];
    }];
}
-(void)sureBtnAction:(UIButton *)sender{
    NSLog(@"@%ld",sender.tag - 1030);
    if (self.useMusicBlock) {
        [self.auPlayer stop];
        self.useMusicBlock(self.soundURL,self.currentMusic);
        
    }
}

- (void)setupPlayerWith:(NSString *)path{
    self.soundURL = [NSURL fileURLWithPath:path];
    self.auPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.soundURL error:nil];
    self.auPlayer.numberOfLoops = -1;
    if (self.auPlayer) {
        [self.auPlayer play];
    }
}
#pragma mark 懒加载
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0,0,MOL_SCREEN_WIDTH, 5)];
        _lineView.backgroundColor = HEX_COLOR(0xF9F9F9);
    }
    return _lineView;
}
-(UITableView *)tableview{
    
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, self.lineView.bottom + 5, MOL_SCREEN_WIDTH, self.height - self.lineView.bottom - 5) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableview setBackgroundColor:[UIColor clearColor]];
        [_tableview registerNib:[UINib nibWithNibName:@"MOLMuiscCell" bundle:nil] forCellReuseIdentifier:@"MOLMuiscCell"];
    }
    return _tableview;
    
    
}
-(UIButton *)errorImageView{
        if (!_errorImageView) {
            _errorImageView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        }
        return _errorImageView;
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
    Cell.sureBtn.tag =  10030 + indexPath.row;
    [Cell.sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
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
        [self.tableview reloadRowsAtIndexPaths:@[lastIndexPath,indexPath] withRowAnimation:UITableViewRowAnimationFade];
    });
    
}


// 隐藏失败
- (void)hiddenErrorView
{
    [self.errorImageView removeFromSuperview];
}
// 展示空白页
- (void)showBlankPageimage:(NSString *)image
{
    [self.errorImageView removeFromSuperview];
    if (image.length) {
        [self.errorImageView setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [self.errorImageView setImage:[UIImage imageNamed:image] forState:UIControlStateSelected];
    }
    [self addSubview:self.errorImageView];
    
//    UIImageView *blankView = [[UIImageView alloc] init];
//    _blankImageView = blankView;
//    blankView.userInteractionEnabled = YES;
//    //    blankView.image = [UIImage imageNamed:@"home_backImage"];
//    blankView.y = localY < 0 ? 0 : localY;
//    blankView.width = view.width;
//    blankView.height = view.height - fabs(localY);
//    [view addSubview:blankView];
//
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setTitle:title forState:UIControlStateNormal];
//    [btn setTitleColor:HEX_COLOR_ALPHA(0xffffff, 0.3) forState:UIControlStateNormal];
//    if (image.length) {
//        [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
//    }
//    btn.width = blankView.width;
//    btn.height = 250;
//    //    btn.y = blankView.height - btn.height;
//    btn.centerY = blankView.height * 0.5;
//    btn.titleLabel.lineBreakMode = 0;
//    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [btn mol_setButtonImageTitleStyle:ButtonImageTitleStyleBottom padding:20];
//    [blankView addSubview:btn];
}

@end
