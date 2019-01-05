//
//  MOLBaseViewController.m
//  reward
//
//  Created by moli-2017 on 2018/9/11.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseViewController.h"
#import "MOLMineViewController.h"
#import "MOLMessageViewController.h"
#import "MOLHomeViewController.h"
#import "MOLDiscoverViewController.h"
#import "PLShortPlayerViewController.h"
#import "RecommendViewController.h"

@interface MOLBaseViewController ()<UINavigationControllerDelegate>

@property (nonatomic, weak) UIImageView *imageView;

// loading动画
@property (nonatomic, weak) UIImageView *loadingImageView;
// 网络请求失败view
@property (nonatomic, weak) UIImageView *errorImageView;
// 空白页面view
@property (nonatomic, weak) UIImageView *blankImageView;
@end

@implementation MOLBaseViewController

- (BOOL)showNavigation
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEX_COLOR(0x161824);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.delegate = self;
    
    [self base_setNavigationBar];
}

#pragma mark - 导航条
- (void)base_setNavigationBar
{
    if (self.navigationController.childViewControllers.count > 1) {
        [self basevc_setNavLeftItemWithTitle:nil titleColor:nil];
    }
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }else{
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    BOOL isHidden = NO;
    if (self.showNavigation) {
        isHidden = NO;
    }else{
        isHidden = YES;
    }
    [self.navigationController setNavigationBarHidden:isHidden animated:YES];
}

- (void)basevc_setNavLeftItemWithTitle:(NSString *)title titleColor:(UIColor *)color
{
    if (title.length) {
        UIBarButtonItem *backItem = [UIBarButtonItem mol_barButtonItemWithTitleName:title targat:self action:@selector(leftBackAction)];
        backItem.tintColor = color;
        self.navigationItem.leftBarButtonItem = backItem;
    }else{
        
        UIBarButtonItem *backItem = [UIBarButtonItem mol_barButtonItemWithImageName:@"navigation_back" highlightImageName:@"navigation_back" targat:self action:@selector(leftBackAction)];
        self.navigationItem.leftBarButtonItem = backItem;
    }
}

- (void)basevc_setCenterTitle:(NSString *)title titleColor:(UIColor *)color
{
    self.navigationItem.title = title;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:MOL_REGULAR_FONT(17)}];
    
}

- (void)leftBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

// 隐藏导航栏
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    MOLBaseViewController *v = (MOLBaseViewController *)viewController;
    BOOL isHidden = NO;
    if (v.showNavigation) {
        isHidden = NO;
    }else{
        isHidden = YES;
    }
    [viewController.navigationController setNavigationBarHidden:isHidden animated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

#pragma mark - tabBar
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self isKindOfClass:[RecommendViewController class]] ||
        [self isKindOfClass:[PLShortPlayerViewController class]]) {
        self.tabBarController.tabBar.backgroundImage = [self getImage:[UIColor clearColor] alpha:1];
        self.tabBarController.tabBar.translucent = YES;
        [self.tabBarController.tabBar setShadowImage:[self getImage:HEX_COLOR(0xffffff) alpha:0.2]];
    }else{
        self.tabBarController.tabBar.backgroundImage = [self getImage:HEX_COLOR(0x0E0F1A) alpha:1];
        self.tabBarController.tabBar.translucent = NO;
        [self.tabBarController.tabBar setShadowImage:[self getImage:[UIColor clearColor] alpha:1]];
    }
    
    if (self.showNavigationLine) {
        [self.navigationController.navigationBar setShadowImage:[self getImage:HEX_COLOR(0xededed) alpha:0.2]];
    }else{
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }
    
}

#pragma mark - 导航条的线
- (UIImage *)getImage:(UIColor *)color alpha:(CGFloat)alpha
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextSetAlpha(context, alpha);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark - 网络请求loading
// 显示loading
- (void)basevc_showLoading
{
    [self.blankImageView removeFromSuperview];
    [self.errorImageView removeFromSuperview];
    [self.loadingImageView.layer removeAllAnimations];
    [self.loadingImageView removeFromSuperview];
    
    UIImageView *loadingImageView = [[UIImageView alloc] init];
    _loadingImageView = loadingImageView;
    loadingImageView.width = 18;
    loadingImageView.height = 18;
    loadingImageView.centerX = self.view.width * 0.5;
    loadingImageView.centerY = self.view.height * 0.5;
    loadingImageView.image = [UIImage imageNamed:@"mine_loading"];
    loadingImageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:loadingImageView];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue = [NSNumber numberWithFloat: M_PI *2];
    animation.duration = 1;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [loadingImageView.layer addAnimation:animation forKey:nil];
}
// 隐藏loading
- (void)basevc_hiddenLoading
{
    [self.loadingImageView removeFromSuperview];
}

// 隐藏失败
- (void)basevc_hiddenErrorView
{
    [self.loadingImageView.layer removeAllAnimations];
    [self.loadingImageView removeFromSuperview];
    [self.blankImageView removeFromSuperview];
    [self.errorImageView removeFromSuperview];
}
// 展示空白页
- (void)basevc_showBlankPageWithY:(CGFloat)localY image:(NSString *)image title:(NSString *)title superView:(UIView *)view
{
    [self.blankImageView removeFromSuperview];
    
    UIImageView *blankView = [[UIImageView alloc] init];
    _blankImageView = blankView;
    blankView.userInteractionEnabled = YES;
    //    blankView.image = [UIImage imageNamed:@"home_backImage"];
    blankView.y = localY < 0 ? 0 : localY;
    blankView.width = view.width;
    blankView.height = view.height - fabs(localY);
    [view addSubview:blankView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:HEX_COLOR_ALPHA(0xffffff, 0.3) forState:UIControlStateNormal];
    if (image.length) {    
        [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    btn.width = blankView.width;
    btn.height = 250;
//    btn.y = blankView.height - btn.height;
    btn.centerY = blankView.height * 0.5;
    btn.titleLabel.lineBreakMode = 0;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn mol_setButtonImageTitleStyle:ButtonImageTitleStyleBottom padding:20];
    [blankView addSubview:btn];
}
// 网络请求失败
- (void)basevc_showErrorPageWithY:(CGFloat)localY select:(SEL)select superView:(UIView *)view
{
    [self.errorImageView removeFromSuperview];
    UIImageView *errorView = [[UIImageView alloc] init];
    _errorImageView = errorView;
    errorView.userInteractionEnabled = YES;
    //    errorView.image = [UIImage imageNamed:@"home_backImage"];
    errorView.y = localY;
    errorView.width = view.width;
    errorView.height = view.height - localY;
    [view addSubview:errorView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"点击刷新" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"mine_refresh_faile"] forState:UIControlStateNormal];
    if (select) {
        [btn addTarget:self action:select forControlEvents:UIControlEventTouchUpInside];
    }
    btn.titleLabel.font = MOL_REGULAR_FONT(10);
    [btn setTitleColor:HEX_COLOR_ALPHA(0xffffff, 0.7) forState:UIControlStateNormal];
    btn.width = 100;
    btn.height = 50;
    btn.centerX = errorView.width * 0.5;
    btn.centerY = errorView.height * 0.5;
    [btn mol_setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:10];
    [errorView addSubview:btn];
}
@end
