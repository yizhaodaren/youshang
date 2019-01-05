//
//  MOLMineCollectionViewCell.h
//  reward
//
//  Created by moli-2017 on 2018/9/12.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOLLightVideoModel.h"
#import "MOLVideoModel.h"
#import "MOLVideoOutsideModel.h"

typedef NS_ENUM(NSUInteger, MOLMineCollectionViewCellType) {
    MOLMineCollectionViewCellType_normal,
    MOLMineCollectionViewCellType_userProduction,
    MOLMineCollectionViewCellType_userReward,
    MOLMineCollectionViewCellType_userLike,
};

@interface MOLMineCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) UIButton *playCountButton;

@property (nonatomic, strong) MOLLightVideoModel *lightVideoModel;  // 我的悬赏卡片下 用

@property (nonatomic, strong) MOLVideoOutsideModel *videoOutsideModel;

@property (nonatomic, assign) MOLMineCollectionViewCellType type;

- (void)layout;
@end
