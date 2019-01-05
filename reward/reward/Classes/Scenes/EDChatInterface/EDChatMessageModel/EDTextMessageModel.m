//
//  EDTextMessageModel.m
//  aletter
//
//  Created by moli-2017 on 2018/8/28.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "EDTextMessageModel.h"
#import "EDTextCell.h"

@implementation EDTextMessageModel

- (instancetype)initWithContent:(NSString *)content {
    if (self = [super init]) {
        self.content = content;
        self.chatType = 0;
    }
    return self;
}

- (EDBaseChatCell *)getCellWithReuseIdentifier:(NSString *)identifier
{
    return [[EDTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
}

- (CGFloat)cellHeight
{
    if (_cellHeight == 0) {
        
        // 计算高度
        CGFloat maxW = MOL_SCREEN_WIDTH - 2 * kEDCellHorizontalEdgeSpacing - 2 * kEDBubbleHorizontalEdgeSpacing - 40;
        CGSize maxS = CGSizeMake(maxW, MAXFLOAT);
        CGSize textS = [self.content boundingRectWithSize:maxS options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : MOL_LIGHT_FONT(kEDCellContentTitleFont)} context:nil].size;
        CGFloat h = textS.height;
        CGFloat w = textS.width;
        
        _cellHeight = h + 2 * kEDBubbleVerticalEdgeSpacing + 2 * kEDCellVerticalEdgeSpacing;  
        
        if (self.fromType == MessageFromType_me) {
            
            self.iconImageViewFrame = CGRectMake(MOL_SCREEN_WIDTH - 40 - 15, 10, 40, 40);
            
            self.bubbleImageFrame = CGRectMake(MOL_SCREEN_WIDTH - (w + 2 * kEDBubbleHorizontalEdgeSpacing) - kEDCellHorizontalEdgeSpacing - 40, 10, w + 2 * kEDBubbleHorizontalEdgeSpacing, _cellHeight - 2 * kEDCellVerticalEdgeSpacing);
            
            self.textLabelFrame = CGRectMake(kEDBubbleHorizontalEdgeSpacing, kEDBubbleVerticalEdgeSpacing, w, h);
            self.sendingIndicatorFrame = CGRectMake(self.bubbleImageFrame.origin.x - 10 - 2 * kEDCellVerticalEdgeSpacing, self.bubbleImageFrame.origin.y + (self.bubbleImageFrame.size.height * 0.5 - 20 * 0.5), 20, 20);
        }else{
            
            self.iconImageViewFrame = CGRectMake(15, 10, 40, 40);
            
            self.bubbleImageFrame = CGRectMake(kEDCellHorizontalEdgeSpacing + 40, 10, w + 2 * kEDBubbleHorizontalEdgeSpacing, _cellHeight - 2 * kEDCellVerticalEdgeSpacing);
            
            self.textLabelFrame = CGRectMake(kEDBubbleHorizontalEdgeSpacing, kEDBubbleVerticalEdgeSpacing, w, h);
            self.sendingIndicatorFrame = CGRectMake(self.bubbleImageFrame.origin.x + self.bubbleImageFrame.size.width + 10, self.bubbleImageFrame.origin.y + (self.bubbleImageFrame.size.height * 0.5 - 20 * 0.5), 20, 20);
        }
        
    }
    
    return _cellHeight;
}

- (CGFloat)getCellHeight
{
    return self.cellHeight;
}
@end
