//
//  MOLSwitchManager.h
//  aletter
//
//  Created by moli-2017 on 2018/9/10.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOLSwitchManager : NSObject
+ (instancetype)shareSwitchManager;
@property (nonatomic, assign) NSInteger normalStatus; //0 是默认审核中  1 是审核完成用户使用中
- (void)switch_check:(void(^)(void))resultBlock;
@end
