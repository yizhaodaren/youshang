//
//  XDImageViewController.h
//  seeYouTime
//
//  Created by 形点网络 on 16/7/7.
//  Copyright © 2016年 形点网络. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDImageViewController : UIViewController

/** 用户头像*/
@property (nonatomic, strong) UIImage *userImage;

/** 刷新UIImageView图片的回调*/
@property (nonatomic, copy) void(^imageBlock)(UIImage *newImage);
@end
