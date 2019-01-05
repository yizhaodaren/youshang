//
//  MOLVideoAuthPlayVC.h
//  reward
//
//  Created by apple on 2018/11/29.
//  Copyright © 2018 reward. All rights reserved.
//

#import "MOLBaseViewController.h"
#import "MOLAuthInfoModel.h"
@interface MOLVideoAuthPlayVC : MOLBaseViewController
@property(nonatomic,strong)MOLAuthInfoModel  *authInfoModel;
@property(nonatomic,assign)BOOL isSelf;//是否是自己
@end
