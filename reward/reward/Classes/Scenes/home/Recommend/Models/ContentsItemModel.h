//
//  ContentsItemModel.h
//  reward
//
//  Created by xujin on 2018/11/8.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContentsItemModel : MOLBaseModel
@property (nonatomic, copy) NSString *color; //内容color
@property (nonatomic, copy) NSString *text; //内容
@property (nonatomic, assign) NSInteger type;//  内容类型1=文本,2=用户
@property (nonatomic, assign) NSInteger typeId;//
@end

NS_ASSUME_NONNULL_END
