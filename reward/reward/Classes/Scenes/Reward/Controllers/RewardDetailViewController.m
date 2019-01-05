//
//  RewardDetailViewController.m
//  reward
//
//  Created by xujin on 2018/9/23.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "RewardDetailViewController.h"
#import "AwardListViewController.h"
#import "ParticipatingWorksController.h"
#import "WMPageController.h"
#import "MOLGiftCountView.h"
#import "MOLRecordViewController.h"
#import "MOLReleaseManager.h"
#import "RewardRequest.h"
#import "HomeShareView.h"
#import "RecommendViewController.h"
#import "MOLMineViewController.h"
#import "MOLOtherUserViewController.h"

#import "MOLStatistics.h"
#import "OMGAttributedLabel.h"


@interface RewardDetailViewController ()<JAHorizontalPageViewDelegate, SPPageMenuDelegate,HomeShareViewDelegate,TYAttributedLabelDelegate>
@property (nonatomic,strong)NSArray *classArr;
@property (nonatomic,strong)NSArray *titleArr;

@property (nonatomic, strong)UIView *headerView;
@property (nonatomic, strong)UIImageView *headerImage;
@property (nonatomic, strong) WMPageController *pageController;
@property (nonatomic, strong) JAHorizontalPageView *pageView;
@property (nonatomic, strong) SPPageMenu *pageMenu;

///////////////////////////////////////////////////////////////
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) YYLabel *titleLable;
@property (nonatomic, strong) UILabel *rewardTip;
@property (nonatomic, strong) UIButton *goldButton;
@property (nonatomic, strong) UIImageView *giftImageView;
@property (nonatomic, strong) MOLGiftCountView *giftCountView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, weak) UIView *bottomLView;
@property (nonatomic, strong) OMGAttributedLabel *contentLable;

///////////////////////////////////////////////////////////////

@property (nonatomic, strong) UIButton *publishButton;
@property (nonatomic, strong) HomeShareView *shareView;
@end

@implementation RewardDetailViewController

-(UIImageView *)headerImage{
    if (!_headerImage) {
        _headerImage =[UIImageView new];
        [_headerImage setImage:[UIImage imageNamed:@"屏幕快照 2018-09-12 下午3.28.04"]];
    }
    return _headerImage;
}

- (SPPageMenu *)pageMenu{
    if (!_pageMenu) {
        _pageMenu =[SPPageMenu pageMenuWithFrame:CGRectZero trackerStyle:SPPageMenuTrackerStyleLine];
        _pageMenu.backgroundColor = HEX_COLOR(0x0E0F1A);
        [_pageMenu setBackgroundColor: [UIColor clearColor]];
        _pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
        _pageMenu.itemTitleFont = MOL_MEDIUM_FONT(16);
        _pageMenu.selectedItemTitleColor = HEX_COLOR(0xffffff);
        _pageMenu.unSelectedItemTitleColor = HEX_COLOR_ALPHA(0xffffff, 0.6);
        [_pageMenu setTrackerHeight:2 cornerRadius:0];
        _pageMenu.tracker.backgroundColor = HEX_COLOR(0xFFEC00);
        _pageMenu.needTextColorGradients = NO;
        _pageMenu.dividingLine.hidden = YES;
        _pageMenu.itemPadding = 20;
        [_pageMenu setItems:self.titleArr selectedItemIndex:0];
        _pageMenu.bridgeScrollView = (UIScrollView *)self.pageView.horizontalCollectionView;
        
        _pageMenu.delegate = self;
    }
    return _pageMenu;
}



- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectZero];
        _headerView.frame = CGRectMake(0,0, self.view.frame.size.width,360);
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.1);
        line.width = MOL_SCREEN_WIDTH;
        line.height = 1;
        line.y = _headerView.height - 1;
        self.bottomLView =line;
        [_headerView addSubview:line];
    }
    return _headerView;
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}

- (void)dealloc
{
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    
    //if (!self.rewardModel) { //表示只有悬赏id
    [self getRewardDetailNetworkData];
    //    }else{
    //        [self initUI];
    //    }
    
}



