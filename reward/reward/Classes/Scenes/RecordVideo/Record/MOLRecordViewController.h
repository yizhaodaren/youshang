//
//  MOLRecordViewController.h
//  reward
//
//  Created by apple on 2018/9/8.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOLMusicModel.h"

@interface MOLRecordViewController : MOLBaseViewController
@property(nonatomic,strong)MOLMusicModel  *originalMusicModel;
@property(nonatomic,strong)NSURL  *originalMusicUrl;
@end
