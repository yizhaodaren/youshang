//
//  AlbumCell.m
//  aletter
//
//  Created by xiaolong li on 2018/8/16.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "AlbumCell.h"
#import "TZAssetModel.h"
#import "TZImageManager.h"
@interface AlbumCell()

@property (nonatomic,strong) UIView *backGroundView;
@property (nonatomic,strong) NSIndexPath *indexPath;

@end

@implementation AlbumCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.backGroundView];
        [_backGroundView setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 56+20)];
        
    }
    return self;
}

-(void)setAlbumCellViewContentBy:(TZAlbumModel*)model indexPath:(NSIndexPath *)indexPath{
    
    self.indexPath =indexPath;
    for (id views in _backGroundView.subviews) {
        [views removeFromSuperview];
    }
    
    
    TZAlbumModel *albumModel =[TZAlbumModel new];
    albumModel =model;
    
    UIImageView *iconImg;
   // NSURL *imageUrl;
   // NSString *imgURL;
    
   // imgURL=goodsDto.cover;
   // imageUrl = [NSURL URLWithString:imgURL];
    iconImg=[[UIImageView alloc] init];
    [iconImg setUserInteractionEnabled:YES];
    [iconImg setFrame:CGRectMake(20, 0,56, 56)];
    
    [[TZImageManager manager] getPostImageWithAlbumModel:model completion:^(UIImage *postImage) {
        iconImg.image = postImage;
    }];
    [_backGroundView addSubview:iconImg];
    
    
    
    UILabel *titleLable =[UILabel new];
    [titleLable setTextColor:HEX_COLOR(0x091F38)];
    [titleLable setFont:MOL_REGULAR_FONT(16)];
    [titleLable setText: albumModel.name];
    [titleLable setFrame:CGRectMake(iconImg.origin.x+iconImg.frame.size.width+15,iconImg.origin.y+3,[titleLable mj_textWith], 22)];
    [_backGroundView addSubview:titleLable];
    
    
    UILabel *countLable =[UILabel new];
    [countLable setTextColor:HEX_COLOR(0x091F38)];
    [countLable setFont:MOL_LIGHT_FONT(14)];
    [countLable setText:[NSString stringWithFormat:@"%ld",albumModel.count?albumModel.count:0]];
    [countLable setFrame:CGRectMake(titleLable.origin.x,titleLable.origin.y+titleLable.height+5  ,[countLable mj_textWith], 20)];
    [_backGroundView addSubview:countLable];
   
}



- (UIView *)backGroundView{
    
    if (!_backGroundView) {
        _backGroundView =[UIView new];
        [_backGroundView setBackgroundColor: [UIColor whiteColor]];
    }
    
    return _backGroundView;
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
