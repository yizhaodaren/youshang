//
//  HoursExtModel.h
//  reward
//
//  Created by xujin on 2018/10/22.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HoursExtModel : MOLBaseModel
@property (nonatomic, assign) NSInteger storyId;//作品Id
@property (nonatomic, assign) NSInteger userId;//用户Id
@property (nonatomic, assign) NSInteger rewardId; //悬赏Id
@property (nonatomic, assign) NSInteger giftNum; //礼品数量
@property (nonatomic, copy) NSString *giftThumb; //礼品链接
@property (nonatomic, copy) NSString * url;
@end

NS_ASSUME_NONNULL_END
