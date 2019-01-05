//
//  EDChatViewController.h
//  aletter
//
//  Created by moli-2017 on 2018/8/27.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "MOLBaseViewController.h"
#import "EDChatTableView.h"

@class MOLUserModel;
@interface EDChatViewController : MOLBaseViewController 

// 和谁聊天创建回话
@property (nonatomic, strong) NIMSession *session;
@property (nonatomic, strong) MOLUserModel *userModel;

@end
