//
//  AttentionViewController.h
//  reward
//
//  Created by xujin on 2018/9/12.
//  Copyright © 2018年 reward. All rights reserved.
//

typedef NS_ENUM(NSUInteger, AttentionViewControllerType) {
    AttentionViewControllerType_Fans, //粉丝
    AttentionViewControllerType_Concerns //关注作品,
};

#import "MOLBaseViewController.h"

@interface AttentionViewController : MOLBaseViewController
- (void)refreshHome;
@end
