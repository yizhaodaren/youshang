//
//  RewardCell.h
//  reward
//
//  Created by xujin on 2018/9/23.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MOLVideoOutsideModel;

NS_ASSUME_NONNULL_BEGIN
@protocol RewardCellDelegate <NSObject>
- (void)playCountEvent:(UIButton *)sender indexPath:(NSIndexPath *)indexPath;
- (void)rewardCellAvatarEvent:(NSIndexPath *)indexPath;

@end

@interface RewardCell : UITableViewCell
@property (nonatomic,weak)id<RewardCellDelegate>delegate;
- (void)rewardCell:(MOLVideoOutsideModel *)model indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
