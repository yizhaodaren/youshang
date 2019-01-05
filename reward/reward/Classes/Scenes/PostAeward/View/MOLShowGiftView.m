//
//  MOLShowGiftView.m
//  reward
//
//  Created by apple on 2018/10/9.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLShowGiftView.h"
#import "MOLGiftModel.h"
@implementation MOLShowGiftView


-(void)awakeFromNib{
    
    [super awakeFromNib];
    self.goldNumLabel.textColor = HEX_COLOR(0xFFEC00);
    self.giftLeftLabel.textColor = HEX_COLOR(0xFFEC00);
    self.giftRigthLabel.textColor = HEX_COLOR(0xFFEC00);
    self.righttagLable.textColor =HEX_COLOR(0xFFEC00);
    
    MOLRewardModel *model = [MOLReleaseManager manager].currentRewardModel;
    
    self.goldNumLabel.text =[NSString stringWithFormat:@"%ld", model.gitfNum * model.gift.gold];
    self.giftLeftLabel.text = [NSString stringWithFormat:@"(%@",model.gift.giftName];
    self.giftRigthLabel.text = [NSString stringWithFormat:@"x%ld",model.gitfNum];
    [self.giftImageView sd_setImageWithURL:[NSURL URLWithString:model.gift.giftThumb]];
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
