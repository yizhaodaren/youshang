//
//  HoursModel.m
//  reward
//
//  Created by xujin on 2018/10/22.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "HoursModel.h"
#import "HoursItemModel.h"

@implementation HoursModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"itemList":[HoursItemModel class]
             };
}



- (CGFloat)hourscellHeight
{
    if (_hourscellHeight == 0) {
        NSString *text =@"";
        // 上间距 10 + 内容高度 textH + 下间距 10 + 间隙5
        for (HoursItemModel *itemDto in _itemList) {
            switch (itemDto.type) {
                case 1://文本
                {
                    text =[text stringByAppendingString:itemDto.text?itemDto.text:@""];
                }
                    break;
                case 2://金币
                {
                    text = [text stringByAppendingString:itemDto.text?itemDto.text:@""];
                }
                    break;
                case 3://用户
                {
                    text = [text stringByAppendingString:itemDto.text?itemDto.text:@""];
                }
                    break;
                case 4://礼物
                {
                    text = [text stringByAppendingString:@"("];
                    text = [text stringByAppendingString:itemDto.text?itemDto.text:@""];
                    text =[text stringByAppendingString:[NSString stringWithFormat:@"[gift]"]];
                    //self.giftUrl =itemDto.ext.giftThumb?itemDto.ext.giftThumb:@"";
                    text =[text stringByAppendingString:[NSString stringWithFormat:@"X%ld)",itemDto.ext.giftNum]];
                    
                }
                    break;
                    
            }
        }
        text =[text stringByAppendingString:@"[Group]"];
        
        // 计算文字高度
        NSMutableAttributedString *str = [self examinePacketList_getTextWitnContent:text];
        CGFloat textH = [str mol_getAttributedTextHeightWithMaxWith:MOL_SCREEN_WIDTH - 15 * 2-55-26 font:MOL_REGULAR_FONT(14)];
        
        
        _hourscellHeight = 10 + textH + 10 + 5;
        
        
    }
    
    return _hourscellHeight;
}

- (NSMutableAttributedString *)examinePacketList_getTextWitnContent:(NSString *)content   // 计算高度的地方也要改
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:content];
    text.yy_color = HEX_COLOR_ALPHA(0xffffff, 1);
    text.yy_font = MOL_REGULAR_FONT(14);
    return text;
}


@end