- (void)initUI{
    [self layoutNavigationBar];
    [self layoutUI];
}

#pragma mark - 导航条
- (void)layoutNavigationBar
{
//    if (self.rewardModel.rewardVO.rewardType == 1) {//红包悬赏
//        [self basevc_setCenterTitle:@"红包悬赏" titleColor:HEX_COLOR(0xffffff)];
//    }else{
//        [self basevc_setCenterTitle:@"排名悬赏" titleColor:HEX_COLOR(0xffffff)];
//    }
    
    //用户名称
//     [self basevc_setCenterTitle:self.rewardModel.rewardVO.userVO.userName titleColor:HEX_COLOR(0xffffff)];
    
    UIBarButtonItem *rightItem = [UIBarButtonItem mol_barButtonItemWithImageName:@"report" highlightImageName:@"report" targat:self action:@selector(rightButtonEvent:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)initData{
    self.titleArr =@[@"参与作品",@"获奖清单"];
}

- (void)layoutHeaderView{
    
    
    
    self.iconImage =[UIImageView new];
    [self.iconImage setUserInteractionEnabled:YES];
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:self.rewardModel.rewardVO.coverImage?self.rewardModel.rewardVO.coverImage:@""] placeholderImage:[UIImage new] options:SDWebImageRetryFailed];
    self.iconImage.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImage.clipsToBounds = YES;
    [self.iconImage setUserInteractionEnabled:YES];
    UITapGestureRecognizer *iconImageTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImageTapEvent:)];
    [self.iconImage addGestureRecognizer:iconImageTap];
    [self.headerView addSubview:self.iconImage];
    
    self.playButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.playButton addTarget:self action:@selector(playButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.playButton setImage:[UIImage imageNamed:@"mine_reward_play"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"mine_reward_suspended"] forState:UIControlStateSelected];
    [self.iconImage addSubview:self.playButton];
    
    self.titleLable =[YYLabel new];
    [self.titleLable setFont: MOL_MEDIUM_FONT(14)];
    [self.titleLable setTextColor:HEX_COLOR(0xffffff)];
    [self.titleLable setText:[NSString stringWithFormat:@"@%@",self.rewardModel.rewardVO.userVO.userName?self.rewardModel.rewardVO.userVO.userName:@""]];
    [self.titleLable setUserInteractionEnabled:YES];
    UITapGestureRecognizer *nameTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userEvent)];
    [self.titleLable addGestureRecognizer:nameTap];
    [self.headerView addSubview:self.titleLable];
    
    
    self.rewardTip =[UILabel new];
    [self.rewardTip setFont: MOL_REGULAR_FONT(12)];
    [self.rewardTip setTextColor:HEX_COLOR_ALPHA(0xffffff,0.6)];
    [self.rewardTip setText:@"悬赏金币："];
    [self.headerView addSubview:self.rewardTip];
    
    self.goldButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goldButton.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.1);
    [self.goldButton setImage:[UIImage imageNamed:@"mine_money"] forState:UIControlStateNormal];
    [self.goldButton setTitle:[NSString stringWithFormat:@"%ld",(long)self.rewardModel.rewardVO.rewardAmount] forState:UIControlStateNormal];
    [self.goldButton setTitleColor:HEX_COLOR(0xffffff) forState:UIControlStateNormal];
    self.goldButton.titleLabel.font = MOL_REGULAR_FONT(14);
    self.goldButton.layer.cornerRadius = 3;
    [self.headerView addSubview:self.goldButton];
    
    [self.goldButton sizeToFit];
    self.goldButton.layer.cornerRadius = 3;
    self.goldButton.clipsToBounds = YES;
    
    self.giftImageView = [[UIImageView alloc] init];
    
    self.giftImageView.backgroundColor = [UIColor clearColor];
    //    [self.giftImageView setImage: [UIImage imageNamed:@"00013"]];
    [self.giftImageView sd_setImageWithURL:[NSURL URLWithString:self.rewardModel.rewardVO.giftVO.giftThumb?self.rewardModel.rewardVO.giftVO.giftThumb:@""] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    // [self.giftImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.headerView addSubview:self.giftImageView];
    
    
    self.giftCountView = [[MOLGiftCountView alloc] init];
    self.giftCountView.beginNumber = self.rewardModel.rewardVO.giftVO.giftNum;
    [self.headerView addSubview:self.giftCountView];
    
    
    self.lineView =[UIView new];
    [self.lineView setBackgroundColor:HEX_COLOR_ALPHA(0xffffff, 0.2)];
    [self.headerView addSubview:self.lineView];
    
    
    
    
    self.contentLable =[OMGAttributedLabel new];
    [self.contentLable setBackgroundColor: [UIColor clearColor]];
    [self.contentLable setTextColor: HEX_COLOR_ALPHA(0xffffff, 0.6)];
    [self.contentLable setFont: MOL_REGULAR_FONT(14)];
    self.contentLable.delegate =self;
    [self.contentLable setNumberOfLines:0];
    [self.contentLable setPreferredMaxLayoutWidth:MOL_SCREEN_WIDTH - 15 - 15];
   // [self.contentLable setLineBreakMode:kCTLineBreakByCharWrapping];
    [self.headerView addSubview:self.contentLable];
    
    
    
    [self layoutUpdateHeaderLayer];
    
    
}

