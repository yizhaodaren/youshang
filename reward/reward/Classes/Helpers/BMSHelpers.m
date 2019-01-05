//
//  BMSHelpers.m
//  reward
//
//  Created by xujin on 2018/11/6.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "BMSHelpers.h"
#import "MOLVideoOutsideModel.h"
#import "MOLMsgUserModel.h"

@implementation BMSHelpers

+ (NSInteger)getPlayerContentMode:(MOLVideoOutsideModel *)model{
    
    NSInteger renderMode = UIViewContentModeScaleAspectFill;
    
    if (!model) {
        return renderMode;
    }
    NSInteger width  = 0;
    NSInteger height = 0;
    if (model.contentType == 1) { //悬赏
        width =model.rewardVO.audioWidth;
        height =model.rewardVO.audioHeight;
    }else{ //作品
        width =model.storyVO.audioWidth;
        height =model.storyVO.audioHeight;
    }
    if (width > 0 && height > 0) {
        
        float ratio = (float) width / height;
        if (ratio > 0.8f) {
            /// 图像长边填满屏幕
            renderMode = UIViewContentModeScaleAspectFit;
        }
        else {
            /// 图像铺满屏幕
            renderMode = UIViewContentModeScaleAspectFill;
        }
        
    }
    
    return renderMode;
}


+ (NSString *)getContent:(NSString *)text userSet:(NSMutableDictionary *)dic{
    if (text && text.length) {
        NSString *textStr =text;
        NSMutableDictionary *atInfo =dic;
        NSMutableArray *contentArr =[NSMutableArray arrayWithArray:[textStr componentsSeparatedByString:@"\b"]];
        
        NSMutableArray *contentA =[NSMutableArray array];
        
        for (NSString *str in contentArr) {
            if (str.length) {//存在值
                NSMutableDictionary *contentDic =[NSMutableDictionary dictionary];
                if ([str containsString:@"@"]) {//存在@
            
                    NSString *text =str;
                    text =[text stringByReplacingOccurrencesOfString:@"@" withString:@""];
                    text =[text stringByReplacingOccurrencesOfString:@"\b" withString:@""];
                    
                    if (atInfo.count) {
                        MOLMsgUserModel *userDto = (MOLMsgUserModel *)[atInfo objectForKey:[NSString stringWithFormat:@"\b%@\b",str]];
                        if (userDto) {
                            contentDic[@"type"] =@"2";
                            contentDic[@"text"] =text;
                            contentDic[@"typeId"] =userDto.userVO.userId?userDto.userVO.userId:@"";
                            contentDic[@"color"] =@"FFD479";
                            [contentA addObject: contentDic];
                        }
                        
                    }
                    
                }else{
                    contentDic[@"type"] =@"1";
                    contentDic[@"text"] =str;
                    contentDic[@"color"] =@"ffffff";
                    [contentA addObject: contentDic];
                }
            }
            
        }
        
        
        return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:contentA options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil] encoding:NSUTF8StringEncoding];
        
    }
    
    return NSString.new;
    
}

@end
