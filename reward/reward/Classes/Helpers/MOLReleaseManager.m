//
//  MOLReleaseManager.m
//  reward
//
//  Created by apple on 2018/10/9.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLReleaseManager.h"

@implementation MOLReleaseManager
+(instancetype)manager{
    static  MOLReleaseManager  *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager  = [[MOLReleaseManager alloc] init];
    });
    return manager;
}
-(void)setCurrentRewardModel:(MOLRewardModel *)currentRewardModel{
    _currentRewardModel = currentRewardModel;
    _currentReleaseType = ReleaseType_reward;
}

-(void)setRewardID:(NSInteger)rewardID{
    _rewardID = rewardID;
    _currentReleaseType = ReleaseType_work;
}
-(void)setH5ReleaseBlock:(H5ReleaseBlock)h5ReleaseBlock{
    _h5ReleaseBlock = h5ReleaseBlock;
}
@end
