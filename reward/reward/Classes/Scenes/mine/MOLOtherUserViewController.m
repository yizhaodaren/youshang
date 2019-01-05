//
//  MOLOtherUserViewController.m
//  reward
//
//  Created by moli-2017 on 2018/9/15.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLOtherUserViewController.h"
#import "MOLUserCenterViewModel.h"
#import "MOLMineHeadView.h"
#import "MOLMyProductionViewController.h"
#import "MOLMyRewarViewController.h"

#import "MOLAccountViewModel.h"
#import "MOLActionRequest.h"

@interface MOLOtherUserViewController ()<JAHorizontalPageViewDelegate, SPPageMenuDelegate>
@property (nonatomic, strong) MOLUserCenterViewModel *userViewModel;
@property (nonatomic, strong) MOLAccountViewModel *userInfoViewModel;

@property (nonatomic, strong) JAHorizontalPageView *pageView;

@property (nonatomic, strong) MOLMineHeadView *infoHeadView;
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *headView;

@property (nonatomic, weak) MOLMyProductionViewController *productionVc;
@property (nonatomic, weak) MOLMyRewarViewController *rewardVc;

@property (nonatomic, strong) NSString *titleName;


@property(nonatomic, strong) UIButton  *waringBtn;
@end

@implementation MOLOtherUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userViewModel = [[MOLUserCenterViewModel alloc] init];
    self.userInfoViewModel = [[MOLAccountViewModel alloc] init];
    
    [self setNavigationBar];
    [self setupOtherUserViewControllerUI];
    [self bindingViewModel];
    
    [self.pageView reloadPage];
    
//    if ([MOLSwitchManager shareSwitchManager].normalStatus == 1) {
        [self.pageMenu setItems:@[@"作品0",@"悬赏0"] selectedItemIndex:0];
//    }else{
//        [self.pageMenu setItems:@[@"作品0"] selectedItemIndex:0];
//    }
    
    self.pageMenu.bridgeScrollView = (UIScrollView *)_pageView.horizontalCollectionView;
    
    [self request_userInfo];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

#pragma mark - 网络请求
- (void)request_userInfo
{
    NSString *paraId = self.userId;
    [self.userInfoViewModel.userInfoCommand execute:paraId];
}

#pragma mark - bindingViewModel
- (void)bindingViewModel
{
    @weakify(self);
    [self.userInfoViewModel.userInfoCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        
        MOLUserModel *model = (MOLUserModel *)x;
        self.titleName = model.userName;
        
        CGFloat nameH = [model.userName mol_getTextHeightWithMaxWith:MOL_SCREEN_WIDTH - 36 font:MOL_MEDIUM_FONT(22)];
        
        self.infoHeadView.height = 340 + nameH + [model.signInfo mol_getTextHeightWithMaxWith:MOL_SCREEN_WIDTH - 36 font:MOL_LIGHT_FONT(12)];
        self.infoHeadView.userModel = model;
  

        
        [self.infoHeadView layout];
        self.pageMenu.y = self.infoHeadView.bottom;
        self.headView.height = (self.infoHeadView.height) + (self.pageMenu.height) + 1;
        self.backImageView.frame = self.headView.bounds;
        self.backView.frame = self.backImageView.bounds;
        self.lineView.y = self.headView.height - 1;
        [self.backImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
        [self.pageMenu removeAllItems];
        
//        if ([MOLSwitchManager shareSwitchManager].normalStatus == 1) {
            NSString *name1 = [NSString stringWithFormat:@"作品%ld",model.storyCount];
            NSString *name2 = [NSString stringWithFormat:@"悬赏%ld",model.rewardCount];
            [self.pageMenu setItems:@[name1,name2] selectedItemIndex:0];
            
//        }else{
//            NSString *name1 = [NSString stringWithFormat:@"作品%ld",model.storyCount];
//
//            [self.pageMenu setItems:@[name1] selectedItemIndex:0];
//
//        }
        
        [self.pageView reloadPage];
        self.infoHeadView.alpha = 1;
        
    }];
}

