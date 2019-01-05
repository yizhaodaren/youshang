//
//  MOLUploadManager.h
//  reward
//
//  Created by moli-2017 on 2018/9/23.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOLUploadManager : NSObject
+ (instancetype)shareUploadManager;

/// 上传多张图片
//- (void)qiNiu_uploadImages:(NSArray *)images complete:(void(^)(NSArray<NSDictionary *> *names))complete;

/// 上传单张图片
- (void)qiNiu_uploadImage:(UIImage *)image complete:(void(^)(NSString *name))complete;

/// 获取上传视频的token
- (void)getQNAudioTokenSuccessBlock:(void(^)(NSString *token,NSString *key))successBlock;
@end
