//
//  MOLMessageListModel.h
//  reward
//
//  Created by 刘宏亮 on 2018/9/16.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseModel.h"

@interface MOLMessageListModel : MOLBaseModel
@property (nonatomic, strong) NIMRecentSession *recent;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *messageBody;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, assign) BOOL read;
@property (nonatomic, assign) BOOL offic;
@end
