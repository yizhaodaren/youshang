//
//  HoursTimeCell.m
//  reward
//
//  Created by xujin on 2018/9/19.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "HoursTimeCell.h"

@implementation HoursTimeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)hoursTimeCell:(NSString *)time{
    if (!time || ![time isKindOfClass:[NSString class]] || time.length<=0) {
        return;
    }
    
    for (id views in self.contentView.subviews) {
        [views removeFromSuperview];
    }
    
    UILabel *timeLable =[UILabel new];
    [timeLable setBackgroundColor: [UIColor clearColor]];
    [timeLable setTextColor: HEX_COLOR(0xffffff)];
    [timeLable setFont: MOL_MEDIUM_FONT(18)];
    [timeLable setTextAlignment:NSTextAlignmentCenter];
    [timeLable setText: time];
    [self.contentView addSubview:timeLable];
    __weak typeof(self) wself = self;
    [timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(wself);
    }];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
