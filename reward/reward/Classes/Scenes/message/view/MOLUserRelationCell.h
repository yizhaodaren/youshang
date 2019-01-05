//
//  MOLUserRelationCell.h
//  reward
//
//  Created by moli-2017 on 2018/9/17.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOLMsgUserModel.h"
@interface MOLUserRelationCell : UITableViewCell
@property (nonatomic, strong) MOLMsgUserModel *userModel;
@property (nonatomic, assign) NSInteger type; // 0 签名 1 时间
@end
