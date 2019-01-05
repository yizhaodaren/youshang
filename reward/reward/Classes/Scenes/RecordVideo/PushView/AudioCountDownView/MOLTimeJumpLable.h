//
//  MOLTimeJumpLable.h
//  reward
//
//  Created by apple on 2018/9/8.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOLTimeJumpLable : UILabel
//开始倒计时时间
@property (nonatomic, assign) int count;
@property (strong,nonatomic)dispatch_block_t Block;

- (instancetype)initWithFrame:(CGRect)frame;
//执行这个方法开始倒计时
- (void)startCount;
@end
