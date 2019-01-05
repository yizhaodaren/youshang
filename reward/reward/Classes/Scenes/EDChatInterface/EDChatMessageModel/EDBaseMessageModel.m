//
//  EDBaseMessageModel.m
//  aletter
//
//  Created by moli-2017 on 2018/8/24.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "EDBaseMessageModel.h"

@implementation EDBaseMessageModel

MJCodingImplementation

- (CGFloat)getCellHeight{return 0;}


- (void)setupModelWithNIM:(NIMMessage *)message ownUser:(MOLUserModel *)user otherUser:(MOLUserModel *)otherUser
{
    self.logId = message.messageId;
    
    self.userName = message.senderName;

    NSString *from = [message.from stringByReplacingOccurrencesOfString:@"reward" withString:@""];
    if ([from isEqualToString:user.userId]) {
        self.fromType = MessageFromType_me;
        self.userImage = user.avatar;
        self.userName = user.userName;
        self.userId = user.userId;
    }else{
        self.fromType = MessageFromType_other;
        self.userImage = otherUser.avatar;
        self.userName = otherUser.userName;
        self.userId = otherUser.userId;
    }
    
    self.createTime = [NSString stringWithFormat:@"%f",message.timestamp * 1000];
}
@end
