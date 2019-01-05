//
//  MOLReleaseViewController.h
//  reward
//
//  Created by apple on 2018/9/12.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PLSActionType) {
    PLSActionTypePlayer = 0,
    PLSActionTypeGif,
};
@interface MOLReleaseViewController : MOLBaseViewController

//******************************************传值****************************************//
//逻辑2
//录制页面到编辑页面传值 musicID
//裁剪页面到编辑页面传值 musicID为0
//编辑页面到发布页面传值 musicID
@property(nonatomic,assign)NSInteger currentMusicID;//音乐ID（以视频的最后一次添加音乐的ID为准）
//规则
//1相机拍摄 由录制到编辑页面的时候设置为相机 设置为1
//2相册 由选择视频后由录制页面跳转裁剪视频页面。设置为2
//3外链 由外链页面跳转裁剪页面的时候 设置为3
//4， 编辑页面到发布页面传 source
@property(nonatomic,assign)NSInteger source;//发布作品的视屏来源 //(1=相机,2=相册,3=外链)
//**********************************************************************************//
@property (strong, nonatomic) NSDictionary *settings;
@property (strong, nonatomic) NSURL *url;
@property (assign, nonatomic) PLSActionType actionType;
@property (nonatomic,strong) UIImage  *coverImage;
@end
