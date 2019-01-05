//
//  MOLExamineViewModel.h
//  reward
//
//  Created by moli-2017 on 2018/9/15.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOLExamineViewModel : NSObject
@property (nonatomic, strong) RACCommand *examineListCommand;   // 评选列表
@property (nonatomic, strong) RACCommand *examinePacketCommand;  // 评选红包列表

@end
