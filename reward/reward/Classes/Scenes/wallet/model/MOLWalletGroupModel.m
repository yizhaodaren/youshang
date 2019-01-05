//
//  MOLWalletGroupModel.m
//  reward
//
//  Created by moli-2017 on 2018/10/13.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLWalletGroupModel.h"

@implementation MOLWalletGroupModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"resBody":[MOLWalletModel class]};
}
@end
