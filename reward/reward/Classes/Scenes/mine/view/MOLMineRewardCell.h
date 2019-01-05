//
//  MOLMineRewardCell.h
//  reward
//
//  Created by moli-2017 on 2018/9/13.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOLExamineCardModel.h"
#import "MOLVideoOutsideModel.h"

typedef NS_ENUM(NSUInteger, MOLMineRewardCellType) {
    MOLMineRewardCellType_mine,
    MOLMineRewardCellType_other,
};

@interface MOLMineRewardCell : UITableViewCell
@property (nonatomic, assign) MOLMineRewardCellType cellType;
@property (nonatomic, strong) MOLExamineCardModel *cardModel;

@property (nonatomic, strong) MOLVideoOutsideModel *videooutModel;
@end
