//
//  MOLRecordManager.h
//  reward
//
//  Created by apple on 2018/9/8.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define MOLMixRCTIME [MOLRecordManager manager].mixRecordedTime
@class PLSVideoMixRecorder;
@class PLShortVideoRecorder;
@interface MOLRecordManager : NSObject
@property(nonatomic,assign) CGFloat mixRecordedTime;//合拍当前已录制时间
+(instancetype)manager;
+(PLShortVideoRecorder *)initRecorder;
+(PLSVideoMixRecorder *)initMixRecorderWith:(CGSize)videosSize;

-(void)loadMaterialResourcesWith:(NSURL *)mixURL WithRewardID:(NSInteger)rewardID;

-(CGFloat)getRecorderMaxTime;
@end
