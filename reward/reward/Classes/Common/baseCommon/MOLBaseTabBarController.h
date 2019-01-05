//
//  MOLBaseTabBarController.h
//  reward
//
//  Created by moli-2017 on 2018/9/11.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOLBaseTabBarController : UITabBarController
//加载动画
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIButton *refreshImageView;
@property (nonatomic,strong)UIView  *alpView;
@end