#pragma mark - 按钮点击
- (void)button_clickRightItem
{
    if (![MOLUserManagerInstance user_isLogin]) {
        [[MOLGlobalManager shareGlobalManager] global_modalLogin];
        return;
    }
    
    NSArray *titleButtons = @[@"举报",@"拉黑"];
    @weakify(self);
    LCActionSheet *actionS = [[LCActionSheet alloc] initWithTitle:nil buttonTitles:titleButtons redButtonIndex:-1 completion:^(NSInteger buttonIndex, LCActionSheet *actionSheet) {
        @strongify(self);
        if (buttonIndex >= titleButtons.count) {
            return;
        }
        NSString *title = titleButtons[buttonIndex];
        if ([title isEqualToString:@"举报"]) {
            
            // 举报原因
            [self report];
            
        }else if ([title isEqualToString:@"拉黑"]){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"你确定将ta拉进黑名单吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                MOLActionRequest *r = [[MOLActionRequest alloc] initRequest_blackUserActionWithParameter:nil parameterId:self.userId];
                [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
                    if (code == MOL_SUCCESS_REQUEST) {
                        [MBProgressHUD showMessageAMoment:@"拉黑成功"];
                    }else{
                        [MBProgressHUD showMessageAMoment:message];
                    }
                } failure:^(__kindof MOLBaseNetRequest *request) {
                    
                }];
            }];
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:okAction];
            [alertController addAction:cancleAction];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:alertController animated:YES completion:nil];
            });
        }
    }];
    [actionS show];
}

- (void)report
{
    NSArray *titleArray = @[
                     @"盗用他人作品",
                     @"侮辱谩骂",
                     @"头像、昵称、签名违规",
                     @"其他违规",
                     ];
    @weakify(self);
    LCActionSheet *actionS = [[LCActionSheet alloc] initWithTitle:@"选择举报原因" buttonTitles:titleArray redButtonIndex:-1 completion:^(NSInteger buttonIndex, LCActionSheet *actionSheet) {
        @strongify(self);
        if (buttonIndex >= titleArray.count) {
            return;
        }
        
        NSString *str = titleArray[buttonIndex];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"cause"] = str;
        dic[@"reportType"] = @"4";
        dic[@"typeId"] = self.userId;
        MOLActionRequest *r = [[MOLActionRequest alloc] initRequest_reportUserActionWithParameter:dic];
        [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
            if (code == MOL_SUCCESS_REQUEST) {
                [MBProgressHUD showMessageAMoment:@"举报成功"];
            }else{
                [MBProgressHUD showMessageAMoment:message];
            }
        } failure:^(__kindof MOLBaseNetRequest *request) {
            
        }];
        
    }];
    
    [actionS show];
}

#pragma mark - delegate
- (NSInteger)numberOfSectionPageView:(JAHorizontalPageView *)view   // 返回几个控制器
{
//    if ([MOLSwitchManager shareSwitchManager].normalStatus == 1) {
        return 2;
//    }else{
//        return 1;
//    }
}

- (UIScrollView *)horizontalPageView:(JAHorizontalPageView *)pageView viewAtIndex:(NSInteger)index   // 返回每个控制器的view
{
    
//    if ([MOLSwitchManager shareSwitchManager].normalStatus == 1) {
        if (index == 0) {
            MOLMyProductionViewController *vc = [[MOLMyProductionViewController alloc] init];
            _productionVc = vc;
            vc.showNav = YES;
            vc.userId = self.userId;
            vc.view.backgroundColor = [UIColor clearColor];
            [self addChildViewController:vc];
            return (UIScrollView *)vc.collectionView;
        }else{
            MOLMyRewarViewController *vc = [[MOLMyRewarViewController alloc] init];
            _rewardVc = vc;
            vc.showNav = YES;
            vc.isOwner = NO;
            vc.userId = self.userId;
            vc.view.backgroundColor = [UIColor clearColor];
            [self addChildViewController:vc];
            return (UIScrollView *)vc.tableView;
        }
//    }else{
//        MOLMyProductionViewController *vc = [[MOLMyProductionViewController alloc] init];
//        _productionVc = vc;
//        vc.showNav = YES;
//        vc.userId = self.userId;
//        vc.view.backgroundColor = [UIColor clearColor];
//        [self addChildViewController:vc];
//        return (UIScrollView *)vc.collectionView;
//    }
    
}

- (UIView *)headerViewInPageView:(JAHorizontalPageView *)pageView     // 返回头部
{
    return self.headView;
}