- (void)layoutUpdateHeaderLayer{
    __weak typeof(self) wself = self;
    
    [self.iconImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(60+MOL_StatusBarHeight);
        make.width.mas_equalTo(84);
        make.height.mas_equalTo(112);
    }];
    [self.iconImage.layer setMasksToBounds:YES];
    [self.iconImage.layer setCornerRadius:2];
    
    [self.playButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(wself.iconImage);
        make.width.mas_equalTo(30/2.0);
        make.height.mas_equalTo(36/2.0);
    }];
    
    [self.titleLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wself.iconImage.mas_right).offset(15);
        //make.right.mas_equalTo(wself.headerView);
        make.top.mas_equalTo(wself.iconImage.mas_top);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(23);
    }];
    
    [self.rewardTip mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wself.titleLable.mas_left);
        make.top.mas_equalTo(wself.titleLable.mas_bottom).offset(17);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(60);
    }];
    
    [self.goldButton sizeToFit];
    CGFloat goldWidth =self.goldButton.width+28;
    [self.goldButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wself.rewardTip.mas_right);
        make.top.mas_equalTo(wself.titleLable.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(goldWidth);
    }];
    
    [self.giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wself.titleLable.mas_left);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
        make.bottom.mas_equalTo(wself.iconImage.mas_bottom);
    }];
    
    [self.giftCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wself.giftImageView.mas_right);
        make.height.mas_equalTo(wself.giftImageView.mas_height);
        make.width.mas_equalTo(60);
        make.centerY.mas_equalTo(wself.giftImageView.mas_centerY);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself.iconImage.mas_bottom).offset(20);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(0.5);
    }];
    
    
    ///////////////////
    
    NSMutableAttributedString *desStr = [OMGAttributedLabel getJoinerAttributedStr:self.rewardModel.rewardVO];

    OMGAttributedLabelImageType imageType =OMGAttributedLabelImageType_Undefined;
    if (self.rewardModel.rewardVO.isJoiner) {//是合拍
        imageType = OMGAttributedLabelImageType_InTune;
    }
    
    [self.contentLable setTextContainer:[self.contentLable textContainerContents:self.rewardModel imageType:imageType]];
    //self.contentLable.attributedText =desStr;
    
    [self.contentLable.textContainer setLineBreakMode:kCTLineBreakByCharWrapping];
    
    CGFloat textH = [desStr mol_getAttributedTextHeightWithMaxWith:MOL_SCREEN_WIDTH - 15 - 15 font:MOL_REGULAR_FONT(14)];
    

    [self.contentLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(wself.lineView.mas_bottom).offset(15);
        make.height.mas_equalTo(textH);
    }];
    
    CGFloat headerH = 213+44+textH+15+30;
    //    if (headerH<360) {
    //        headerH =360;
    //    }
    
    _headerView.frame = CGRectMake(0,0, self.view.frame.size.width,headerH);
    self.bottomLView.y = _headerView.height - 1;
    [self.headerImage setFrame: CGRectMake(0, 0, self.headerView.width, self.headerView.height)];
    [self.pageMenu setFrame:CGRectMake(0, self.headerView.bottom-44, self.headerView.width,43)];
    [self.pageView reloadPage];
    
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    //blurEffectView.alpha =0.9;
    blurEffectView.frame = self.headerImage.bounds;
    [self.headerImage addSubview:blurEffectView];
    
    
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
    [self recommendEvent];
}


