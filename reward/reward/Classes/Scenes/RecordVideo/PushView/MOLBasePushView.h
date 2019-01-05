//
//  MOLBasePushView.h
//  reward
//
//  Created by apple on 2018/9/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOLBasePushView : UIView

@property (strong,nonatomic)dispatch_block_t dismissBlock;
@property (strong,nonatomic)dispatch_block_t closeBlock;
@property (strong,nonatomic)dispatch_block_t endBlock;

@property (strong,nonatomic)UIView *contentView;//整个底部view
@property (strong,nonatomic)UIView *customView;//自定义部分View

-(instancetype)initWithCustomH:(CGFloat)height showBottom:(BOOL)show;//自定义部分的高度 show 是否展示底部对号和x号

-(void)showInView:(UIView *)view;//展示
-(void)dismissView;//隐藏

-(void)setBottomViewTitle:(NSString *)title;//设置底部标题
@end
