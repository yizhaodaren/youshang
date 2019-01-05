//
//  MOLCacheFileManager.m
//  reward
//
//  Created by apple on 2018/9/25.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLCacheFileManager.h"
#import "MOLWorksModel.h"
@implementation MOLCacheFileManager
+(instancetype)manager{
    static  MOLCacheFileManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager  = [[MOLCacheFileManager alloc] init];
    });
    return manager;
}

//获取视频文件随机存储路径名
+ (NSString *)getRandomVideoFilePath{
        NSString *uuidString = [[NSUUID UUID] UUIDString];
        NSString *recordFile = [MOLCacheFileManager getCacheVideoFilePath:[NSString stringWithFormat:@"%@.mp4",uuidString]];
    return recordFile;
}

//获取视频文件随机存储路径名
+ (NSString *)getTempVideoFilePath{
    
    NSString *recordFile = [MOLCacheFileManager getCacheVideoFilePath:@"tempVideo.mp4"];
    return recordFile;
}

+ (NSString *)getCacheVideoFilePath:(NSString *)fileName {
    if (!fileName.length) {
        return @"";
    }
    NSString *dictionaryPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/default/Videos"];
    NSFileManager *filemanager = [NSFileManager new];
    if (![filemanager fileExistsAtPath:dictionaryPath]) {
        [filemanager createDirectoryAtPath:dictionaryPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    NSString *filePath = [dictionaryPath stringByAppendingFormat:@"/%@",fileName];
    return filePath;
}
//音乐文件目录
+ (NSString *)getMusicFilePath:(NSString *)fileName {
    if (!fileName.length) {
        return @"";
    }
    NSString *dictionaryPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/default/Audios"];
    NSFileManager *filemanager = [NSFileManager new];
    if (![filemanager fileExistsAtPath:dictionaryPath]) {
        [filemanager createDirectoryAtPath:dictionaryPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    NSString *filePath = [dictionaryPath stringByAppendingFormat:@"/%@",fileName];
    return filePath;
}

+ (NSMutableArray *)getAllDraftInfo{
//    @"createTime Desc"
    NSMutableArray* array = [MOLWorksModel searchWithWhere:nil orderBy:@"time desc" offset:0 count:100];
    NSMutableArray* array2 = [MOLWorksModel searchWithWhere:nil orderBy:@"createTime Desc" offset:0 count:100];

    return array;
}
+ (MOLWorksModel *)getLastDraft{
    NSArray *lastDataSource = [MOLWorksModel searchWithWhere:nil orderBy:@"time desc" offset:0 count:1];
    MOLWorksModel * work = lastDataSource.firstObject;
    return work;
}

#pragma mark - 获取path路径下文件夹大小
+ (NSString *)getCacheSizeWithFilePath:(NSString *)path{
    
    path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/default"];
    // 获取“path”文件夹下的所有文件
    NSArray *subPathArr = [[NSFileManager defaultManager] subpathsAtPath:path];
    
    NSString *filePath  = nil;
    NSInteger totleSize = 0;
    
    for (NSString *subPath in subPathArr){
        
        // 1. 拼接每一个文件的全路径
        filePath =[path stringByAppendingPathComponent:subPath];
        // 2. 是否是文件夹，默认不是
        BOOL isDirectory = NO;
        // 3. 判断文件是否存在
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        
        // 4. 以上判断目的是忽略不需要计算的文件
        if (!isExist || isDirectory || [filePath containsString:@".DS"]){
            // 过滤: 1. 文件夹不存在  2. 过滤文件夹  3. 隐藏文件
            continue;
        }
        
        // 5. 指定路径，获取这个路径的属性
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        /**
         attributesOfItemAtPath: 文件夹路径
         该方法只能获取文件的属性, 无法获取文件夹属性, 所以也是需要遍历文件夹的每一个文件的原因
         */
        
        // 6. 获取每一个文件的大小
        NSInteger size = [dict[@"NSFileSize"] integerValue];
        
        // 7. 计算总大小
        totleSize += size;
    }
    
    //8. 将文件夹大小转换为 M/KB/B
    NSString *totleStr = nil;
    
    if (totleSize > 1000 * 1000){
        totleStr = [NSString stringWithFormat:@"%.2fM",totleSize / 1000.00f /1000.00f];
        
    }else if (totleSize > 1000){
        totleStr = [NSString stringWithFormat:@"%.2fKB",totleSize / 1000.00f ];
        
    }else{
        totleStr = [NSString stringWithFormat:@"%.2fB",totleSize / 1.00f];
    }
    
    NSLog(@"缓存:%@",totleStr);
    return totleStr;
}


#pragma mark - 清除path文件夹下缓存大小
+ (BOOL)clearCacheWithFilePath:(NSString *)path{
    
    if (path == nil) {
        path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/default"];
    }
    
    //拿到path路径的下一级目录的子文件夹
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    
    NSString *filePath = nil;
    
    NSError *error = nil;
    
    for (NSString *subPath in subPathArr)
    {
        filePath = [path stringByAppendingPathComponent:subPath];
        
        //删除子文件夹
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error) {
            return NO;
        }
    }
    return YES;
}
@end
