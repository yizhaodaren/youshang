//
//  MOLExaminePacketModeCell.h
//  reward
//
//  Created by moli-2017 on 2018/9/18.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PLPlayerKit/PLPlayerKit.h>
#import "MOLVideoModel.h"
#import "MOLVideoOutsideModel.h"

typedef NS_ENUM(NSUInteger, MOLExaminePacketModeCellType) {
    MOLExaminePacketModeCellType_normal,
    MOLExaminePacketModeCellType_examine,
};

@protocol MOLExaminePacketModeCellDelegate <NSObject>

- (void)MOLExaminePacketModeCellEvent:(MOLVideoOutsideModel *)model;

@end

@interface MOLExaminePacketModeCell : UITableViewCell
@property (nonatomic,weak)id<MOLExaminePacketModeCellDelegate>delegate;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(MOLExaminePacketModeCellType)type;

@property (nonatomic, strong) PLPlayer *player;

@property (nonatomic, strong) MOLVideoModel *videoModel;

@property (nonatomic, strong) MOLVideoOutsideModel *videoOutsideModel;

@property (nonatomic, assign) BOOL clickPause; // 点击了暂停
@end
