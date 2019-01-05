//
//  MOLShowGiftBigView.h
//  reward
//
//  Created by apple on 2018/10/9.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOLGiftModel.h"
@interface MOLShowGiftBigView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;
@property (weak, nonatomic) IBOutlet UILabel *giftNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *goldNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goldImage;

@property (nonatomic,assign)NSInteger giftNum;//礼物数量
@property (nonatomic,copy)MOLGiftModel *giftModel;//礼物图片URL
@end
