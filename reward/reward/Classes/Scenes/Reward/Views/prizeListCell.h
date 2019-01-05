//
//  prizeListCell.h
//  reward
//
//  Created by xujin on 2018/10/9.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RewardModel;

NS_ASSUME_NONNULL_BEGIN

@interface prizeListCell : UITableViewCell
- (void)prizeListCell:(RewardModel *)model indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
