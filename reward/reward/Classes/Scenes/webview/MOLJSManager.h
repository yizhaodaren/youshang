//
//  MOLJSManager.h
//  reward
//
//  Created by moli-2017 on 2018/10/10.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface MOLJSManager : NSObject

@property (nonatomic, strong) WKWebView *webView;

// 启动获取用户信息
- (void)js_startWithUser;

//v1.0.0 分享
/*
    1.分享url
    shareContent; //分享内容
    shareImg;  // 分享图片
    shareTitle;   // 分享标题
    shareUrl;   // 分享网页
 
    2.分享图片
    imageBase64; // 分享图片
 
    dataType;  // 分享类型 1，一般的url内容   2，base64图片
 
    type;  // 分享平台 0，朋友圈,  1，微信   2,qq空间  3,qq  4,微博
 */
- (void)shareActive:(NSString *)jsonString;
//v1.0.0 复制
- (void)shareWithCopyWord:(NSString *)jsonString; // 复制文字

// js 打开 app
/*
 pageType: 1. 发布作品 2.发布悬赏 3.作品详情 4.悬赏详情 5.h5
 typeId:   作品id / 悬赏id /  h5 url
 */
- (void)openAppWithPage:(NSString *)jsonString;
@end
