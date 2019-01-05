//
//  MOLMuiscCell.m
//  reward
//
//  Created by apple on 2018/10/9.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLMuiscCell.h"

@implementation MOLMuiscCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    [self.collectBtn addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];

  
}
-(void)setMusciModel:(MOLMusicModel *)musciModel{
    _musciModel = musciModel;
    self.musicTitleLabel.text = musciModel.name;
    self.musicAuthorLabel.text = musciModel.author;
    self.musicTimeLabel.text = musciModel.time;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:musciModel.thumb]];
    self.collectBtn.selected = (musciModel.isCollect == 1) ? YES : NO;
}
-(void)collectAction:(UIButton *)sender{
    
    if (sender.selected) {
        sender.selected = NO;
         [MBProgressHUD showMessageAMoment:@"取消收藏成功!"];
    }else{
        sender.selected = YES;
        [MBProgressHUD showMessageAMoment:@"收藏成功!"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
