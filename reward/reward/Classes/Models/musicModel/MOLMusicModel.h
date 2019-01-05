//
//  MOLMusicModel.h
//  reward
//
//  Created by apple on 2018/10/10.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseModel.h"
#import "MOLShareModel.h"
#import "MOLLightVideoModel.h"
@interface MOLMusicModel : MOLBaseModel
@property (nonatomic, assign) NSInteger musicId;
@property (nonatomic, strong) NSString *name; //名称
@property (nonatomic, strong) NSString *author;  //作者
@property (nonatomic, strong) NSString *time;  //作者
@property (nonatomic, strong) NSString *thumb;  //图片链接
@property (nonatomic, strong) NSString *url;  //音乐链接
@property (nonatomic, assign) NSInteger isCollect;//是否收藏

@property (nonatomic, assign) NSInteger downloadCount;  //
@property (nonatomic, assign) NSInteger deleted;  //
@property (nonatomic, assign) NSInteger categoryId;  //
@property (nonatomic, assign) NSInteger storyCount;//视频数量

@property (nonatomic, strong) MOLShareModel *shareMsgVO; //分享
@property (nonatomic, strong) NSMutableArray <MOLLightVideoModel *>*storyList;  // 视频vo 的 list
@end
