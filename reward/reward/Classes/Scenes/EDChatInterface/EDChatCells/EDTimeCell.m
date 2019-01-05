//
//  EDTimeCell.m
//  aletter
//
//  Created by moli-2017 on 2018/8/28.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "EDTimeCell.h"
#import "EDTimeMessageModel.h"

@interface EDTimeCell ()
@property (nonatomic, weak) UILabel *timeLabel;
@end

@implementation EDTimeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupTimeCellUI];
    }
    return self;
}

- (void)updateCellWithCellModel:(EDBaseMessageModel *)model
{
    [super updateCellWithCellModel:model];
    EDTimeMessageModel *timeM = (EDTimeMessageModel *)model;
    self.timeLabel.frame = timeM.timeLabelFrame;
    self.timeLabel.text = timeM.content;
    
}

#pragma mark - UI
- (void)setupTimeCellUI
{
    UILabel *timeLabel = [[UILabel alloc] init];
    _timeLabel = timeLabel;
    timeLabel.text = @" ";
    timeLabel.font = MOL_LIGHT_FONT(12);
    timeLabel.textColor = HEX_COLOR_ALPHA(0xffffff, 0.7);
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:timeLabel];
}

- (void)calculatorTimeCellFrame{}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorTimeCellFrame];
}
@end
