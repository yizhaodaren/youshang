//
//  MKMusicSliderView.h
//  reward
//
//  Created by apple on 2018/9/14.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TouchBlock) (CGPoint point);
@interface MKMusicSliderView : UIView

@property(strong,nonatomic)TouchBlock touchBlock;

@property (strong,nonatomic)dispatch_block_t touchBeginBlock;
@property (strong,nonatomic)dispatch_block_t touchEndBlock;


@end
