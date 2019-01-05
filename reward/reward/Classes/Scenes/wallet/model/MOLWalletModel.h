//
//  MOLWalletModel.h
//  reward
//
//  Created by moli-2017 on 2018/9/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseModel.h"

@interface MOLWalletModel : MOLBaseModel
@property (nonatomic, strong) NSString *goodsId;
@property (nonatomic, strong) NSString *goodsName;
@property (nonatomic, strong) NSString *diamondAmount;
@property (nonatomic, strong) NSString *cnyAmount;
@property (nonatomic, strong) NSString *goodsDesc;

@end
