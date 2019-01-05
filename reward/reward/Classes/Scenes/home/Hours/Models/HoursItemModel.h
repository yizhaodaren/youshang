//
//  HoursItemModel.h
//  reward
//
//  Created by xujin on 2018/10/22.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseModel.h"
#import "HoursExtModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HoursItemModel : MOLBaseModel
@property (nonatomic, copy) NSString *color; //内容color
@property (nonatomic, strong) HoursExtModel *ext; //扩展内容
@property (nonatomic, copy) NSString *text; //内容
@property (nonatomic, assign) NSInteger type;//  内容类型1=文本,2=金币,3=用户,4=礼物


@end

NS_ASSUME_NONNULL_END
