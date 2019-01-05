//
//  MOLEditViewController.h
//  reward
//
//  Created by apple on 2018/9/10.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface MOLEditViewController : MOLBaseViewController


//******************************************传值****************************************//
@property(nonatomic,assign)NSInteger currentMusicID;//音乐ID（以视频的最后一次添加音乐的ID为准）
@property(nonatomic,assign)NSInteger source;//发布作品的视屏来源 //(1=相机,2=相册,3=外链 4 = 合拍)
//**********************************************************************************//

@property (strong, nonatomic) NSDictionary *settings;
@property (strong, nonatomic) NSArray *filesURLArray;

@property (strong, nonatomic) AVPlayerItem *playerItem;

//从链接页面进来的
@property (assign, nonatomic) BOOL *fromLink;
@end
