//
//  MOLWalletViewModel.h
//  reward
//
//  Created by moli-2017 on 2018/9/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOLWalletViewModel : NSObject
@property (nonatomic, strong) RACCommand *rechargeCommand;  // 充值
@end
