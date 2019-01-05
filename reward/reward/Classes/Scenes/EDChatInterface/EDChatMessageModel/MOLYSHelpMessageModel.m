//
//  MOLYSHelpMessageModel.m
//  reward
//
//  Created by moli-2017 on 2018/10/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLYSHelpMessageModel.h"
#import "MOLYSHelpCell.h"

@implementation MOLYSHelpMessageModel

- (NSString *)encodeAttachment{
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    dataDic[@"content"] = self.content;
    dataDic[@"typeId"] = self.typeId;
    dataDic[@"type"] = @(self.type);
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"type"] = @(5);
    dic[@"data"] = dataDic;
    
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
        
        // 计算文字高度
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:self.content];
        
        CGFloat maxW = 0;
        CGFloat h = 0;
        if (self.type == 1) {
            maxW = MOL_SCREEN_WIDTH - 2 * kEDCellHorizontalEdgeSpacing - 10 - 40 - 60;
            h = [text mol_getAttributedTextHeightWithMaxWith:maxW font:MOL_REGULAR_FONT(15)];
            _cellHeight = h + 2 * kEDBubbleVerticalEdgeSpacing + 2 * kEDCellVerticalEdgeSpacing;

        }else{
            maxW = MOL_SCREEN_WIDTH - 2 * kEDCellHorizontalEdgeSpacing - 10 - 40 - 60/*参加按钮宽度*/ - 10/*间距*/;
            h = [text mol_getAttributedTextHeightWithMaxWith:maxW font:MOL_REGULAR_FONT(15)];
            _cellHeight = h + 2 * kEDBubbleVerticalEdgeSpacing + 2 * kEDCellVerticalEdgeSpacing;
        }
        
        if (self.fromType == MessageFromType_me) {
            
            self.iconImageViewFrame = CGRectMake(MOL_SCREEN_WIDTH - 40 - 15, 10, 40, 40);
            
            self.bubbleImageFrame = CGRectZero;
            
            self.contentLabelFrame = CGRectZero;
            
            self.attendButtonFrame = CGRectZero;
            
        }else{
            
            self.iconImageViewFrame = CGRectMake(15, 10, 40, 40);
            
            self.bubbleImageFrame = CGRectZero;
            
            self.contentLabelFrame = CGRectMake(CGRectGetMaxX(self.iconImageViewFrame) + 10, self.iconImageViewFrame.origin.y, maxW, h);
            
            if (self.type == 1) {
                self.attendButtonFrame = CGRectMake(MOL_SCREEN_WIDTH - 15 - 60, self.iconImageViewFrame.origin.y+5, 60, 28);
            }else{
                self.attendButtonFrame = CGRectMake(MOL_SCREEN_WIDTH - 15 - 60, self.iconImageViewFrame.origin.y+5, 60, 28);
            }
        }
    }
    
    return _cellHeight;
}

- (EDBaseChatCell *)getCellWithReuseIdentifier:(NSString *)identifier
{
    return [[MOLYSHelpCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
}

- (CGFloat)getCellHeight
{
    return self.cellHeight;
}
@end
