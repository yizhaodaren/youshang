//
//  MOLMySettingViewModel.m
//  reward
//
//  Created by moli-2017 on 2018/9/13.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLMySettingViewModel.h"

#define Kmanager [NSFileManager defaultManager]

@implementation MOLMySettingViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupMySettingViewModel];
    }
    return self;
}

- (void)setupMySettingViewModel
{
    @weakify(self);
    self.settingCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [subscriber sendNext:[self getDataSourceWithCache:@"0MB"]];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
//                NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
//                NSString *path1 = [path stringByAppendingPathComponent:@"default"];
//                NSInteger fileSize = [self getDataSize:path1];
//                   NSInteger fileSize = [self getDataSize:path];
//
//                NSString *fileDataSize = [NSString stringWithFormat:@"%.2fMB",fileSize/1024.0/1024.0];
                
                NSString *fileDataSize = [MOLCacheFileManager getCacheSizeWithFilePath:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [subscriber sendNext:[self getDataSourceWithCache:fileDataSize]];
                    [subscriber sendCompleted];
                });
            });
            
            return nil;
        }];
        
        return signal;
    }];
}

- (NSArray *)getDataSourceWithCache:(NSString *)cache
{
    NSMutableArray *arrM = [NSMutableArray array];
    
    NSDictionary *account = @{
                              @"image":@"mine_security",
                              @"name":@"账号安全",
                              @"subName":@"",
                              @"arrow":@"mine_shape",
                              };
    
//    NSDictionary *notiface = @{
//                               @"image":@"mine_notice",
//                               @"name":@"通知设置",
//                               @"subName":@"",
//                               @"arrow":@"mine_shape",
//                               };
//
//    NSDictionary *privacy = @{
//                              @"image":@"mine_privacy",
//                              @"name":@"隐私设置",
//                              @"subName":@"",
//                              @"arrow":@"mine_shape",
//                              };
    
    
    NSDictionary *help = @{
                              @"image":@"mine_feedback",
                              @"name":@"意见反馈",
                              @"subName":@"",
                              @"arrow":@"mine_shape",
                              };
    
    NSDictionary *agreement = @{
                              @"image":@"mine_agreement",
                              @"name":@"用户协议",
                              @"subName":@"",
                              @"arrow":@"mine_shape",
                              };
    
    NSDictionary *private = @{
                                @"image":@"mine_private",
                                @"name":@"隐私政策",
                                @"subName":@"",
                                @"arrow":@"mine_shape",
                                };
    
    NSDictionary *aboutus = @{
                              @"image":@"mine_about",
                              @"name":@"关于我们",
                              @"subName":@"",
                              @"arrow":@"mine_shape",
                              };
    
    NSDictionary *good = @{
                              @"image":@"mine_good",
                              @"name":@"给个好评",
                              @"subName":@"",
                              @"arrow":@"mine_shape",
                              };
    
    NSDictionary *clear = @{
                              @"image":@"mine_garbage",
                              @"name":@"清除缓存",
//                              @"subName":@"",
                              @"subName":cache,
                              @"arrow":@"",
                              };
    
    NSDictionary *exit = @{
                              @"image":@"mine_exit",
                              @"name":@"退出登录",
                              @"subName":@"",
                              @"arrow":@"",
                              };
    
//    NSMutableArray *arr1 = [NSMutableArray array];
//    [arr1 addObject:account];
//    [arr1 addObject:notiface];
//    [arr1 addObject:privacy];
    
    NSMutableArray *arr2 = [NSMutableArray array];
    [arr2 addObject:account];
    [arr2 addObject:help];
    [arr2 addObject:agreement];
    [arr2 addObject:private];
    [arr2 addObject:aboutus];
    [arr2 addObject:good];
    [arr2 addObject:clear];
    
    NSMutableArray *arr3 = [NSMutableArray array];
    [arr3 addObject:exit];
    
//    [arrM addObject:arr1];
    [arrM addObject:arr2];
    [arrM addObject:arr3];
    
    return arrM;
}

#pragma mark - 缓存
- (void)clearDataSize:(NSString *)fullPath
{
    
    // 判断filePath路径下的文件是否存在？是文件夹还是文件
    BOOL directory;
    BOOL ok = [Kmanager fileExistsAtPath:fullPath isDirectory:&directory];
    if (!ok || !directory) {
        return;
    }
    
    // 获取该路径下一级目录
    NSArray *subFiles = [Kmanager contentsOfDirectoryAtPath:fullPath error:nil];
    
    for (NSString *subFile in subFiles) {
        NSString *filePath = [fullPath stringByAppendingPathComponent:subFile];
        [Kmanager removeItemAtPath:filePath error:nil];
    }
}

- (NSInteger)getDataSize:(NSString *)fullPath
{
    BOOL directory;
    BOOL ok = [Kmanager fileExistsAtPath:fullPath isDirectory:&directory];
    
    if (!ok || !directory) {
        return 0;
    }
    NSInteger totalSize = 0;
    NSArray *subFiles = [Kmanager subpathsAtPath:fullPath];
    for (NSString *subFile in subFiles) {
        NSString *filePath = [fullPath stringByAppendingPathComponent:subFile];
        BOOL directory;
        BOOL ok = [Kmanager fileExistsAtPath:filePath isDirectory:&directory];
        
        if (ok && !directory) {
            
            NSDictionary *dict = [Kmanager attributesOfItemAtPath:filePath error:nil];
            NSInteger filesize = [dict fileSize];
            // 计算总大小
            totalSize += filesize;
        }
    }
    return totalSize;
}
@end
