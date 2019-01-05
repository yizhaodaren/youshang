//
//  MOLExfoliatingCell.m
//  reward
//
//  Created by apple on 2018/9/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLExfoliatingCell.h"

@implementation MOLExfoliatingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLable.layer.cornerRadius = self.titleLable.width/2;
    self.titleLable.clipsToBounds = YES;
}
-(void)setIsSelected:(BOOL)isSelected{
    if (isSelected) {
        self.titleLable.backgroundColor = [UIColor whiteColor];
        self.titleLable.textColor = [UIColor blackColor];
    }else{
        self.titleLable.backgroundColor = [UIColor blackColor];
        self.titleLable.textColor = [UIColor whiteColor];
    }
    _isSelected = isSelected;
}
@end
