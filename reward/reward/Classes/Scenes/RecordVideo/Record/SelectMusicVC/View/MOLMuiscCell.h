//
//  MOLMuiscCell.h
//  reward
//
//  Created by apple on 2018/10/9.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOLMusicModel.h"
@interface MOLMuiscCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *musicTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicAuthorLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;

@property (nonatomic,strong)MOLMusicModel *musciModel;
@end
