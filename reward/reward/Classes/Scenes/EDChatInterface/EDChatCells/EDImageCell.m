//
//  EDImageCell.m
//  aletter
//
//  Created by moli-2017 on 2018/8/28.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "EDImageCell.h"
#import "EDImageMessageModel.h"

@interface EDImageCell ()
@property (nonatomic, weak) UIImageView *image_View;
@property (nonatomic, strong)EDBaseMessageModel *messgeDto;
@end

@implementation EDImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupImageCelllUI];
    }
    return self;
}

- (void)updateCellWithCellModel:(EDBaseMessageModel *)model
{
    [super updateCellWithCellModel:model];
    EDImageMessageModel *imageM = (EDImageMessageModel *)model;
    self.messgeDto =imageM;
    [self.image_View sd_setImageWithURL:[NSURL URLWithString:imageM.content]];
    self.image_View.frame = imageM.imageViewFrame;
    self.bubbleImageView.frame = model.bubbleImageFrame;
    self.iconImageView.frame = model.iconImageViewFrame;
}

#pragma mark - UI
- (void)setupImageCelllUI
{
    UIImageView *image_View = [[UIImageView alloc] init];
    _image_View = image_View;
    image_View.contentMode = UIViewContentModeScaleAspectFill;
    image_View.clipsToBounds = YES;
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleImageViewEvent:)];
    [self.bubbleImageView addGestureRecognizer:tap];
    [self.bubbleImageView setUserInteractionEnabled:YES];
    [self.bubbleImageView addSubview:image_View];
}

- (void)bubbleImageViewEvent:(UITapGestureRecognizer *)tap{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EDImageCellTap" object:self.messgeDto.content];
}

- (void)calculatorImageCellFrame{}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorImageCellFrame];
}
@end
