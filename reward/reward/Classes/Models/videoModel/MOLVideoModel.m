//
//  MOLVideoModel.m
//  reward
//
//  Created by moli-2017 on 2018/9/19.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLVideoModel.h"

/*
    MOL_SCREEN_ADAPTER(242);
    MOL_SCREEN_ADAPTER(430);  视频最大高度
 */

@implementation MOLVideoModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"contents":[ContentsItemModel class]
             };
}

- (CGFloat)scaleVideoH
{
    return MOL_SCREEN_ADAPTER(430);
}

- (CGFloat)scaleVideoW
{
    return MOL_SCREEN_ADAPTER(242);
}

- (CGFloat)cellHeight_examinePackted
{
    if (_cellHeight_examinePackted == 0) {
        
        // 间距 25 + 头像 40 + 间距 10 + 文字（计算） + 间距 10 + 视频（计算）+ 间距 10 + 时间 20 + 间距 20 + 按钮 40 + 间距 20
        
        // 计算文字高度
        NSMutableAttributedString *str = [self examinePacketList_getTextWitnContent:self.content];
        CGFloat textH = [str mol_getAttributedTextHeightWithMaxWith:MOL_SCREEN_WIDTH - 15 * 2 font:MOL_REGULAR_FONT(15)];
        
        // 视频高度
        CGFloat videoH = 0;
        
        CGFloat maxW = MOL_SCREEN_WIDTH - 15;
        CGFloat maxH = MOL_SCREEN_ADAPTER(430);
        CGFloat scaleW = MOL_SCREEN_ADAPTER(self.scaleVideoW);
        CGFloat scaleH = MOL_SCREEN_ADAPTER(self.scaleVideoH);
        
        if (scaleW > maxW) {  // 判断是不是超过最大的宽度
            // 计算高度
            videoH = maxW * self.scaleVideoH / self.scaleVideoW;
            self.scaleVideoW = maxW;
            self.scaleVideoH = videoH;
        }else{
            self.scaleVideoW = scaleW;
            
            if (scaleH > maxH) {
                videoH = maxH;
                self.scaleVideoH = videoH;
            }else{
                videoH = scaleH;
                self.scaleVideoH = videoH;
            }
        }
        
        _cellHeight_examinePackted = 25 + 40 + 10 + textH + 10 + videoH + 10 + 20 + 20 + 40 + 20;

    }
    
    return _cellHeight_examinePackted;
}

- (NSMutableAttributedString *)examinePacketList_getTextWitnContent:(NSString *)content   // 计算高度的地方也要改
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:content];
    text.yy_color = HEX_COLOR_ALPHA(0xffffff, 0.6);
    text.yy_font = MOL_REGULAR_FONT(15);
    return text;
}


@end
