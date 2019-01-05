//
//  MOLTreasureModel.h
//  reward
//
//  Created by moli-2017 on 2018/10/17.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseModel.h"

@interface MOLTreasureModel : MOLBaseModel
@property (nonatomic, assign) CGFloat coinAmount;  // 可使用金币数量
@property (nonatomic, assign) CGFloat coinToDia;  // 金币兑换钻石折损
@property (nonatomic, assign) CGFloat convert;  // 金币钻石兑换比例
@property (nonatomic, assign) CGFloat diamondAmount; // 钻石数量
@property (nonatomic, assign) CGFloat txCoinAmount;  // 提现冻结金币数量
@property (nonatomic, strong) NSString *userId;
@end
