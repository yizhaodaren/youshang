//
//  MOLClipMovieViewController.h
//  reward
//
//  Created by apple on 2018/9/18.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseViewController.h"

@interface MOLClipMovieViewController : MOLBaseViewController

//******************************************传值****************************************//
@property(nonatomic,assign)NSInteger source;//发布作品的视屏来源 //(1=相机,2=相册,3=外链)
//**********************************************************************************//

@property (strong, nonatomic) NSDictionary *settings;

@end
