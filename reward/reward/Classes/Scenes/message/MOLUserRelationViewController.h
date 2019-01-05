//
//  MOLUserRelationViewController.h
//  reward
//
//  Created by moli-2017 on 2018/9/17.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseViewController.h"

typedef NS_ENUM(NSUInteger, MOLUserRelationType) {
    MOLUserRelationType_fans,
    MOLUserRelationType_focus,
    MOLUserRelationType_msgFans,
};

@interface MOLUserRelationViewController : MOLBaseViewController
@property (nonatomic, assign) MOLUserRelationType relationType;
@property (nonatomic, strong) NSString *userId;
@end
