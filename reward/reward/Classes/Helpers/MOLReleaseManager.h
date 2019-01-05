//
//  MOLReleaseManager.h
//  reward
//
//  Created by apple on 2018/10/9.
//  Copyright © 2018年 reward. All rights reserved.
//


//发布悬赏的时候（） 设置当前类型为悬赏


#import <Foundation/Foundation.h>
#import "MOLRewardModel.h"
typedef NS_ENUM(NSInteger, ReleaseType) {
    ReleaseType_work = 0,//作品
    ReleaseType_reward,//悬赏
//    ReleaseType_H5,//H5吊起拍摄
};
typedef void(^H5ReleaseBlock)(NSMutableDictionary *dic);

@interface MOLReleaseManager : NSObject
+(instancetype)manager;

//当前发布类型 作品 or 悬赏
@property(nonatomic,assign)ReleaseType currentReleaseType;

//发布作品需要的
@property(nonatomic,assign)NSInteger rewardID;//(-1为视频认证 0为普通作品 1及1以上为悬赏作品)发布作品对应的悬赏ID

//发布悬赏需要的
@property(nonatomic,strong)MOLRewardModel *currentRewardModel;//悬赏信息

//H5传过来 如果H5过来是悬赏只需要传这个值 如果是作品需要传rewardID
//
//[MOLReleaseManager manager].rewardID = 0;//悬赏ID为0 代表自发的作品没有悬赏
//[MOLReleaseManager manager].h5ReleaseBlock = ^(NSMutableDictionary *dic) {
//    NSLog(@"%@",dic);
//    NSLog(@"结束");
//};
#warning 由H5进入 没有走到发布完成 h5ReleaseBlock没有置为nil
@property(nonatomic,strong)H5ReleaseBlock h5ReleaseBlock;

@end
