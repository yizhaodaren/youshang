//
//  MOLVideoOutsideModel.m
//  reward
//
//  Created by ACTION on 2018/10/10.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLVideoOutsideModel.h"
#import "OMGAttributedLabel.h"
#import <TYAttributedLabel/TYAttributedLabel.h>
@implementation MOLVideoOutsideModel
- (CGFloat)startRecordCardHeight
{
    if (_startRecordCardHeight == 0) {
        
        // 计算高度MOLRcRewardCell
        /* 间距10 + 头像40 + 间距10 + 内容（计算）+ 间距10 +礼物图片53 + 间距10 */
        CGFloat height = 20;
        NSMutableAttributedString *desStr = [OMGAttributedLabel getAttributedStr:self];
        height = [desStr mol_getThreeAttributedTextHeightWithMaxWith:MOL_SCREEN_WIDTH - 30 font:MOL_REGULAR_FONT(15)];
        _startRecordCardHeight = 20 + 40 + 10 + height + 5 + 20 + 20;
    }
    
    return _startRecordCardHeight;
}
@end
