//
//  MOLMusicDetailViewController.m
//  reward
//
//  Created by apple on 2018/11/13.
//  Copyright © 2018 reward. All rights reserved.
//

#import "MOLMusicDetailViewController.h"

#import "MOLRecordViewController.h"
#import "MOLReleaseManager.h"
#import "RewardRequest.h"
#import "HomeShareView.h"
#import "RecommendViewController.h"
#import "MOLMineViewController.h"
#import "MOLOtherUserViewController.h"
#import "MOLSameMusicStoryViewController.h"
#import "MOLUserPageRequest.h"
#import "MOLMusicRequest.h"

@interface MOLMusicDetailViewController ()<HomeShareViewDelegate,JAHorizontalPageViewDelegate>


@property (nonatomic, strong) JAHorizontalPageView *pageView;


@property (nonatomic,strong)UIView  *headerView;
@property (nonatomic, strong)UIImageView *headerImageView;
@property (nonatomic, strong) UIView *backView;//蒙层
@property (nonatomic, strong)UIView *headerInfoView;



@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) YYLabel *musicNameLable;
@property (nonatomic, strong) UILabel *authorLable;
@property (nonatomic, strong) UILabel *totalLable;//一共视频数目
@property (nonatomic, strong) UIButton *collectButton;//收藏

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, weak) UIView *bottomLView;

///////////////////////////////////////////////////////////////

@property (nonatomic, strong) UIButton *publishButton;
@property (nonatomic, strong) HomeShareView *shareView;



@property (nonatomic,strong)AVAudioPlayer *auPlayer;//音乐播放器
@property(nonatomic,strong) NSURL *currentMusicUrl; //当前音乐的本地URL
@property(nonatomic,strong)MOLMusicModel *currentMusicModel;
@end
@implementation MOLMusicDetailViewController
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self getMusicInfoData];
}

- (void)initUI{
    
    
    [self.headerView addSubview:self.headerInfoView];
    
    
    [self layoutheaderInfoView];
    [self.view addSubview:self.pageView];
    [self.pageView reloadPage];
    
    
    //拍同款
    self.publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.publishButton setImage:[UIImage imageNamed:@"with_pat2"] forState:UIControlStateNormal];
    [self.publishButton addTarget:self action:@selector(button_clickPublishButton) forControlEvents:UIControlEventTouchUpInside];
    [self.publishButton sizeToFit];
    self.publishButton.centerX = self.view.width * 0.5;
    self.publishButton.bottom = self.view.height - 30;
    [self.view addSubview:self.publishButton];
    
    
    UIBarButtonItem *rightItem = [UIBarButtonItem mol_barButtonItemWithImageName:@"report" highlightImageName:@"report" targat:self action:@selector(rightButtonEvent:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
}
- (void)layoutheaderInfoView{
    
    self.iconImage =[UIImageView new];
    [self.iconImage setUserInteractionEnabled:YES];
    self.iconImage.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImage.clipsToBounds = YES;
    [self.iconImage setUserInteractionEnabled:YES];
    UITapGestureRecognizer *iconImageTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImageTapEvent:)];
    [self.iconImage addGestureRecognizer:iconImageTap];
    [self.headerInfoView addSubview:self.iconImage];
    
    
    //开始
    self.playButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.playButton addTarget:self action:@selector(playButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.playButton setImage:[UIImage imageNamed:@"mine_reward_play"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"mine_reward_suspended"] forState:UIControlStateSelected];
    [self.iconImage addSubview:self.playButton];
    
    
    //名称
    self.musicNameLable =[YYLabel new];
    [self.musicNameLable setFont: MOL_MEDIUM_FONT(14)];
    [self.musicNameLable setTextColor:HEX_COLOR(0xffffff)];
    [self.musicNameLable setText:@"加载中..."];
    [self.musicNameLable setUserInteractionEnabled:YES];
    
    [self.headerInfoView addSubview:self.musicNameLable];
    
    
    //作者
    self.authorLable =[UILabel new];
    [self.authorLable setFont: MOL_REGULAR_FONT(12)];
    [self.authorLable setTextColor:HEX_COLOR_ALPHA(0xffffff,0.6)];
    [self.authorLable setText:@"作者..."];
    //    UITapGestureRecognizer *nameTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userEvent)];
    //    [self.authorLable addGestureRecognizer:nameTap];
    [self.headerInfoView addSubview:self.authorLable];
    
    //视频数目
    self.totalLable =[UILabel new];
    [self.totalLable setFont: MOL_REGULAR_FONT(12)];
    [self.totalLable setTextColor:HEX_COLOR_ALPHA(0xffffff,0.6)];
    [self.totalLable setText:@"视频1"];
    [self.headerInfoView addSubview:self.totalLable];
    
    
    //收藏
    self.collectButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.collectButton addTarget:self action:@selector(collectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.collectButton.backgroundColor = HEX_COLOR_ALPHA(0xFFFFFF, 0.2);
    self.collectButton.titleLabel.font = MOL_MEDIUM_FONT(14);
    [self.collectButton setTitle:@"收藏" forState:UIControlStateNormal];
    [self.collectButton setTitleColor:HEX_COLOR_ALPHA(0xFFFFFF, 1) forState:UIControlStateNormal];
    [self.collectButton setTitle:@"已收藏" forState:UIControlStateSelected];
    [self.collectButton setTitleColor:HEX_COLOR_ALPHA(0xFFFFFF, 0.6) forState:UIControlStateNormal];
    [self.headerInfoView addSubview:self.collectButton];
    
    
    self.lineView =[UIView new];
    [self.lineView setBackgroundColor:HEX_COLOR_ALPHA(0xffffff, 0.2)];
    [self.headerInfoView addSubview:self.lineView];
    [self layoutUpdateHeaderLayer];
}

