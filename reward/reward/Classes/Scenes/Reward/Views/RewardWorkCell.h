//
//  RewardWorkCell.h
//  reward
//
//  Created by xujin on 2018/9/23.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  MOLVideoOutsideModel;
NS_ASSUME_NONNULL_BEGIN
@interface RewardWorkCell : UICollectionViewCell

- (void)content:(MOLVideoOutsideModel *)model indexPath:(NSIndexPath *)indexPath;
#pragma mark - UI
- (void)contentMusic:(MOLVideoOutsideModel *)model indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
