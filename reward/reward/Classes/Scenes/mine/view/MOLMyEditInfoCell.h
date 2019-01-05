//
//  MOLMyEditInfoCell.h
//  reward
//
//  Created by moli-2017 on 2018/9/14.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOLMyEditModel.h"

@interface MOLMyEditInfoCell : UITableViewCell
@property (nonatomic, strong) MOLMyEditModel *model;
@property (nonatomic, weak) NSDictionary *formDic;

@property (nonatomic, strong) void(^clickTextfieldBlock)(CGRect frame);
@end
