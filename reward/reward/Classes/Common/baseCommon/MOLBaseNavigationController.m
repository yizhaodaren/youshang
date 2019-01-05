//
//  MOLBaseNavigationController.m
//  reward
//
//  Created by moli-2017 on 2018/9/11.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseNavigationController.h"

@interface MOLBaseNavigationController ()

@end

@implementation MOLBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setTranslucent:true];
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}
@end
