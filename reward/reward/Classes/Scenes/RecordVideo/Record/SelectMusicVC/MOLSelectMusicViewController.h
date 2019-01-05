//
//  MOLSelectMusicViewController.h
//  reward
//
//  Created by apple on 2018/10/9.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseViewController.h"
#import "MOLMusicModel.h"



typedef void (^SelectedMusicBlock) (NSURL *musicUrl,MOLMusicModel *music);
@interface MOLSelectMusicViewController : MOLBaseViewController
@property(nonatomic,strong)SelectedMusicBlock  selectedBlock;
@end
