//
//  MOLMySettingViewModel.h
//  reward
//
//  Created by moli-2017 on 2018/9/13.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOLMySettingViewModel : NSObject

@property (nonatomic, strong) RACCommand *settingCommand;  // 获取数据源命令
@end
