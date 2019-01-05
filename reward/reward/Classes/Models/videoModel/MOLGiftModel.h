//
//  MOLGiftModel.h
//  reward
//
//  Created by moli-2017 on 2018/10/9.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseModel.h"

@interface MOLGiftModel : MOLBaseModel
@property (nonatomic, assign) NSInteger giftId;
@property (nonatomic, strong) NSString *giftName; //礼物名称
@property (nonatomic, strong) NSString *giftThumb;  // 礼物图片
@property (nonatomic, assign) NSInteger giftNum;   // 礼物数量
@property (nonatomic, assign) NSInteger gold;    // 单个礼物的金币价值
@property (nonatomic, assign) NSInteger price;   // 单个礼物的钻石价值
@end
