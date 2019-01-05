//
//  MOLShareManager.m
//  aletter
//
//  Created by 徐天牧 on 2018/9/1.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "MOLShareManager.h"
#import <UMShare/UMShare.h>
#import "MBProgressHUD+MJ.h"
@implementation MOLShareManager
+(instancetype)share{
    
    static MOLShareManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MOLShareManager alloc] init];
        
    });
    return  manager;
}

-(void)shareWithModel:(MOLShareModel *)model{
    
    UMSocialPlatformType type = UMSocialPlatformType_QQ;
    if ([model.type isEqualToString:@"3"]) {  // 1
        type = UMSocialPlatformType_QQ;
    }else if ([model.type isEqualToString:@"2"]){  // 2
         type = UMSocialPlatformType_Qzone;
    }else if ([model.type isEqualToString:@"4"]){  // 3
        type = UMSocialPlatformType_Sina;
    }else if ([model.type isEqualToString:@"1"]){   // 4
        type = UMSocialPlatformType_WechatSession;
    }else if ([model.type isEqualToString:@"0"]){   // 5
        type = UMSocialPlatformType_WechatTimeLine;
    }
    
    if (model.dataType.integerValue == 1) {
        //分享网页
        [self shareWebPageToPlatformType:type WithModel:model];
    }else if (model.dataType.integerValue == 2){
        
        //分享图片
        [self shareImageToPlatformType:type WithModel:model];
    }
    
}



// v 1.0.0分享网页
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType WithModel:(MOLShareModel *)model
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:model.shareTitle descr:model.shareContent thumImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.shareImg]]]];
    //设置网页地址
    shareObject.webpageUrl = model.shareUrl;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
            
            NSLog(@"%@",error.userInfo[@"message"]);
             [MBProgressHUD showSuccess:error.userInfo[@"message"]];
            
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}


//友盟分享图片
- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType WithModel:(MOLShareModel *)model
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图

    NSURL *url  =[NSURL URLWithString:model.imageBase64];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    UIImage *image = [UIImage imageWithData:data];
    
    NSData *data1 = [image mol_compressWithLengthLimit:32.0 * 1024.0];
    
    [shareObject setShareImage:data1];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}
//
////分享图文（支持新浪微博）
//- (void)shareImageAndTextToPlatformType:(UMSocialPlatformType)platformType
//{
//    //创建分享消息对象
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//
//    //设置文本
//    messageObject.text = @"社会化组件UShare将各大社交平台接入您的应用，快速武装App。";
//
//    //创建图片内容对象
//    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
//    //如果有缩略图，则设置缩略图
//    shareObject.thumbImage = [UIImage imageNamed:@"icon"];
//    [shareObject setShareImage:@"https://www.umeng.com/img/index/demo/1104.4b2f7dfe614bea70eea4c6071c72d7f5.jpg"];
//
//    //分享消息对象设置分享内容对象
//    messageObject.shareObject = shareObject;
//
//    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//        if (error) {
//            NSLog(@"************Share fail with error %@*********",error);
//        }else{
//            NSLog(@"response data is %@",data);
//        }
//    }];
//}
@end
