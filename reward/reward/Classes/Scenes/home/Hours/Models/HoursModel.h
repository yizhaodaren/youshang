//
//  HoursModel.h
//  reward
//
//  Created by xujin on 2018/10/22.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseModel.h"
#import "HoursExtModel.h"
#import "HoursItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HoursModel : MOLBaseModel
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger dynamicType; //内容类型(0=标题头1=悬赏,2=作品,3=网页链接)
@property (nonatomic, copy) NSString *text; //内容 section show
@property (nonatomic, strong) HoursExtModel *ext; //扩展内容
@property (nonatomic, strong) NSMutableArray <HoursItemModel *>*itemList; //item清单
@property (nonatomic, copy) NSString *time; //前面显示时间

@property (nonatomic, assign)CGFloat hourscellHeight;

@end

NS_ASSUME_NONNULL_END
