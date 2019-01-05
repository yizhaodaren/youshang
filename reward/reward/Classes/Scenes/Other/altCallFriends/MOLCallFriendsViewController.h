//
//  MOLCallFriendsViewController.h
//  reward
//
//  Created by apple on 2018/11/7.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOLMsgUserModel.h"

typedef void (^SelectUserBlock) (MOLMsgUserModel *model);
typedef NS_ENUM(NSUInteger, MOLFriendType) {
    MOLFriendType_focus,
    MOLFriendType_seached,
};
@interface MOLCallFriendsViewController : MOLBaseViewController
@property(nonatomic,strong)SelectUserBlock selectedBlock;

+(MOLCallFriendsViewController *)show;
@end
