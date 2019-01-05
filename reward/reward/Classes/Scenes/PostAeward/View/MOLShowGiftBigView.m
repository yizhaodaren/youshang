//
//  MOLShowGiftBigView.m
//  reward
//
//  Created by apple on 2018/10/9.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLShowGiftBigView.h"

@implementation MOLShowGiftBigView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.goldNumLabel.textColor = HEX_COLOR(0xFFEC00);
    self.giftNumLabel.textColor = HEX_COLOR(0xFFEC00);
    self.backgroundColor = [UIColor clearColor];
    self.goldImage.hidden = YES;
}
-(void)setGiftNum:(NSInteger)giftNum{
    _giftNum = giftNum;
    self.giftNumLabel.text = [NSString stringWithFormat:@"x%ld",giftNum];
    if (_giftModel) {
        self.goldNumLabel.text = [NSString stringWithFormat:@"%ld",_giftNum * _giftModel.gold];
        self.goldImage.hidden = NO;
    }
}

-(void)setGiftModel:(MOLGiftModel *)giftModel{
    _giftModel = giftModel;
    [self.giftImageView sd_setImageWithURL:[NSURL URLWithString:giftModel.giftThumb]];
    if (_giftNum > 0 ) {
        self.goldNumLabel.text = [NSString stringWithFormat:@"%ld",_giftNum * giftModel.gold];
        self.goldImage.hidden = NO;
    }
}


@end
