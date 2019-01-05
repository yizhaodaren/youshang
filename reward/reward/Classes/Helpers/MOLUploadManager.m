//
//  MOLUploadManager.m
//  reward
//
//  Created by moli-2017 on 2018/9/23.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLUploadManager.h"
#import <QiniuSDK.h>
#import "MOLQNTokenRequest.h"

@interface MOLUploadManager ()
@property (nonatomic, strong) QNUploadManager *upManager;

@end

@implementation MOLUploadManager

+ (instancetype)shareUploadManager
{
    static MOLUploadManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil)
        {
            instance = [[MOLUploadManager alloc] init];
            instance.upManager = [[QNUploadManager alloc] init];
        }
    });
    return instance;
}

/// 上传单张图片
- (void)qiNiu_uploadImage:(UIImage *)image complete:(void(^)(NSString *name))complete
{
    [self getQNTokenSuccessBlock:^(NSString *token,NSString *key) {
        
        NSString *QNToken = token;
        
        NSData *data = [image mol_compressWithLengthLimit:300.0 * 1024.0];
        
        [self.upManager putData:data key:key token:QNToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            
            if (info.statusCode == 200 && resp) {
                NSString *url = @"http://file.urmoli.com";
                NSString *str = [NSString stringWithFormat:@"%@/%@",url,key];
                if (complete) {
                    complete(str);
                }
            }else{
                if (complete) {
                    complete(nil);
                }
            }
            
        } option:nil];
    }];
    
}

/// 获取token
- (void)getQNTokenSuccessBlock:(void(^)(NSString *token,NSString *key))successBlock
{
    NSString *deviceId = [[NSUUID UUID] UUIDString];
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    // 毫秒值+随机字符串+文件类型
    NSString *imageName = [NSString stringWithFormat:@"reward/image/iOS_%lld%@.%@",(long long)interval,deviceId,@"jpg"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"fileKey"] = imageName;
    MOLQNTokenRequest *r = [[MOLQNTokenRequest alloc] initRequest_qiNiuTokenWithParameter:dic];
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        
        NSString *token = request.responseObject[@"resBody"];
        if (successBlock) {
            successBlock(token,imageName);
        }
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        
    }];
}
/// 获取上传视频的token
- (void)getQNAudioTokenSuccessBlock:(void(^)(NSString *token,NSString *key))successBlock{
    NSString *deviceId = [[NSUUID UUID] UUIDString];
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    // 毫秒值+随机字符串+文件类型
    NSString *imageName = [NSString stringWithFormat:@"reward/audio/iOS_%lld%@.%@",(long long)interval,deviceId,@"mp4"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"fileKey"] = imageName;
    MOLQNTokenRequest *r = [[MOLQNTokenRequest alloc] initRequest_qiNiuTokenWithParameter:dic];
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        
        NSString *token = request.responseObject[@"resBody"];
        if (successBlock) {
            successBlock(token,imageName);
        }
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        
    }];
}
//- (NSString *)getImagePath:(UIImage *)image {
//    NSString *filePath = nil;
//
//    NSData *data = [image mol_compressWithLengthLimit:300.0 * 1024.0];
//
//    //图片保存的路径
//    //这里将图片放在沙盒的documents文件夹中
//    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//
//    //文件管理器
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//
//    //把刚刚图片转换的data对象拷贝至沙盒中
//    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
//    NSString *ImagePath = [[NSString alloc] initWithFormat:@"/theFirstImage.png"];
//    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:ImagePath] contents:data attributes:nil];
//
//    //得到选择后沙盒中图片的完整路径
//    filePath = [[NSString alloc] initWithFormat:@"%@%@", DocumentsPath, ImagePath];
//    return filePath;
//}
@end
