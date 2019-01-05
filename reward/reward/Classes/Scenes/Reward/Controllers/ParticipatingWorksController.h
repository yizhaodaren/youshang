//
//  ParticipatingWorksController.h
//  reward
//
//  Created by xujin on 2018/9/27.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseViewController.h"
#import "MOLVideoOutsideModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ParticipatingWorksController : MOLBaseViewController
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) MOLVideoOutsideModel *rewardModel;

@end

NS_ASSUME_NONNULL_END