- (void)playButtonEvent:(UIButton *)sender{
    // NSLog(@"视频播放事件触发");
    [self recommendEvent];
    
}



- (void)layoutUI{
    
    [self.view addSubview:self.pageView];
    [self.view addSubview:self.headerView];
    [self.headerView addSubview:self.headerImage];
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:self.rewardModel.rewardVO.userVO.avatar?self.rewardModel.rewardVO.userVO.avatar:@""] placeholderImage:[UIImage imageNamed:@"屏幕快照 2018-09-12 下午3.28.04"] options:SDWebImageRetryFailed];
    
    [self.headerView addSubview:self.pageMenu];
    
    
    [self layoutHeaderView];
    
    self.publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (self.rewardModel.rewardVO.isJoiner) {
        [self.publishButton setImage:[UIImage imageNamed:@"with_pat1"] forState:UIControlStateNormal];
    }else{
        [self.publishButton setImage:[UIImage imageNamed:@"with_pat"] forState:UIControlStateNormal];
    }
    
    [self.publishButton addTarget:self action:@selector(button_clickPublishButton) forControlEvents:UIControlEventTouchUpInside];
    [self.publishButton sizeToFit];
    self.publishButton.centerX = self.view.width * 0.5;
    self.publishButton.bottom = self.view.height - 30;
    [self.view addSubview:self.publishButton];
    
    MOLUserModel *user = [MOLUserManagerInstance user_getUserInfo];
    if ([user.userId isEqualToString:self.rewardModel.rewardVO.userVO.userId]) {
        self.publishButton.hidden = YES;
    }
    
}

- (JAHorizontalPageView *)pageView{
    if (!_pageView) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        _pageView = [[JAHorizontalPageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) delegate:self];
        _pageView.horizontalCollectionView.scrollEnabled = NO;
        _pageView.needHeadGestures = YES;
        _pageView.needMiddleRefresh = YES;
        
    }
    return _pageView;
}



#pragma mark-
#pragma mark
#pragma mark - delegate
- (NSInteger)numberOfSectionPageView:(JAHorizontalPageView *)view   // 返回几个控制器
{
    return 2;
}
- (UIScrollView *)horizontalPageView:(JAHorizontalPageView *)pageView viewAtIndex:(NSInteger)index   // 返回每个控制器的view
{
    if (index == 1) {
        AwardListViewController *vc =[[AwardListViewController alloc] init];
        vc.rewardModel =self.rewardModel;
        vc.view.backgroundColor = [UIColor clearColor];
        [self addChildViewController:vc];
        return (UIScrollView *)vc.tableView;
        
    }else {
        ParticipatingWorksController *vc =[[ParticipatingWorksController alloc] init];
        vc.rewardModel =self.rewardModel;
        vc.view.backgroundColor = [UIColor clearColor];
        [self addChildViewController:vc];
        return (UIScrollView *)vc.collectionView;
    }
}

- (UIView *)headerViewInPageView:(JAHorizontalPageView *)pageView     // 返回头部
{
    return self.headerView;
}

- (CGFloat)headerHeightInPageView:(JAHorizontalPageView *)pageView    // 返回头部高度
{
    return self.headerView.height;
}

- (CGFloat)topHeightInPageView:(JAHorizontalPageView *)pageView   // 控制在什么地方悬停
{
    return 43 + MOL_StatusBarAndNavigationBarHeight;
}

