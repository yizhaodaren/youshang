//
//  MOLFilterCell.m
//  reward
//
//  Created by apple on 2018/9/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLFilterCell.h"

@implementation MOLFilterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.layer.cornerRadius = self.imageView.width/2;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.selectedImageView.layer.cornerRadius = self.selectedImageView.width/2;
    self.selectedImageView.clipsToBounds = YES;
    self.selectedImageView.image = [UIImage imageNamed:@"rc_slow"];
}
-(void)setIsSelected:(BOOL)isSelected{
    if (isSelected) {
        self.selectedImageView.hidden = NO;
    }else{
        self.selectedImageView.hidden = YES;
    }
    _isSelected = isSelected;
}
@end