- (void)layoutUpdateHeaderLayer{
    
    
    //    _headerInfoView.frame = CGRectMake(0,0, self.view.frame.size.width,headerH);
    self.bottomLView.y = _headerInfoView.height - 1;
    [self.headerImageView setFrame: CGRectMake(0, 0, self.headerInfoView.width, self.headerInfoView.height)];
    
    
    __weak typeof(self) wself = self;
    
    [self.iconImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(60+MOL_StatusBarHeight);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(120);
    }];
    [self.iconImage.layer setMasksToBounds:YES];
    [self.iconImage.layer setCornerRadius:2];
    
    [self.playButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(wself.iconImage);
        make.width.mas_equalTo(30/2.0);
        make.height.mas_equalTo(36/2.0);
    }];
    // 23 + 17 + 17+ 17 + 17 +17 + 25;
    [self.musicNameLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wself.iconImage.mas_right).offset(15);
        //make.right.mas_equalTo(wself.headerInfoView);
        make.top.mas_equalTo(wself.iconImage.mas_top);
        make.right.mas_equalTo(self.headerInfoView.mas_right);
        make.height.mas_equalTo(23);
    }];
    
    [self.authorLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wself.musicNameLable.mas_left);
        make.top.mas_equalTo(wself.musicNameLable.mas_bottom).offset(12);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(self.musicNameLable);
    }];
    
    [self.totalLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wself.musicNameLable.mas_left);
        make.top.mas_equalTo(wself.authorLable.mas_bottom).offset(12);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(self.musicNameLable);
    }];
    
    [self.collectButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wself.musicNameLable.mas_left);
        make.top.mas_equalTo(wself.totalLable.mas_bottom).offset(12);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(70);
    }];
    self.collectButton.layer.cornerRadius = 25/2;
    self.collectButton.clipsToBounds = YES;
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself.iconImage.mas_bottom).offset(20);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(0.5);
    }];
}
#pragma mark- 网络请求音乐信息
- (void)getMusicInfoData{
    
    MOLMusicRequest *r = [[MOLMusicRequest alloc] initRequest_MusicInfoWithParameter:nil parameterId:[NSString stringWithFormat:@"%ld",self.musicId]];
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        // 解析数据
        MOLMusicModel *Model = (MOLMusicModel *)responseModel;
        self.currentMusicModel = Model;
        [self setupUIWith:Model];
        [self playMusic];
        //         playButtonEvent:self.playButton];
    } failure:^(__kindof MOLBaseNetRequest *request) {
        
    }];
}
-(void)setupUIWith:(MOLMusicModel *)model{
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"屏幕快照 2018-09-12 下午3.28.04"] options:SDWebImageRetryFailed];
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.thumb ? model.thumb:@""] placeholderImage:[UIImage new] options:SDWebImageRetryFailed];
    [self.musicNameLable setText:[NSString stringWithFormat:@"%@",model.name?model.name:@""]];
    [self.authorLable setText:[NSString stringWithFormat:@"%@",model.author?model.author:@""]];
    [self.totalLable setText:[NSString stringWithFormat:@"视频%ld",(long)model.storyCount]];
    if (model.isCollect == 1) {
        self.collectButton.selected = YES;
    }else{
        self.collectButton.selected = NO;
    }
}
#pragma mark 收藏
-(void)collectButtonAction:(UIButton *)sender{
    sender.enabled = NO;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"type"] = @(0);
    dic[@"typeId"] = @(self.musicId);
    
    MOLMusicRequest *r = [[MOLMusicRequest alloc] initRequest_MusicCollectWithParameter:dic];
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        MOLCollectResultModel *resultModel = (MOLCollectResultModel *)responseModel;
        sender.enabled = YES;
        if (resultModel.resBody == 1) {
            sender.selected = YES;
            NSLog(@"%ld",sender.tag);
            [MBProgressHUD showMessageAMoment:@"收藏成功!"];
            [sender setTitle:@"已收藏" forState:UIControlStateNormal];
        }else{
            sender.selected = NO;
            NSLog(@"%ld",sender.tag);
            [MBProgressHUD showMessageAMoment:@"取消收藏成功!"];
            [sender setTitle:@"收藏" forState:UIControlStateNormal];
        }
    } failure:^(__kindof MOLBaseNetRequest *request) {
        sender.enabled = YES;
        [MBProgressHUD showMessageAMoment:@"操作失败!"];
    }];
    
}
- (void)recommendEvent{
    RecommendViewController *vc = [[RecommendViewController alloc] init];
    PLMediaInfo *info = [[PLMediaInfo alloc] init];
    info.index = 0;
    info.rewardId = self.rewardModel.rewardVO.rewardId;
    info.userId = self.rewardModel.rewardVO.userVO.userId;
    info.businessType = HomePageBusinessType_RewardDetail;
    info.pageNum =1;
    info.pageSize =MOL_REQUEST_COUNT_VEDIO;
    vc.mediaDto = info;
    
    [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
}

- (void)iconImageTapEvent:(UITapGestureRecognizer *)tap{
    [self playButtonEvent:self.playButton];
}

- (void)playButtonEvent:(UIButton *)sender{
    if (!sender.selected) {
        [self startMusic];
    }else{
        [self stopMusic];
    }
    
}
-(void)playMusic{
    NSString *ad_voice = self.currentMusicModel.url;
    NSString *filePath =[MOLCacheFileManager getMusicFilePath:[NSString stringWithFormat:@"%ld.mp3",(long)self.musicId]] ;
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
    }else{
        [self setupPlayerWith:filePath];
    }
    
}