- (void)horizontalPageView:(JAHorizontalPageView *)pageView scrollTopOffset:(CGFloat)offset   // 滚动的偏移量
{
    //self.headerView.alpha = 1 - offset/ (self.headerView.height - (43 + MOL_StatusBarAndNavigationBarHeight));
    
    //self.de.alpha = offset/ (self.headView.height - (43 + MOL_StatusBarAndNavigationBarHeight));
    //self.infoHeadView.alpha = 1 - offset/ (self.headView.height - (43 + MOL_StatusBarAndNavigationBarHeight));
    
    //NSLog(@"%lf---%lf---%lf",offset,offset/ (self.headerView.height - (43 + MOL_StatusBarAndNavigationBarHeight)),(self.headerView.height - (43 + MOL_StatusBarAndNavigationBarHeight)));
    
    CGFloat lineBotH = 43 + MOL_StatusBarAndNavigationBarHeight;
    CGFloat lineTopH = self.headerView.height - lineBotH;
    
    
    CGFloat alpha = 1- (offset + MOL_StatusBarAndNavigationBarHeight)/lineTopH;
    if (alpha < 0) {
        alpha = 0.0;
    }
    
    self.contentLable.alpha =alpha;
    self.lineView.alpha =alpha;
    
//    self.contentLable.alpha = 1- offset/lineTopH;
//    self.lineView.alpha = 1 - offset /lineTopH;
    
    
    self.iconImage.alpha = 1-offset/lineTopH;
    self.playButton.alpha = 1-offset/lineTopH;
    self.titleLable.alpha = 1-offset/lineTopH;
    self.rewardTip.alpha = 1-offset/lineTopH;
    self.goldButton.alpha = 1-offset/lineTopH;
    self.giftImageView.alpha = 1-offset/lineTopH;
    self.giftCountView.alpha = 1-offset/lineTopH;
    
    
    
    CGFloat dis = offset - (lineTopH - MOL_StatusBarAndNavigationBarHeight);
    
    if (dis > 0) {
        CGFloat alpha = dis / MOL_StatusBarAndNavigationBarHeight;
        //用户名称
        [self basevc_setCenterTitle:self.rewardModel.rewardVO.userVO.userName titleColor:HEX_COLOR_ALPHA(0xffffff, alpha)];
    }else{
        //用户名称
        [self basevc_setCenterTitle:self.rewardModel.rewardVO.userVO.userName titleColor:HEX_COLOR_ALPHA(0xffffff, 0)];
    }
    
    

}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    [self.pageView scrollToIndex:toIndex];
    if (toIndex == 0) {
        MOLUserModel *user = [MOLUserManagerInstance user_getUserInfo];
        if ([user.userId isEqualToString:self.rewardModel.rewardVO.userVO.userId]) {
            self.publishButton.hidden = YES;
        }else{        
            self.publishButton.hidden = NO;
        }
    }else{
        self.publishButton.hidden = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAwardListViewController" object:nil];
    }
}



- (void)getNetworkData{
    
}

- (void)rightButtonEvent:(UIBarButtonItem *)sender{
    // NSLog(@"分享控件实现");
    [self.view addSubview:self.shareView];
    
}

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
    NSString* thumbURL =  self.rewardModel.rewardVO.shareMsgVO.shareImg?self.rewardModel.rewardVO.shareMsgVO.shareImg:@"";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.rewardModel.rewardVO.shareMsgVO.shareTitle?self.rewardModel.rewardVO.shareMsgVO.shareTitle:@"" descr:self.rewardModel.rewardVO.shareMsgVO.shareContent?self.rewardModel.rewardVO.shareMsgVO.shareContent:@"" thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = self.rewardModel.rewardVO.shareMsgVO.shareUrl?self.rewardModel.rewardVO.shareMsgVO.shareUrl:@"";
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
            
            // 统计-分享
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"operateType"] = @"2";
            dic[@"recordType"] = @(self.rewardModel.contentType);
            if (self.rewardModel.contentType == 1) {
                dic[@"typeId"] = self.rewardModel.rewardVO.rewardId;
            }else{
                dic[@"typeId"] = [NSString stringWithFormat:@"%ld",self.rewardModel.storyVO.storyId];
            }
            [MOLStatistics statistics_share:dic];
        }
    }];
}


