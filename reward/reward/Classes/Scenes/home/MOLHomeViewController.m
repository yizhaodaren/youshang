//
//  MOLHomeViewController.m
//  reward
//
//  Created by moli-2017 on 2018/9/11.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLHomeViewController.h"
#import "AttentionViewController.h"
#import "RecommendViewController.h"
#import "HoursViewController.h"
#import "SearchViewController.h"
#import "MOLLoginViewController.h"
#import "MOLPrivacyView.h"


static const CGFloat KNavToolHeight = 20;
static const CGFloat KNavbarHeight  = 44;
static const CGFloat KTabbarHeight  = 49;
static const CGFloat KMenuItemWidth = 62;

@interface MOLHomeViewController ()
@property(nonatomic,strong)NSArray *titleArr;

@property(nonatomic,strong)AttentionViewController *attention;
@property(nonatomic,strong)RecommendViewController *recommend;


@end

@implementation MOLHomeViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MOL_SUCCESS_PUBLISHED object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self layoutNavigation];
    // 监听登录成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successPublished) name:MOL_SUCCESS_PUBLISHED object:nil];
    self.selectIndex = 1;
   
    // 监听首页刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeRefrsh) name:MOL_HOME_REFRESH object:nil];
    
}
-(void)homeRefrsh{
    if (self.selectIndex == 0) {
        [self.attention refreshHome];
    }else{
        [self.recommend refreshHome];
    }
}

- (void)initData{
    
    self.titleArr =@[@"关注",@"推荐"];
    [self reloadData];
}
-(void)successPublished{
    self.tabBarController.selectedIndex = 0;
    self.selectIndex=0;
}

- (void)layoutNavigation{
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *topBackShadow=[UIImageView new];
    [topBackShadow setImage: [UIImage imageNamed:@"top_shadow"]];
    [topBackShadow setFrame:CGRectMake(0,0, MOL_SCREEN_WIDTH, 130/2.0)];
    [self.view addSubview:topBackShadow];
    
    self.showNavigation = NO;
    //创建一个left UIButton
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, KTabbarHeight)];
    //设置UIButton的图像
    [leftButton setImage:[UIImage imageNamed:@"video_24hours"] forState:UIControlStateNormal];
    //给UIButton绑定一个方法，在这个方法中进行popViewControllerAnimated
    [leftButton addTarget:self action:@selector(leftButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    //然后通过系统给的自定义BarButtonItem的方法创建BarButtonItem
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    //覆盖返回按键
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    //创建一个right UIButton
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,0,KNavbarHeight)];
    //设置UIButton的图像
    [rightButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    //给UIButton绑定一个方法，在这个方法中进行popViewControllerAnimated
    [rightButton addTarget:self action:@selector(rightButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    //然后通过系统给的自定义BarButtonItem的方法创建BarButtonItem
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    //覆盖返回按键
    self.navigationItem.rightBarButtonItem = rightBarButton;
}
#pragma mark-
#pragma mark 导航响应事件
- (void)leftButtonEvent:(UIButton *)sender{
    
    [self.navigationController pushViewController:HoursViewController.new animated:YES];
}

- (void)rightButtonEvent:(UIButton *)sender{
    [self.navigationController pushViewController:SearchViewController.new animated:YES];
}

#pragma mark -
#pragma mark WMPageController 初始化代码
- (instancetype)init {
    if (self = [super init]) {
        self.menuViewStyle = WMMenuViewStyleDefault;
        self.showOnNavigationBar = YES;
        self.titleColorSelected = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        self.titleColorNormal = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.titleFontName =@"PingFangSC-Medium";
        self.titleSizeSelected = 19;
        self.titleSizeNormal = 16;
        
        //self.progressWidth = 50;
        // self.progressHeight = 2 ;
//        if (![MOLUserManagerInstance user_isLogin]) {
//            self.selectIndex =0;
//        }else{
         self.selectIndex = 0;
//        }
        
        self.menuItemWidth = KMenuItemWidth;
        self.scrollEnable =NO;
        //仿腾讯激萌效果
        self.progressViewIsNaughty = YES;

    }
    return self;
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    // 获取隐私政策
    [MOLPrivacyView privacy_show];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [UIView animateWithDuration:0.3 animations:^{
        UIView *statusBar = [[UIApplication sharedApplication] valueForKey:@"statusBar"];
        statusBar.alpha = 0.0;
        self.navigationController.navigationBar.frame = CGRectMake(0, MOL_StatusBarHeight - 10, MOL_SCREEN_WIDTH, MOL_NavigationBarHeight);
    }];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
    self.navigationController.navigationBar.frame = CGRectMake(0, MOL_StatusBarHeight, MOL_SCREEN_WIDTH, MOL_NavigationBarHeight);
    UIView *statusBar = [[UIApplication sharedApplication] valueForKey:@"statusBar"];
    statusBar.alpha = 1.0;
}


- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
//    if (![MOLUserManagerInstance user_isLogin]) {
//        return 1;
//    }
    return self.titleArr.count;
}




- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
//    if (![MOLUserManagerInstance user_isLogin]) {
//        return @"推荐";
//    }
    return self.titleArr[index];
}


- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
//    if (![MOLUserManagerInstance user_isLogin]) {
//        RecommendViewController *recommend =[RecommendViewController new];
//        [recommend onUIApplication:YES];
//        PLMediaInfo *info = [[PLMediaInfo alloc] init];
//        info.businessType =HomePageBusinessType_HomePageRecommend;
//        info.pageNum =1;
//        info.pageSize =MOL_REQUEST_COUNT_VEDIO;
//        recommend.mediaDto = info;
//        return recommend;
//    }else{
        switch (index) {
            case 0://关注
            {
                self.attention =[[AttentionViewController alloc] init];
                return self.attention;
            }
                
                break;
            case 1://推荐
            {
               
                self.recommend =[RecommendViewController new];
                [self.recommend onUIApplication:YES];
                PLMediaInfo *info = [[PLMediaInfo alloc] init];
                info.businessType =HomePageBusinessType_HomePageRecommend;
                info.pageNum =1;
                info.pageSize =MOL_REQUEST_COUNT_VEDIO;
                self.recommend.mediaDto = info;
                return self.recommend;
            }
                break;
                
            default:
            {
                return RecommendViewController.new;
            }
                break;
        }
//    }

}


- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    return width;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    CGFloat originY   = 0;
    return CGRectMake( 0, originY, MOL_SCREEN_WIDTH, KNavbarHeight);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    
   // CGFloat originY   = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    
    return CGRectMake(0,0  ,MOL_SCREEN_WIDTH, MOL_SCREEN_HEIGHT);
}



- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info
{
//    NSInteger index = [[info objectForKey:@"index"]integerValue];
//    if (index == 0) {//关注
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"jcUpdateSelectDynamicData" object:nil];
//    }
//    else if (index == 1){//推荐
//
//        //点击了关注动态数据
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"jcUpdateFocusDynamicData" object:nil];
//        
//    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
