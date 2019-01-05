//
//  MOLShareManager.h
//  aletter
//
//  Created by 徐天牧 on 2018/9/1.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOLShareModel.h"
@interface MOLShareManager : NSObject
+(instancetype)share;
//分享
-(void)shareWithModel:(MOLShareModel *)model;
@end
