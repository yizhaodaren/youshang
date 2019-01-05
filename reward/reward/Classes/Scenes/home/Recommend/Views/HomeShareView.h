//
//  HomeShareView.h
//  reward
//
//  Created by xujin on 2018/9/13.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOLVideoOutsideModel.h"

typedef NS_ENUM(NSInteger, HomeShareViewBusinessType) {
    HomeShareViewBusinessOneselfRecommendRewardType, // 自己推荐悬赏作品分享
    HomeShareViewBusinessOneselfRecommendOtherType, // 自己推荐其它作品分享
    HomeShareViewBusinessOtherRecommendType, // 非自己推荐分享
    HomeShareViewBusinessRewardType,    // 悬赏分享
    HomeShareViewBusinessAttentionType, //关注业务分享
};

typedef NS_ENUM(NSInteger, HomeShareViewType) {
    HomeShareViewWechat,             // 朋友圈
    HomeShareViewWeixin,             // 微信
    HomeShareViewMqMzone,            // QQ空间
    HomeShareViewQQ,                 // QQ
    HomeShareViewSinaweibo,          // 微博
    HomeShareViewReport,             // 举报
    HomeShareViewCopyUrl,            // 复制链接
    HomeShareViewSave,               // 保存本地
    HomeShareViewUnLike,             // 不感兴趣
    HomeShareViewCancel,             // 取消
    HomeShareViewDelete,             // 删除
    HomeShareViewInTune,             // 合拍
};
@protocol HomeShareViewDelegate<NSObject>
- (void)homeShareView:(MOLVideoOutsideModel *)model businessType:(HomeShareViewBusinessType)businessType type:(HomeShareViewType)shareType;
@end

@interface HomeShareView : UIView
@property (nonatomic,assign)HomeShareViewBusinessType currentBusinessType;
@property (nonatomic,strong)MOLVideoOutsideModel *dto;

@property (nonatomic,weak) id<HomeShareViewDelegate>delegate;

- (void)contentIcon:(NSArray *)_iconArr;

@end
