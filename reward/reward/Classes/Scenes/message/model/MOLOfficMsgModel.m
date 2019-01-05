//
//  MOLOfficMsgModel.m
//  reward
//
//  Created by moli-2017 on 2018/9/21.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLOfficMsgModel.h"

@implementation MOLOfficMsgModel

- (CGFloat)cellHeight
{
    if (_cellHeight == 0) {
        
        CGFloat maxW = MOL_SCREEN_WIDTH - 65 - 15;
        if (self.type == 1) {
            maxW = MOL_SCREEN_WIDTH - 65 - 85;
        }
        
        CGFloat h = [self.messageBody mol_getTextHeightWithMaxWith:maxW font:MOL_REGULAR_FONT(15)];
        
        _cellHeight = 38 + h + 27;
    }
    
    return _cellHeight;
}

@end
