//
//  MOLJSManager.m
//  reward
//
//  Created by moli-2017 on 2018/10/10.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLJSManager.h"
#import "STSystemHelper.h"
#import "MOLShareManager.h"

#import "RecommendViewController.h"
#import "RewardDetailViewController.h"
#import "MOLWebViewController.h"
#import "MOLRecordViewController.h"
#import "MOLPostRewardVC.h"

@implementation MOLJSManager

#pragma mark - h5启动传值用户给h5
- (void)js_startWithUser {
    NSString *jsFun = [NSString stringWithFormat:@"APP_data('%@')",[self activityGetUserInfo]];
    [self.webView evaluateJavaScript:jsFun completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        
    }];
}

- (NSString *)activityGetUserInfo
{
    MOLUserModel *user = [MOLUserManagerInstance user_getUserInfo];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"userId"] = user.userId;
    dic[@"userName"] = user.userName;
    dic[@"userAvatar"] = user.avatar;
    dic[@"userSex"] = @(user.gender);
    dic[@"userBirthday"] = user.birthDay;
    dic[@"userAge"] = user.age;
    dic[@"userUuid"] = user.userUuid;
    dic[@"appVersion"] = [STSystemHelper getApp_version];
    dic[@"accessToken"] = user.accessToken;
    return [dic mj_JSONString];
}

//#pragma mark - JS调用 复制文字
- (void)shareWithCopyWord:(NSString *)jsonString
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = [jsonString mj_JSONObject];
        UIPasteboard *board = [UIPasteboard generalPasteboard];
        NSString *boardString = dic[@"copyString"];
        [board setString:boardString];
        if (board == nil) {
            
            [MBProgressHUD showSuccess:@"复制失败!"];
            
        }else {
            [MBProgressHUD showError:@"复制成功!"];
            
        }
    });
}

//#pragma mark - 2.6.4 分享
- (void)shareActive:(NSString *)jsonString
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSDictionary *dic = [jsonString mj_JSONObject];
        
        MOLShareModel *moldel = [MOLShareModel mj_objectWithKeyValues:dic];
        
        [[MOLShareManager share] shareWithModel:moldel];
    });
}

// js 打开 app
/*
 pageType: 1. 发布作品 2.发布悬赏 3.作品详情 4.悬赏详情 5.h5
 typeId:    作品id / 悬赏id /  h5 url
 */
- (void)openAppWithPage:(NSString *)jsonString
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSDictionary *dic = [jsonString mj_JSONObject];
        
        NSInteger pageType = [dic[@"pageType"] integerValue];
        NSString *typeId = [dic mol_jsonString:@"typeId"];
        if (pageType == 1) { // 发布作品
            
            MOLRecordViewController *vc = [[MOLRecordViewController alloc] init];
            [MOLReleaseManager manager].rewardID = 0;//悬赏ID为0 代表自发的作品没有悬赏
            @weakify(self);
            [MOLReleaseManager manager].h5ReleaseBlock = ^(NSMutableDictionary *dic) {
                NSLog(@"%@",dic);
                @strongify(self);
                NSString *str = [dic mj_JSONString];
                NSString *jsFun = [NSString stringWithFormat:@"APP_record('%@')",str];
                [self.webView evaluateJavaScript:jsFun completionHandler:^(id _Nullable item, NSError * _Nullable error) {
                    
                }];
            };
            
            [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
            
            
        }else if (pageType == 2){  // 发布悬赏
            
            MOLPostRewardVC *vc = [[MOLPostRewardVC alloc] init];
            @weakify(self);
            [MOLReleaseManager manager].h5ReleaseBlock = ^(NSMutableDictionary *dic) {
                NSLog(@"%@",dic);
                @strongify(self);
                NSString *str = [dic mj_JSONString];
                NSString *jsFun = [NSString stringWithFormat:@"APP_record('%@')",str];
                [self.webView evaluateJavaScript:jsFun completionHandler:^(id _Nullable item, NSError * _Nullable error) {
                    
                }];
            };
            
            [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
            
        }else if (pageType == 3){  // 作品详情
            RecommendViewController *vc = [[RecommendViewController alloc] init];
            PLMediaInfo *info = [[PLMediaInfo alloc] init];
            info.index = 0;
            info.rewardId = typeId;
            info.userId = @"";
            info.businessType = HomePageBusinessType_StoryDetail;
            info.pageNum =1;
            info.pageSize =MOL_REQUEST_COUNT_VEDIO;
            vc.mediaDto = info;
            
            [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
            
        }else if (pageType == 4){  // 悬赏详情
            
            RewardDetailViewController *vc =[RewardDetailViewController new];
            vc.rewardId = typeId;
            [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
            
        }else if (pageType == 5){  // h5
            MOLWebViewController *vc = [[MOLWebViewController alloc] init];
            vc.urlString = typeId;
            [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
        }
    });
}
@end
