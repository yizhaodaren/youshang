//
//  MOLSearchResutView.h
//  reward
//
//  Created by apple on 2018/11/17.
//  Copyright © 2018 reward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOLMusicModel.h"
typedef void (^SelectedMusicBlock) (NSURL *musicUrl,MOLMusicModel *music);
@interface MOLSearchMusicResutView : UIView
@property(nonatomic,strong)SelectedMusicBlock useMusicBlock;
-(void)getSearchNetDataWith:(NSString *)searchStr;
-(void)removeData;//清空数据
@end
