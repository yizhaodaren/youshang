//
//  PLShortPlayerViewController.h
//  NiuPlayer
//
//  Created by hxiongan on 2018/3/1.
//  Copyright © 2018年 hxiongan. All rights reserved.
//

#import "PLPlayViewController.h"
#import "MOLVideoOutsideModel.h"

@interface PLShortPlayerViewController : PLPlayViewController
<
PLPlayerDelegate
>

@property (nonatomic, strong) MOLVideoOutsideModel *media;
@property (nonatomic, assign) NSInteger indexPL;

@end
