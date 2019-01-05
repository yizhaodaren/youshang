//
//  MOLAccountSetPasswordViewController.h
//  reward
//
//  Created by moli-2017 on 2018/9/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseViewController.h"

@interface MOLAccountSetPasswordViewController : MOLBaseViewController
@property (nonatomic, strong) NSString *phoneString;
@property (nonatomic, strong) void(^bindingPhoneBlock)(void);
@end
