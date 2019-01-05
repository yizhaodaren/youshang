//
//  EDTimeMessageModel.m
//  aletter
//
//  Created by moli-2017 on 2018/8/28.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "EDTimeMessageModel.h"
#import "EDTimeCell.h"

@implementation EDTimeMessageModel

/**
 * 用文字初始化message
 */
- (instancetype)initWithTime:(NSString *)createTime
{
    if (self = [super init]) {
        self.content = createTime;
        self.chatType = 10;
        self.createTime = createTime;
    }
    return self;
}

- (CGFloat)cellHeight
{
    if (_cellHeight == 0) {
        
        _cellHeight = 10 + 17;
        self.timeLabelFrame = CGRectMake(0, 10, MOL_SCREEN_WIDTH, 17);
    }
    
    return _cellHeight;
}

- (EDBaseChatCell *)getCellWithReuseIdentifier:(NSString *)identifier
{
    return [[EDTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
}
- (CGFloat)getCellHeight
{
    return self.cellHeight;
}
@end