- (void)setupPlayerWith:(NSString *)path{
    self.currentMusicUrl = [NSURL fileURLWithPath:path];
    self.auPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    self.auPlayer.numberOfLoops = -1;
    if (self.auPlayer) {
        
    }
}
-(void)startMusic{
    if (self.auPlayer) {
        [self.auPlayer play];
        self.playButton.selected = YES;
    }
}

-(void)stopMusic{
    [self.auPlayer stop];
    self.playButton.selected = NO;
    
}
- (void)rightButtonEvent:(UIBarButtonItem *)sender{
    // NSLog(@"分享控件实现");
    [self.view addSubview:self.shareView];
    
}
#pragma mark -
#pragma mark HomeShareViewDelegate
- (void)homeShareView:(MOLVideoOutsideModel *)model businessType:(HomeShareViewBusinessType)businessType type:(HomeShareViewType)shareType;{
    self.shareView =nil;
    switch (shareType) {
        case HomeShareViewWechat: //朋友圈
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
        }
            break;
        case HomeShareViewWeixin: //微信好友
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
        }
            break;
        case HomeShareViewMqMzone: //QQ空间
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_Qzone];
        }
            break;
        case HomeShareViewQQ: //QQ
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_QQ];
        }
            break;
        case HomeShareViewSinaweibo: //微博
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_Sina];
        }
            break;
    }
    
}

