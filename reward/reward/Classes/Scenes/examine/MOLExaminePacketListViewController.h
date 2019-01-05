//
//  MOLExaminePacketListViewController.h
//  reward
//
//  Created by moli-2017 on 2018/9/18.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseViewController.h"
#import "MOLExaminePacketModeView.h"

@interface MOLExaminePacketListViewController : MOLBaseViewController
@property (nonatomic, weak) MOLExaminePacketModeView *packetModeView;
@property (nonatomic, strong) NSString *rewardId;

@property (nonatomic, assign) NSInteger type;
@end