- (CGFloat)headerHeightInPageView:(JAHorizontalPageView *)pageView    // 返回头部高度
{
    return self.headView.height;
}

- (CGFloat)topHeightInPageView:(JAHorizontalPageView *)pageView   // 控制在什么地方悬停
{
    return 43 + MOL_StatusBarAndNavigationBarHeight;
}

- (void)horizontalPageView:(JAHorizontalPageView *)pageView scrollTopOffset:(CGFloat)offset   // 滚动的偏移量
{
    if (offset < 0) {
        self.backImageView.y = offset;
        self.backImageView.height = self.headView.height - offset;
    }else{
        self.backImageView.y = 0;
        self.backImageView.height = self.headView.height;
    }
    self.backView.frame = self.backImageView.bounds;
    self.infoHeadView.alpha = 1 - offset/ (self.headView.height - (43 + MOL_StatusBarAndNavigationBarHeight));
    
    if (self.infoHeadView.alpha<=0.3) {
        
        [self basevc_setCenterTitle:self.titleName titleColor:HEX_COLOR(0xffffff)];
    }else{
        
        [self basevc_setCenterTitle:nil titleColor:HEX_COLOR(0xffffff)];
    }
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    [_pageView scrollToIndex:toIndex];
}

#pragma mark - 导航条
- (void)setNavigationBar
{
    UIBarButtonItem *rightItem = [UIBarButtonItem mol_barButtonItemWithImageName:@"mine_other_point" highlightImageName:@"mine_other_point" targat:self action:@selector(button_clickRightItem)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - UI
- (void)setupOtherUserViewControllerUI
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    _pageView = [[JAHorizontalPageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) delegate:self];
    _pageView.horizontalCollectionView.scrollEnabled = NO;
    _pageView.needHeadGestures = YES;
    [self.view addSubview:_pageView];
}

- (void)calculatorOtherUserViewControllerFrame{}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self calculatorOtherUserViewControllerFrame];
}

#pragma mark - 懒加载
- (UIView *)headView
{
    if (_headView == nil) {
        
        _headView = [[UIView alloc] init];
        
        UIImageView *backImageView = [[UIImageView alloc] init];
        _backImageView = backImageView;
        _backImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backImageView.clipsToBounds = YES;
        [_headView addSubview:backImageView];
        
//        UIView *backView = [[UIView alloc] init];
//        _backView = backView;
//        backView.backgroundColor = HEX_COLOR_ALPHA(0x0F101C, 0.9);
//        [_backImageView addSubview:backView];
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _backView = effectView;
        [backImageView addSubview:effectView];
        
        _infoHeadView = [[MOLMineHeadView alloc] init];
        _infoHeadView.width = MOL_SCREEN_WIDTH;
        _infoHeadView.height = 390;
        [_headView addSubview:_infoHeadView];
        
        SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, _infoHeadView.bottom, MOL_SCREEN_WIDTH, 43) trackerStyle:SPPageMenuTrackerStyleLine];
        _pageMenu = pageMenu;
        _pageMenu.backgroundColor = [UIColor clearColor];//HEX_COLOR(0x0E0F1A);
        _pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
        _pageMenu.itemTitleFont = MOL_MEDIUM_FONT(16);
        _pageMenu.selectedItemTitleColor = HEX_COLOR(0xffffff);
        _pageMenu.unSelectedItemTitleColor = HEX_COLOR_ALPHA(0xffffff, 0.6);
        [_pageMenu setTrackerHeight:3 cornerRadius:0];
        _pageMenu.tracker.backgroundColor = HEX_COLOR(0xFFEC00);
        _pageMenu.needTextColorGradients = NO;
        _pageMenu.dividingLine.hidden = YES;
        _pageMenu.itemPadding = 20;
        _pageMenu.delegate = self;
        [_headView addSubview:_pageMenu];
        
        _headView.width = MOL_SCREEN_WIDTH;
        _headView.height =(_infoHeadView.height) + (_pageMenu.height) + 1;
        
        _backImageView.frame = _headView.bounds;
        _backView.frame = _backImageView.bounds;
        
        UIView *line = [[UIView alloc] init];
        _lineView = line;
        line.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.1);
        line.width = MOL_SCREEN_WIDTH;
        line.height = 1;
        line.y = _headView.height - 1;
        [_headView addSubview:line];
    }
    
    return _headView;
}

@end
