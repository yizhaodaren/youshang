//
//  MOLTMusicCell.h
//  reward
//
//  Created by apple on 2018/11/24.
//  Copyright © 2018 reward. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MOLVideoOutsideModel;

NS_ASSUME_NONNULL_BEGIN
@protocol RewardCellDelegate <NSObject>
- (void)playCountEvent:(UIButton *)sender indexPath:(NSIndexPath *)indexPath;
- (void)rewardCellAvatarEvent:(NSIndexPath *)indexPath;
    
    @end

@interface MOLHotMusicCell : UITableViewCell
    @property (nonatomic,weak)id<RewardCellDelegate>delegate;
- (void)rewardCell:(MOLVideoOutsideModel *)model indexPath:(NSIndexPath *)indexPath;
    
    @end

NS_ASSUME_NONNULL_END
