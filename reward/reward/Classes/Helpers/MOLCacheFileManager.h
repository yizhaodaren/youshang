//
//  MOLCacheFileManager.h
//  reward
//
//  Created by apple on 2018/9/25.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MOLWorksModel;
@interface MOLCacheFileManager : NSObject

@property(nonatomic,strong)NSURL *lastSaveUrl;

+(instancetype)manager;

+ (NSString *)getTempVideoFilePath;//固定文件名。 录制导出时候用
+ (NSString *)getRandomVideoFilePath;//随机文件名
+ (NSString *)getCacheVideoFilePath:(NSString *)fileName;
//******************************************音频****************************************//
+ (NSString *)getMusicFilePath:(NSString *)fileName;



//获取全部草稿数据
+ (NSMutableArray *)getAllDraftInfo;
//获取最后一个草稿
+ (MOLWorksModel *)getLastDraft;

/*s*
 *  获取path路径下文件夹的大小
 *
 *  @param path 要获取的文件夹 路径
 *
 *  @return 返回path路径下文件夹的大小
 */
+ (NSString *)getCacheSizeWithFilePath:(NSString *)path;

/**
 *  清除path路径下文件夹的缓存
 *
 *  @param path  要清除缓存的文件夹 路径
 *
 *  @return 是否清除成功
 */
+ (BOOL)clearCacheWithFilePath:(NSString *)path;
@end
