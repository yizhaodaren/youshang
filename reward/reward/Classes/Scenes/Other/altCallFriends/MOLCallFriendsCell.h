//
//  MOLCallFriendsCell.h
//  reward
//
//  Created by apple on 2018/11/7.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOLMsgUserModel.h"
@interface MOLCallFriendsCell : UITableViewCell
@property (nonatomic, strong) MOLMsgUserModel *userModel;
@property (nonatomic, assign) NSInteger type; // 0 签名 1 时间
@end

