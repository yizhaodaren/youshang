//
//  EDStoryMessageModel.m
//  aletter
//
//  Created by moli-2017 on 2018/8/28.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "EDStoryMessageModel.h"
#import "EDStoryCell.h"

@implementation EDStoryMessageModel

MJCodingImplementation

- (NSString *)encodeAttachment{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"rewardUserName"] = self.rewardUserName;
    dic[@"rewardUserId"] = self.rewardUserId;
    dic[@"rewardUserAvatar"] = self.rewardUserAvatar;
    dic[@"storyContent"] = self.storyContent;
    dic[@"beginTime"] = self.beginTime;
    dic[@"finishTime"] = self.finishTime;
    dic[@"type"] = @(self.type);
    
    dic[@"goldCount"] = @(self.goldCount);
    dic[@"giftCount"] = @(self.giftCount);
    dic[@"giftImage"] = self.giftImage;
    
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    
    NSString *encodeString = @"";
    if (data) {
        encodeString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return encodeString;
}

- (CGFloat)cellHeight
{
    if (_cellHeight == 0) {
        
        /* 间距20 + 图片高112 + 间距10 + 倒计时18 + 间距10 + 线1 + 间距10 + 内容（计算） + 间距10 */
        
        CGFloat cardH = 0;
        CGFloat height = 0;
        if (self.type == 1) {  // 红包悬赏
            NSMutableAttributedString *str = [self getTextWitnContent:self.storyContent type:@"红包悬赏"];
            height = [str mol_getAttributedTextHeightWithMaxWith:MOL_SCREEN_ADAPTER(300) - 20 font:MOL_REGULAR_FONT(15)];
        }else{
            NSMutableAttributedString *str = [self getTextWitnContent:self.storyContent type:@"排名悬赏"];
            height = [str mol_getAttributedTextHeightWithMaxWith:MOL_SCREEN_ADAPTER(300) - 20 font:MOL_REGULAR_FONT(15)];
        }
        
        height = height > 44 ? 44 : height;
        
        cardH = 20 + 112 + 10 + 18 + 10 + 1 + 10 + height + 10;
        
        //
        _cellHeight = cardH + 45 + 2 * kEDCellVerticalEdgeSpacing;
        
        
        if (self.fromType == MessageFromType_me) {
            
            self.iconImageViewFrame = CGRectMake(MOL_SCREEN_WIDTH - 40 - 15, 10, 40, 40);
            
            self.bubbleImageFrame = CGRectZero;
            
            self.labelFrame = CGRectMake(MOL_SCREEN_WIDTH - self.iconImageViewFrame.origin.x - 10 - MOL_SCREEN_WIDTH * 0.5, self.iconImageViewFrame.origin.y + kEDBubbleVerticalEdgeSpacing, MOL_SCREEN_WIDTH * 0.5, 20);
//            self.sendingIndicatorFrame = CGRectMake(self.bubbleImageFrame.origin.x - 10 - 2 * kEDCellVerticalEdgeSpacing, self.bubbleImageFrame.origin.y + (self.bubbleImageFrame.size.height * 0.5 - 20 * 0.5), 20, 20);
            self.attendButtonFrame = CGRectZero;
            
            if (iPhone5 || iPhone4) {
                self.cardViewFrame = CGRectMake(MOL_SCREEN_WIDTH - 10 - MOL_SCREEN_ADAPTER(300), 55, MOL_SCREEN_ADAPTER(300), cardH);
            }else{
                self.cardViewFrame = CGRectMake(MOL_SCREEN_WIDTH - self.iconImageViewFrame.size.width - 10. - MOL_SCREEN_ADAPTER(300), 55, MOL_SCREEN_ADAPTER(300), cardH);
            }
            
            
        }else{
            
            self.iconImageViewFrame = CGRectMake(15, 10, 40, 40);
            
            self.bubbleImageFrame = CGRectZero;
            
            self.labelFrame = CGRectMake(CGRectGetMaxX(self.iconImageViewFrame) + 10, self.iconImageViewFrame.origin.y + kEDBubbleVerticalEdgeSpacing, MOL_SCREEN_WIDTH * 0.5, 20);
            //            self.sendingIndicatorFrame = CGRectMake(self.bubbleImageFrame.origin.x - 10 - 2 * kEDCellVerticalEdgeSpacing, self.bubbleImageFrame.origin.y + (self.bubbleImageFrame.size.height * 0.5 - 20 * 0.5), 20, 20);
            self.attendButtonFrame = CGRectMake(MOL_SCREEN_WIDTH - 15 - 60,self.iconImageViewFrame.origin.y + 5,60,28);
            
            if (iPhone4 || iPhone5) {
                
                self.cardViewFrame = CGRectMake(10, 55, MOL_SCREEN_ADAPTER(300), cardH);
            }else{
                
                self.cardViewFrame = CGRectMake(CGRectGetMaxX(self.iconImageViewFrame) + 5, 55, MOL_SCREEN_ADAPTER(300), cardH);
            }
            
        }
        
    }
    return _cellHeight;
}

/**
 * 用文字初始化message
 */
- (instancetype)initWithStory:(EDStoryMessageModel *)story
{
    if (self = [super init]) {
        
    }
    return self;
}

- (EDBaseChatCell *)getCellWithReuseIdentifier:(NSString *)identifier
{
    return [[EDStoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
}

- (CGFloat)getCellHeight
{
    return self.cellHeight;
}

- (NSMutableAttributedString *)getTextWitnContent:(NSString *)content type:(NSString *)type   // type  红包悬赏 排位悬赏
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:content];
    text.yy_color = HEX_COLOR_ALPHA(0xffffff, 0.6);
    text.yy_font = MOL_REGULAR_FONT(15);
    if (!type.length) {
        return text;
    }
    
    UIImage *image = [UIImage imageNamed:@"mine_ harmony"];
    
    if ([type isEqualToString:@"红包悬赏"]) {
        image = [UIImage imageNamed:@"packet_type"];
    }else if ([type isEqualToString:@"排名悬赏"]){
        image = [UIImage imageNamed:@"ranking_type"];
    }
    
    image = [UIImage imageWithCGImage:image.CGImage scale:MOL_SCREEN_SCALE orientation:UIImageOrientationUp];
    
    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:MOL_REGULAR_FONT(15) alignment:YYTextVerticalAlignmentCenter];
//    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@  ",type]];
//    one.yy_font = [UIFont boldSystemFontOfSize:10];
//    one.yy_color = [UIColor whiteColor];
//
//    YYTextBorder *border = [YYTextBorder new];
//    border.cornerRadius = 2;
//    border.insets = UIEdgeInsetsMake(-3, -3, -3, -3);
//    if ([type isEqualToString:@"红包悬赏"]) {
//        border.fillColor = HEX_COLOR(0xFE6257);
//    }else{
//        border.fillColor = HEX_COLOR(0x74BDF5);
//    }
//    border.lineStyle = YYTextLineStyleSingle;
//    [one yy_setTextBackgroundBorder:border range:[one.string rangeOfString:type]];
    
    [text insertAttributedString:attachText atIndex:0];
    
    return text;
}
@end
