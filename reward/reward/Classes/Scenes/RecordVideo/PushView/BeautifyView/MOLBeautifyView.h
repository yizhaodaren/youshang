//
//  MOLBeautifyView.h
//  reward
//
//  Created by apple on 2018/9/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PLShortVideoKit/PLShortVideoKit.h>
#import "MOLBasePushView.h"
typedef NS_ENUM(NSInteger, MolBeautifyType) {
    /**
     @brief 滤镜
     */
    MolBeautifyfiletType = 0,
    
    /**
     @brief 磨皮
     */
    MolBeautifyExfoliatingType,
    
};

typedef void (^BeautifyConfirmBlock) (float value);
typedef void (^filterConfirmBlock) (PLSFilter *filter);

@interface MOLBeautifyView : MOLBasePushView

@property (strong,nonatomic)BeautifyConfirmBlock BeautifyConfirmBlock;
@property (strong,nonatomic)filterConfirmBlock filterConfirmBlock;
@property(nonatomic,assign)NSInteger exfoliatingSelIndex;//磨皮等级
-(instancetype)initWithCustomH:(CGFloat)height showBottom:(BOOL)show withfilterImage:(UIImage *)image;
-(void)setOptionFilter;//设置默认滤镜
-(void)hidePageView;//隐藏导航条 从而起到隐藏磨皮的设置

@end
