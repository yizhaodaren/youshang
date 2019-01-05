//
//  MOLStoryMessageDecoder.m
//  reward
//
//  Created by moli-2017 on 2018/9/28.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLStoryMessageDecoder.h"
#import "EDStoryMessageModel.h"

@implementation MOLStoryMessageDecoder

- (id<NIMCustomAttachment>)decodeAttachment:(NSString *)content{
    //所有的自定义消息都会走这个解码方法，如有多种自定义消息请自行做好类型判断和版本兼容。这里仅演示最简单的情况。
    id<NIMCustomAttachment> attachment;
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            NSString *rewardUserName = dict[@"rewardUserName"];
            NSString *rewardUserId = dict[@"rewardUserId"];
            NSString *rewardUserAvatar = dict[@"rewardUserAvatar"];
            NSString *storyContent = dict[@"storyContent"];
            NSString *beginTime = dict[@"beginTime"];
            NSString *finishTime = dict[@"finishTime"];
            NSString *giftImage = dict[@"giftImage"];
            NSInteger type = [dict[@"type"] integerValue];
            NSInteger goldCount = [dict[@"goldCount"] integerValue];
            NSInteger giftCount = [dict[@"giftCount"] integerValue];
            EDStoryMessageModel *myAttachment = [[EDStoryMessageModel alloc] init];
            myAttachment.rewardUserName = rewardUserName;
            myAttachment.rewardUserId = rewardUserId;
            myAttachment.rewardUserAvatar = rewardUserAvatar;
            myAttachment.storyContent = storyContent;
            myAttachment.beginTime = beginTime;
            myAttachment.finishTime = finishTime;
            myAttachment.giftImage = giftImage;
            myAttachment.type = type;
            myAttachment.goldCount = goldCount;
            myAttachment.giftCount = giftCount;
            attachment = myAttachment;
        }
    }
    return attachment;
}

/*
 @"rewardUserName":self.rewardUserName,
 @"rewardUserId":self.rewardUserId,
 @"rewardUserAvatar":self.rewardUserAvatar,
 @"storyContent":self.storyContent,
 @"beginTime":self.beginTime,
 @"finishTime":self.finishTime,
 @"type":@(self.type),
 @"goldCount":@(self.goldCount),
 @"giftCount":@(self.giftCount),
 @"giftImage":self.giftImage,
 */
@end
