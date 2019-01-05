//
//  RecordMacro.h
//  reward
//
//  Created by apple on 2018/9/18.
//  Copyright © 2018年 reward. All rights reserved.
//

#ifndef RecordMacro_h
#define RecordMacro_h


#define kURLPrefix @"http://file.urmoli.com"//上传七牛图片和视频的域名
#define MOL_RecordMinTime 3.0f  //最小录制时间
#define MOL_RecordMaxTime ([[MOLRecordManager manager] getRecorderMaxTime]) //15.0f //最大录制时间

#define MOL_audioVolume 0.5f//录制的视频原声和背景音乐的音量

#define MOL_isClipFilerImage NO //路径使用模特还是视频文件的截图 YES为截图 NO为默认模特。也可以自己设置图片
#define MOL_BeautifyLevel 3//默认磨皮等级。012345个等级
#define MOL_BeautifyValue (MOL_BeautifyLevel/5.0)//默认磨皮value

#define MOL_DefaultFilter 2 //默认滤镜 第二位为梦幻

#endif /* RecordMacro_h */
