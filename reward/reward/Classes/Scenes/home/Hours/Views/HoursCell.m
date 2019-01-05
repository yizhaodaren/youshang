//
//  HoursCell.m
//  reward
//
//  Created by xujin on 2018/9/19.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "HoursCell.h"
#import "RegexKitLite.h"
#import <TYAttributedLabel/TYAttributedLabel.h>
#import "HoursModel.h"
#import "STSystemHelper.h"
#import "MOLMineViewController.h"
#import "MOLOtherUserViewController.h"

@interface HoursCell()<TYAttributedLabelDelegate>
@property (nonatomic,strong)HoursModel *currentModel;
@property (nonatomic,strong)NSIndexPath *currentIndexpath;
@property (nonatomic,strong)NSString *giftUrl;

@end

@implementation HoursCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor: [UIColor clearColor]];
        self.currentModel =[HoursModel new];
        self.giftUrl =[NSString new];
    }
    return self;
}

- (void)contentCell:(HoursModel *)model indexPath:(NSIndexPath *)indexPath{
    if (!model) {
        return;
    }
    
    if (!indexPath) {
        return;
    }
    
    self.currentModel =model;
    self.currentIndexpath =indexPath;
    
    for (id views in self.contentView.subviews) {
        [views removeFromSuperview];
    }
    __weak typeof(self) wself = self;
    UIView *contentView =[UIView new];
    [self.contentView addSubview:contentView];
    [contentView setBackgroundColor:HEX_COLOR_ALPHA(0x777575,0.1)];
    [contentView.layer setMasksToBounds:YES];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself.contentView);
        make.left.mas_equalTo(wself.contentView).offset(15);
        make.right.mas_equalTo(wself.contentView).offset(-15);
        make.bottom.mas_equalTo(wself.contentView).offset(-5);
    }];
    [contentView.layer setCornerRadius: 5];
    
    UILabel *timeLable =[UILabel new];
    [contentView addSubview:timeLable];
    [timeLable setTextAlignment:NSTextAlignmentCenter];
    [timeLable setTextColor:HEX_COLOR_ALPHA(0xffffff, 0.6)];
    [timeLable setFont:MOL_REGULAR_FONT(14)];
    [timeLable setText:[NSString stringWithFormat:@"%@",model.time?model.time:@""]];
    
    
    [timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentView);
        make.left.mas_equalTo(contentView);
        make.width.mas_equalTo(55);
        make.bottom.mas_equalTo(contentView);
    }];
    
    TYAttributedLabel *label = [[TYAttributedLabel alloc]init];
    //label.highlightedLinkColor = [UIColor redColor];
    label.delegate =self;
    [label setBackgroundColor: [UIColor clearColor]];
    [contentView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentView).offset(10);
        make.bottom.mas_equalTo(contentView).offset(-10);
        make.right.mas_equalTo(contentView).offset(-15);
        make.left.mas_equalTo(timeLable.mas_right);
    }];
    
    
    NSString *text =@"";
    //dynamicType 内容类型(0=标题头1=悬赏,2=作品,3=网页链接)
    //type  内容类型1=文本,2=金币,3=用户,4=礼物
    
   // text=@"@CC官方[message_authority,26,13]发布#全新国庆活动悬赏奖金,1000000金币（跑车[00013,29,16]x10)快来发布作品领奖金吧。[Group,13,8]";

        for (HoursItemModel *itemDto in model.itemList) {
            switch (itemDto.type) {
                case 1://文本
                {
                   text =[text stringByAppendingString:itemDto.text?itemDto.text:@""];
                }
                    break;
                case 2://金币
                {
                   text = [text stringByAppendingString:itemDto.text?itemDto.text:@""];
                }
                    break;
                case 3://用户
                {
                   text = [text stringByAppendingString:itemDto.text?itemDto.text:@""];
                }
                    break;
                case 4://礼物
                {
                   text = [text stringByAppendingString:@"("];
                   text = [text stringByAppendingString:itemDto.text?itemDto.text:@""];
                   text =[text stringByAppendingString:[NSString stringWithFormat:@"[gift,20,20]"]];
                    self.giftUrl =itemDto.ext.giftThumb?itemDto.ext.giftThumb:@"";
                   text =[text stringByAppendingString:[NSString stringWithFormat:@"x%ld)",itemDto.ext.giftNum]];
            
                }
                    break;
                    
            }
        }
    text =[text stringByAppendingString:@" [Group,13,8]"];

   
    
    // 属性文本生成器
    
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
    textContainer.text = text;
    [textContainer setStrokeColor: [UIColor clearColor]];
    [textContainer setTextColor:HEX_COLOR(0xffffff)];
    [textContainer setFont: MOL_REGULAR_FONT(14)];
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    // 正则匹配图片信息
    [text enumerateStringsMatchedByRegex:@"\\[(\\w+?),(\\d+?),(\\d+?)\\]" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        if (captureCount > 3) {
            // 图片信息储存
            TYImageStorage *imageStorage = [[TYImageStorage alloc]init];
            imageStorage.cacheImageOnMemory = YES;
            imageStorage.imageAlignment =TYImageAlignmentFill;
            if ([capturedStrings[1] isEqualToString:@"gift"]) {
                imageStorage.imageURL = [NSURL URLWithString:self.giftUrl?self.giftUrl:@""];
            }else{
              imageStorage.imageName = capturedStrings[1];
            }
           
            imageStorage.range = capturedRanges[0];
            imageStorage.size = CGSizeMake([capturedStrings[2]intValue], [capturedStrings[3]intValue]);
            
            [tmpArray addObject:imageStorage];
        }
    }];
    
    // 添加图片信息数组到label
    [textContainer addTextStorageArray:tmpArray];
    
    

    for (HoursItemModel *itemDto in model.itemList) {
        switch (itemDto.type) {
            case 1://文本
            {
                NSString *color =[NSString stringWithFormat:@"0x%@",itemDto.color?itemDto.color:@""];
                
                [textContainer addLinkWithLinkData:itemDto linkColor:[STSystemHelper colorWithHexString:color] underLineStyle:kCTUnderlineStyleNone range:[text rangeOfString:itemDto.text]];
            }
                break;
            case 2://金币
            {
                NSString *color =[NSString stringWithFormat:@"0x%@",itemDto.color?itemDto.color:@""];
                
                [textContainer addLinkWithLinkData:itemDto linkColor:[STSystemHelper colorWithHexString:color] underLineStyle:kCTUnderlineStyleNone range:[text rangeOfString:itemDto.text?itemDto.text:@""]];
            }
                break;
            case 3://用户
            {
                NSString *color =[NSString stringWithFormat:@"0x%@",itemDto.color?itemDto.color:@""];
             //   NSLog(@"%@---%@",text,itemDto.text);
                [textContainer addLinkWithLinkData:itemDto linkColor:[STSystemHelper colorWithHexString:color] underLineStyle:kCTUnderlineStyleNone range:[text rangeOfString:itemDto.text]];
            }
                break;
            case 4://礼物
            {
                NSString *color =[NSString stringWithFormat:@"0x%@",itemDto.color?itemDto.color:@""];
                NSString *giftStr =@"";
                giftStr = [giftStr stringByAppendingString:@"("];
                giftStr = [giftStr stringByAppendingString:itemDto.text?itemDto.text:@""];
                giftStr =[giftStr stringByAppendingString:[NSString stringWithFormat:@"[gift,20,20]"]];
                giftStr =[giftStr stringByAppendingString:[NSString stringWithFormat:@"x%ld)",itemDto.ext.giftNum]];
                
                TYTextStorage *textStorage = [[TYTextStorage alloc]init];
                textStorage.range = [text rangeOfString:giftStr];
                textStorage.textColor = [STSystemHelper colorWithHexString:color];
                textStorage.font = MOL_MEDIUM_FONT(14);
                [textContainer addTextStorage:textStorage];
            }
                break;
                
        }
    }

    
    
 //   textContainer = [textContainer createTextContainerWithTextWidth:CGRectGetWidth(self.view.frame)];
   
    label.textContainer =textContainer;
    
    
    
    
}

- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)textStorage atPoint:(CGPoint)point{
    if ([textStorage isKindOfClass:[TYLinkTextStorage class]])
    {
        HoursItemModel *model = ((TYLinkTextStorage*)textStorage).linkData;
        if (model && [model isKindOfClass: [HoursItemModel class]] && model.type == 3) {
         //   NSLog(@"用户事件触发");
            MOLUserModel *userModel =[MOLUserModel new];
            userModel.userId =[NSString stringWithFormat:@"%ld",model.ext.userId];
            if ([[MOLGlobalManager shareGlobalManager] isUserself:userModel]) {
                MOLMineViewController *vc = [[MOLMineViewController alloc] init];
                [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
            }else{
                MOLOtherUserViewController *vc = [[MOLOtherUserViewController alloc] init];
                vc.userId = [NSString stringWithFormat:@"%ld",model.ext.userId];
                [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
            }
            
        }
    }
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
   // [_label setFrameWithOrign:CGPointMake(0, 15) Width:CGRectGetWidth(self.frame)];
    
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
