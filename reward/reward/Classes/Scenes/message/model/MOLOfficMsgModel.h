//
//  MOLOfficMsgModel.h
//  reward
//
//  Created by moli-2017 on 2018/9/21.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseModel.h"

@interface MOLOfficMsgModel : MOLBaseModel
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *messageBody;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, assign) BOOL read;
@property (nonatomic, assign) NSInteger type;  // 0 text  1 参加按钮

@property (nonatomic, assign) CGFloat cellHeight;
@end
