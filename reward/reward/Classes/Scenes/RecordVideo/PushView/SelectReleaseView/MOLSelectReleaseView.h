//
//  MOLSelectReleaseView.h
//  reward
//
//  Created by apple on 2018/9/21.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBasePushView.h"

@interface MOLSelectReleaseView : MOLBasePushView

@property (strong,nonatomic)dispatch_block_t releaseWorkBlock;
@property (strong,nonatomic)dispatch_block_t releaseRewardBlock;

@end
