//
//  MOLMineHeadView.h
//  reward
//
//  Created by moli-2017 on 2018/9/11.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOLUserModel.h"

@interface MOLMineHeadView : UIView
@property (nonatomic, strong) MOLUserModel *userModel;
- (void)layout;
@end
