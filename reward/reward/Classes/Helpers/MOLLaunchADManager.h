//
//  MOLLaunchADManager.h
//  reward
//
//  Created by apple on 2018/12/1.
//  Copyright © 2018 reward. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BannerModel;
@interface MOLLaunchADManager : NSObject
@property(nonatomic,assign)BOOL isShowing;//是否在展示中
+ (instancetype)shareInstance;
-(void)setADDate:(BannerModel *)model;

@end
