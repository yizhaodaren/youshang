//
//  MOLDIYRefreshHeader.m
//  aletter
//
//  Created by moli-2017 on 2018/8/11.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "MOLDIYRefreshHeader.h"

@implementation MOLDIYRefreshHeader

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lastUpdatedTimeLabel.hidden = YES;
        self.stateLabel.textColor = [UIColor whiteColor];
    }
    return self;
}

@end
