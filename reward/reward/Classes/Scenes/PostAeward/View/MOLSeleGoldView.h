//
//  MOLSeleGoldView.h
//  reward
//
//  Created by apple on 2018/9/27.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOLBasePushView.h"
#import "MOLGiftModel.h"
@protocol MOLSeleGoldViewDelegate <NSObject>

@optional
//选择的礼物
-(void)didSelectAt:(MOLGiftModel *)gift;
//选择了数量
-(void)didSelectGiftNumber:(NSInteger)num;
//确认选择后
-(void)didSetGift:(MOLGiftModel *)gift WithGiftNum:(NSInteger)num;
//充值
-(void)didSelectAddGold;
@end
@interface MOLSeleGoldView : MOLBasePushView
@property(nonatomic,assign)float goldNum;
@property(nonatomic,weak) id<MOLSeleGoldViewDelegate> delegate;
@end
