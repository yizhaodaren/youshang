//
//  MOGiftCell.m
//  reward
//
//  Created by apple on 2018/9/27.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLGiftCell.h"
#import "UIImageView+WebCache.h"
@interface MOLGiftCell()

@property(nonatomic,strong) UIView *conView;

@property(nonatomic,strong)UIImageView *giftImageView;
@property(nonatomic,strong)UILabel *giftNameLable;
@property(nonatomic,strong)UILabel *giftNumLable;


@end

@implementation MOLGiftCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    [self addSubview:self.conView];
    [self addSubview:self.giftImageView];
    [self addSubview:self.giftNameLable];
    [self addSubview:self.giftNumLable];
}
-(void)setModel:(MOLGiftModel *)model{
    if (!_model) {
        _model = model;
    }
        _giftNumLable.text =[NSString stringWithFormat:@"%ld钻石",model.price];
       [_giftImageView sd_setImageWithURL:[NSURL URLWithString:model.giftThumb]];
        _giftNameLable.text = model.giftName;
}


-(UIView *)conView{
    if (!_conView) {
        _conView  = [[UIView alloc] initWithFrame:CGRectMake(1, 1, self.width -2, self.height - 2)];
        _conView.backgroundColor = RGB_COLOR(29, 29, 29);
    }
    return _conView;
}
-(UIImageView *)giftImageView{
    if (!_giftImageView) {
        _giftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width/2, self.width/2)];
        _giftImageView.centerX = self.width/2;
        _giftImageView.centerY = (self.height - (5 + 17 + 17 + 1 + 1))/2;
        
    }
    return _giftImageView;
}
-(UILabel *)giftNameLable{
    if (!_giftNameLable) {
        _giftNameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, self.giftImageView.bottom + 5, self.width, 17)];
        _giftNameLable.centerX = self.width/2;
        _giftNameLable.textAlignment = NSTextAlignmentCenter;
        _giftNameLable.textColor = HEX_COLOR_ALPHA(0xFFFFFF, 1);
        _giftNameLable.font = [UIFont systemFontOfSize:12];
        _giftNameLable.text =@"礼物";
    }
    return _giftNameLable;
}
-(UILabel *)giftNumLable{
    if (!_giftNumLable) {
        _giftNumLable = [[UILabel alloc] initWithFrame:CGRectMake(0, self.giftNameLable.bottom, self.width, 17)];
        _giftNumLable.centerX = self.width/2;
        _giftNumLable.textAlignment = NSTextAlignmentCenter;
        _giftNumLable.textColor = HEX_COLOR_ALPHA(0xFFFFFF, 0.6);
        _giftNumLable.font = [UIFont systemFontOfSize:12];
        _giftNumLable.text =[NSString stringWithFormat:@"%ld钻石石",self.model.price];
    }
    return _giftNumLable;
}
@end