#pragma mark-
#pragma mark 分享实现
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    NSString* thumbURL =  self.currentMusicModel.shareMsgVO.shareImg?self.currentMusicModel.shareMsgVO.shareImg:@"";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.currentMusicModel.shareMsgVO.shareTitle?self.currentMusicModel.shareMsgVO.shareTitle:@"" descr:self.currentMusicModel.shareMsgVO.shareContent?self.currentMusicModel.shareMsgVO.shareContent:@"" thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = self.currentMusicModel.shareMsgVO.shareUrl?self.currentMusicModel.shareMsgVO.shareUrl:@"";
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
            
        }
    }];
}

#pragma mark 同音拍摄
- (void)button_clickPublishButton
{
    
    if (![MOLUserManagerInstance user_isLogin]) {
        [[MOLGlobalManager shareGlobalManager] global_modalLogin];
        return;
    }
    
    if (!self.currentMusicModel || !self.currentMusicUrl) {
        [MBProgressHUD showMessageAMoment:@"加载失败，请重新进入页面再试!"];
        return;
    }
    
    
    //暂停当前音乐
    [self stopMusic];
    MOLRecordViewController *vc = [[MOLRecordViewController alloc] init];
    vc.originalMusicModel = self.currentMusicModel;
    vc.originalMusicUrl  = self.currentMusicUrl;
    [MOLReleaseManager manager].rewardID = 0;
    [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
    
}


- (void)userEvent{
    
    MOLUserModel *userVO =[MOLUserModel new];
    if (self.rewardModel.contentType ==1) { //悬赏
        userVO =self.rewardModel.rewardVO.userVO;
    }else{
        userVO =self.rewardModel.storyVO.userVO;
    }
    
    if ([[MOLGlobalManager shareGlobalManager] isUserself:userVO]) {
        MOLMineViewController *vc = [[MOLMineViewController alloc] init];
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
    }else{
        MOLOtherUserViewController *vc = [[MOLOtherUserViewController alloc] init];
        vc.userId = [NSString stringWithFormat:@"%@",userVO.userId?userVO.userId:@""];
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
    }
}



#pragma mark-
#pragma mark
#pragma mark - delegate
- (NSInteger)numberOfSectionPageView:(JAHorizontalPageView *)view   // 返回几个控制器
{
    return 1;
}
- (UIScrollView *)horizontalPageView:(JAHorizontalPageView *)pageView viewAtIndex:(NSInteger)index   // 返回每个控制器的view
{
    
    MOLSameMusicStoryViewController *vc =[[MOLSameMusicStoryViewController alloc] initWith:self.musicId];
    vc.view.backgroundColor = [UIColor clearColor];
    MJWeakSelf
    vc.stopMusicBlock = ^{
        [weakSelf stopMusic];
    };
    
    [self addChildViewController:vc];
    return (UIScrollView *)vc.collectionView;
}
- (UIView *)headerViewInPageView:(JAHorizontalPageView *)pageView {// 返回头部
    
    return self.headerView;
}
- (CGFloat)headerHeightInPageView:(JAHorizontalPageView *)pageView    // 返回头部高度
{
    return self.headerView.height;
}

- (CGFloat)topHeightInPageView:(JAHorizontalPageView *)pageView   // 控制在什么地方悬停
{
    return MOL_StatusBarAndNavigationBarHeight;
}

- (void)horizontalPageView:(JAHorizontalPageView *)pageView scrollTopOffset:(CGFloat)offset   // 滚动的偏移量
{
    
    if (offset < 0) {
        self.headerImageView.y = offset;
        self.headerImageView.height = self.headerView.height - offset;
    }else{
        self.headerImageView.y = 0;
        self.headerImageView.height = self.headerView.height;
    }
    self.backView.frame = self.headerImageView.bounds;
    
    //header过渡效果
    CGFloat lineBotH = MOL_StatusBarAndNavigationBarHeight;
    CGFloat lineTopH = self.headerInfoView.height - lineBotH;
    CGFloat alpha = 1- offset /lineTopH;
    if (alpha < 0) {
        alpha = 0.0;
    }
    self.headerInfoView.alpha =alpha;
    
    
    
    //标题过渡效果
    CGFloat dis = offset - (lineTopH - MOL_StatusBarAndNavigationBarHeight);
    
    if (dis > 0) {
        CGFloat alpha = dis / MOL_StatusBarAndNavigationBarHeight;
        //用户名称
        [self basevc_setCenterTitle:self.currentMusicModel.name titleColor:HEX_COLOR_ALPHA(0xffffff, alpha)];
    }else{
        //用户名称
        [self basevc_setCenterTitle:self.currentMusicModel.name titleColor:HEX_COLOR_ALPHA(0xffffff, 0)];
    }
}

#pragma mark 懒加载
- (HomeShareView *)shareView{
    if (!_shareView) {
        _shareView =[HomeShareView new];
        [_shareView setFrame:CGRectMake(0, 0, MOL_SCREEN_WIDTH, MOL_SCREEN_HEIGHT)];
        _shareView.currentBusinessType = HomeShareViewBusinessRewardType;
        [_shareView contentIcon:@[@"pengyouquan",@"weixin",@"qqkongjian",@"qq",@"weibo"]];
        _shareView.delegate =self;
    }
    return _shareView;
}

-(UIImageView *)headerImageView{
    if (!_headerImageView) {
        _headerImageView =[UIImageView new];
        [_headerImageView setImage:[UIImage imageNamed:@"屏幕快照 2018-09-12 下午3.28.04"]];
        _headerImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headerImageView.clipsToBounds = YES;
    }
    return _headerImageView;
}


-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        CGFloat headerH = MOL_StatusBarHeight + 60 + 120 + 20 + 0.5;
        _headerView.frame = CGRectMake(0,0, self.view.frame.size.width,headerH);
        
        self.headerImageView.frame = _headerView.bounds;
        [_headerView addSubview:self.headerImageView];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        _backView = blurEffectView;
        blurEffectView.frame = self.headerImageView.bounds;
        [self.headerImageView addSubview:blurEffectView];
        
    }
    return _headerView;
}
- (UIView *)headerInfoView {
    if (!_headerInfoView) {
        
        CGFloat headerH = MOL_StatusBarHeight + 60 + 120 + 20 + 0.5;
        _headerInfoView = [[UIView alloc] init];
        _headerInfoView.width = MOL_SCREEN_WIDTH;
        _headerInfoView.height = headerH;
        
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.1);
        line.width = MOL_SCREEN_WIDTH;
        line.height = 1;
        line.y = _headerInfoView.height - 1;
        self.bottomLView =line;
        [_headerInfoView addSubview:line];
    }
    return _headerInfoView;
}


- (JAHorizontalPageView *)pageView{
    if (!_pageView) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        _pageView = [[JAHorizontalPageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) delegate:self];
        _pageView.horizontalCollectionView.scrollEnabled = NO;
        _pageView.needHeadGestures = YES;
        //        _pageView.needMiddleRefresh = YES;;
    }
    return _pageView;
}

@end