- (void)button_clickPublishButton
{
    if (![MOLUserManagerInstance user_isLogin]) {
        [[MOLGlobalManager shareGlobalManager] global_modalLogin];
        return;
    }
    
    
//    if (self.rewardModel.rewardVO.isPublish) {
//        [MBProgressHUD showMessageAMoment:@"你已经参与过了"];
//        return;
//    }
    
    BOOL redpacketFinish = self.rewardModel.rewardVO.remainSize == 0 ?YES:NO;
    
    BOOL rewardFinish = self.rewardModel.rewardVO.isFinish;
    
    NSString *title = nil;
    if (redpacketFinish) {
        title = @"悬赏红包已发完，是否继续参与？";
    }
    
    if (rewardFinish) {
        title = @"当前悬赏已经结束是否继续参与？";
    }
    
    if (title.length) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (self.rewardModel.rewardVO.isJoiner) {
                [[MOLRecordManager manager] loadMaterialResourcesWith:[NSURL URLWithString:self.rewardModel.rewardVO.audioUrl?self.rewardModel.rewardVO.audioUrl:@""] WithRewardID:self.rewardModel.rewardVO.rewardId.integerValue];
            }else{
                MOLRecordViewController *vc = [[MOLRecordViewController alloc] init];
                [MOLReleaseManager manager].rewardID = self.rewardModel.rewardVO.rewardId.integerValue;
                [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
            }
            
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:okAction];
        [alertController addAction:cancleAction];
        
        UIViewController *vc = [CommUtls topViewController];
        [vc presentViewController:alertController animated:YES completion:nil];
        
    }else{
        
        if (self.rewardModel.rewardVO.isJoiner) {
            [[MOLRecordManager manager] loadMaterialResourcesWith:[NSURL URLWithString:self.rewardModel.rewardVO.audioUrl?self.rewardModel.rewardVO.audioUrl:@""] WithRewardID:self.rewardModel.rewardVO.rewardId.integerValue];
        }else{
            MOLRecordViewController *vc = [[MOLRecordViewController alloc] init];
            [MOLReleaseManager manager].rewardID = self.rewardModel.rewardVO.rewardId.integerValue;
            [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
        }
        
    }
    
    
}

#pragma mark-
#pragma mark

- (void)getRewardDetailNetworkData{
    __weak typeof(self) wself = self;
    NSString *parameterId =@"";
    if (!self.rewardModel) { //表示只有悬赏id
        parameterId =self.rewardId?self.rewardId:@"";
    }else{
        parameterId =self.rewardModel.rewardVO.rewardId?self.rewardModel.rewardVO.rewardId:@"";
    }
    
    [[[RewardRequest alloc] initRequest_RewardDetailParameter:@{} parameterId:parameterId] baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        if (code == MOL_SUCCESS_REQUEST) {
            // 解析数据
            MOLVideoOutsideModel *modelD =(MOLVideoOutsideModel *)responseModel;
            wself.rewardModel =modelD;
            [wself initUI];
        }
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        
    }];
}

///用户事件触发
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

- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)textStorage atPoint:(CGPoint)point{
    if ([textStorage isKindOfClass:[TYLinkTextStorage class]])
    {
        ContentsItemModel *model = ((TYLinkTextStorage*)textStorage).linkData;
        if (model && [model isKindOfClass: [ContentsItemModel class]] && model.type == 2) {
            MOLUserModel *userVO =[MOLUserModel new];
            userVO.userId = [NSString stringWithFormat:@"%ld",model.typeId];
            
            if ([[MOLGlobalManager shareGlobalManager] isUserself:userVO]) {
                MOLMineViewController *vc = [[MOLMineViewController alloc] init];
                [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
            }else{
                MOLOtherUserViewController *vc = [[MOLOtherUserViewController alloc] init];
                vc.userId = [NSString stringWithFormat:@"%@",userVO.userId?userVO.userId:@""];
                [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
            }
        }
    }
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
