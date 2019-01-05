//
//  HoursGroupModel.h
//  reward
//
//  Created by xujin on 2018/10/22.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseModel.h"
#import "HoursModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HoursGroupModel : MOLBaseModel
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger dynamicType; //内容类型(0=标题头1=悬赏,2=作品,3=网页链接)
@property (nonatomic, copy) NSString *text; //内容 section show
@property (nonatomic, assign) BOOL isSection;
@property (nonatomic, strong) NSMutableArray <HoursModel *>*hoursArr; 
@end

NS_ASSUME_NONNULL_END
