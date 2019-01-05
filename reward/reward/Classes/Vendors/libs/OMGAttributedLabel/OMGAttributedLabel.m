//
//  OMGAttributedLabel.m
//  reward
//
//  Created by ACTION on 2018/11/9.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "OMGAttributedLabel.h"
#import "RegexKitLite.h"
#import "HomeCommentModel.h"
#import "MOLVideoOutsideModel.h"
#import "MOLExamineCardModel.h"


@interface OMGAttributedLabel()<TYAttributedLabelDelegate>


@end

@implementation OMGAttributedLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame: frame];
}


- (TYTextContainer *)textContainerContents:(id)model imageType:(OMGAttributedLabelImageType)imageType;{
    
    if (!model) {
        return TYTextContainer.new;
    }
    
    NSMutableArray * contentsArr =[NSMutableArray new];
    NSString *text =@"";
    
    if ([model isKindOfClass: [HomeCommentModel class]]) {
        HomeCommentModel *commentDto =(HomeCommentModel *)model;
        
        if (imageType == OMGAttributedLabelImageType_ReplyComment) {
            if (!commentDto.replyCommentVO.contents.count) {
                if (commentDto.replyCommentVO.content.length) {
                    ContentsItemModel *itemDto =[ContentsItemModel new];
                    itemDto.type =1;
                    itemDto.text =commentDto.replyCommentVO.content;
                    itemDto.color =@"ffffff";
                    [contentsArr addObject:itemDto];
                }
            }else{
                contentsArr = commentDto.replyCommentVO.contents;
            }
        }else{
            if (!commentDto.contents.count) {
                if (commentDto.content.length) {
                    ContentsItemModel *itemDto =[ContentsItemModel new];
                    itemDto.type =1;
                    itemDto.text =commentDto.content;
                    itemDto.color =@"ffffff";
                    [contentsArr addObject:itemDto];
                }
            }else{
                contentsArr = commentDto.contents;
            }
        }
        
        
        
        
    }else if ([model isKindOfClass:[MOLVideoOutsideModel class]]) {
        MOLVideoOutsideModel *dto = (MOLVideoOutsideModel *)model;
        if (dto.contentType ==1) { //悬赏
            
            if (!dto.rewardVO.contents.count) {
                if (dto.rewardVO.content.length) {
                    ContentsItemModel *itemDto =[ContentsItemModel new];
                    itemDto.type =1;
                    itemDto.text =dto.rewardVO.content;
                    itemDto.color =@"ffffff";
                    [contentsArr addObject:itemDto];
                }
            }else{
                contentsArr = dto.rewardVO.contents;
            }
            
            switch (imageType) {
                case OMGAttributedLabelImageType_Reward:
                {
                    if (dto.rewardVO.rewardType ==1) { //红包
                        text =[text stringByAppendingString:@"[packet_type,50,18]"];
                    }else{//排位
                        text =[text stringByAppendingString:@"[ranking_type,50,18]"];
                    }
                    
                }
                    break;
                    
                case OMGAttributedLabelImageType_InTune:
                {
                    if (dto.rewardVO.isJoiner) {//是合拍
                        text =[text stringByAppendingString:@"[rewardInTune,50,18]"];
                    }
                }
                    break;
                    
                case OMGAttributedLabelImageType_Common:
                {
                    if (dto.rewardVO.rewardType ==1) { //红包
                        text =[text stringByAppendingString:@"[packet_type,50,18]"];
                    }else{//排位
                        text =[text stringByAppendingString:@"[ranking_type,50,18]"];
                    }
                    
                    if (dto.rewardVO.isJoiner) {//是合拍
                        text =[text stringByAppendingString:@"[rewardInTune,50,18]"];
                    }
                    
                }
                    break;
            }

        }else{
            
            if (!dto.storyVO.rewardVO) { //普通作品
                if (!dto.storyVO.contents.count) {
                    if (dto.storyVO.content.length) {
                        ContentsItemModel *itemDto =[ContentsItemModel new];
                        itemDto.type =1;
                        itemDto.text =dto.storyVO.content;
                        itemDto.color =@"ffffff";
                        [contentsArr addObject:itemDto];
                    }
                }else{
                    contentsArr = dto.storyVO.contents;
                }
            }else{ //悬赏作品
                
                if (imageType == OMGAttributedLabelImageType_RewardWorks) {//悬赏者信息
                   
                    if (dto.storyVO.rewardVO.isJoiner) {//是合拍
                        text =[text stringByAppendingString:@"[InTune,19,18]"];
                    }
                    
                    if (!dto.storyVO.rewardVO.contents.count) {
                        if (dto.storyVO.rewardVO.content.length) {
                            ContentsItemModel *itemDto =[ContentsItemModel new];
                            itemDto.type =1;
                            itemDto.text =dto.storyVO.rewardVO.content;
                            itemDto.color =@"ffffff";
                            [contentsArr addObject:itemDto];
                        }
                    }else{
                        contentsArr = dto.storyVO.rewardVO.contents;
                    }
                }else{ //作品信息
                    if (!dto.storyVO.contents.count) {
                        if (dto.storyVO.content.length) {
                            ContentsItemModel *itemDto =[ContentsItemModel new];
                            itemDto.type =1;
                            itemDto.text =dto.storyVO.content;
                            itemDto.color =@"ffffff";
                            [contentsArr addObject:itemDto];
                        }
                    }else{
                        contentsArr = dto.storyVO.contents;
                    }
                }
                
            }

        }
        
    }
    

    if (!contentsArr.count) {
        return TYTextContainer.new;
    }

    
    //type  内容类型1=文本,2=用户
   
    for (ContentsItemModel *itemDto in contentsArr) {
        switch (itemDto.type) {
            case 1://文本
            {
                text =[text stringByAppendingString:itemDto.text?itemDto.text:@""];
            }
                break;
            case 2://用户
            {
                text = [text stringByAppendingString:[NSString stringWithFormat:@"@%@",itemDto.text?itemDto.text:@""]];
            }
                break;
        }
    }
    
    
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
   // [textContainer setStrokeColor: [UIColor orangeColor]];
    [textContainer setTextColor:self.textColor];
    [textContainer setFont:self.font];
    [textContainer setCharacterSpacing:0];
    
    [textContainer setLineBreakMode:kCTLineBreakByTruncatingTail];
    
    textContainer.text =text;
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    // 正则匹配图片信息
    [text enumerateStringsMatchedByRegex:@"\\[(\\w+?),(\\d+?),(\\d+?)\\]" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        if (captureCount > 3) {
            // 图片信息储存
            TYImageStorage *imageStorage = [[TYImageStorage alloc]init];
            imageStorage.cacheImageOnMemory = YES;
            imageStorage.imageAlignment =TYImageAlignmentFill;
            imageStorage.imageName = capturedStrings[1];
            imageStorage.range = capturedRanges[0];
            imageStorage.size = CGSizeMake([capturedStrings[2]intValue], [capturedStrings[3]intValue]);
            
            [tmpArray addObject:imageStorage];
        }
    }];
    
    // 添加图片信息数组到label
    [textContainer addTextStorageArray:tmpArray];
    
    
    
    for (ContentsItemModel *itemDto in contentsArr) {
        switch (itemDto.type) {
            case 1://文本
            {
                NSString *color =[NSString stringWithFormat:@"0x%@",itemDto.color?itemDto.color:@""];
                [textContainer addLinkWithLinkData:itemDto linkColor:[STSystemHelper colorWithHexString:color] underLineStyle:kCTUnderlineStyleNone range:[text rangeOfString:itemDto.text]];
            }
                break;
        
            case 2://用户
            {
                NSString *color =[NSString stringWithFormat:@"0x%@",itemDto.color?itemDto.color:@""];
                [textContainer addLinkWithLinkData:itemDto linkColor:[STSystemHelper colorWithHexString:color] underLineStyle:kCTUnderlineStyleNone range:[text rangeOfString:[NSString stringWithFormat:@"@%@",itemDto.text]]];
            }
                break;
                
        }
    }
    
   
    return textContainer;
    
}


//获取计算高度用的 NSMutableAttributedString WSC
+(NSMutableAttributedString *)getAttributedStr:(MOLVideoOutsideModel *)model{
    
    
    NSString *detailStr=model.rewardVO.content?model.rewardVO.content:@"";
    NSMutableAttributedString *desStr = [STSystemHelper attributedContent:[NSString stringWithFormat:@"%@%@",(model.rewardVO.isJoiner == 1)?@" ":@"",detailStr] color:HEX_COLOR_ALPHA(0xffffff, 0.8) font:MOL_REGULAR_FONT(15)];
    
    
    //插入悬赏或者红包
    YYAnimatedImageView *desImage= [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"rewardInTune"]];
    desImage.frame = CGRectMake(0, 0, 50, 18);
    
    NSMutableAttributedString *attachDes =[NSMutableAttributedString yy_attachmentStringWithContent:desImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:desImage.size alignToFont:MOL_REGULAR_FONT(15) alignment:YYTextVerticalAlignmentCenter];
    
    [desStr insertAttributedString:attachDes atIndex:0];
    
    if (model.rewardVO.isJoiner) {//是合拍 插入合拍
        YYAnimatedImageView *desImage= [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"rewardInTune"]];
        desImage.frame = CGRectMake(0, 0, 50, 18);
        
        NSMutableAttributedString *attachDes =[NSMutableAttributedString yy_attachmentStringWithContent:desImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:desImage.size alignToFont:MOL_REGULAR_FONT(15) alignment:YYTextVerticalAlignmentCenter];
        
        [desStr insertAttributedString:attachDes atIndex:0];
    }
    
    return desStr;
}

//获取计算高度用的 NSMutableAttributedString
+(NSMutableAttributedString *)getJoinerAttributedStr:(MOLExamineCardModel *)model{
    
    NSString *detailStr=model.content?model.content:@"";
    NSMutableAttributedString *desStr = [STSystemHelper attributedContent:[NSString stringWithFormat:@"%@%@",(model.isJoiner == 1)?@" ":@"",detailStr] color:HEX_COLOR_ALPHA(0xffffff, 0.8) font:MOL_REGULAR_FONT(15)];

    
    if (model.isJoiner) {//是合拍 插入合拍
        YYAnimatedImageView *desImage= [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"rewardInTune"]];
        desImage.frame = CGRectMake(0, 0, 50, 18);
        
        NSMutableAttributedString *attachDes =[NSMutableAttributedString yy_attachmentStringWithContent:desImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:desImage.size alignToFont:MOL_REGULAR_FONT(15) alignment:YYTextVerticalAlignmentCenter];
        
        [desStr insertAttributedString:attachDes atIndex:0];
    }
    
    return desStr;
}


//获取计算高度用的 NSMutableAttributedString
+(NSMutableAttributedString *)getJoinerCommonAttributedStr:(MOLVideoOutsideModel *)model{
    NSString *detailStr=@"";
    
    if (model.contentType == 1) { //悬赏
        detailStr =model.rewardVO.content?model.rewardVO.content:@"";
    }else{//作品
        detailStr =model.storyVO.content?model.storyVO.content:@"";
    }
    
    
    NSMutableAttributedString *desStr = [STSystemHelper attributedContent:[NSString stringWithFormat:@"%@%@",((model.contentType == 1) && model.rewardVO.isJoiner)?@" ":@"",detailStr] color:HEX_COLOR_ALPHA(0xffffff, 0.8) font:MOL_REGULAR_FONT(15)];
    
    if (model.contentType == 1) { //悬赏
        if (model.rewardVO.isJoiner) {//是合拍
            
            YYAnimatedImageView *desImage= [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"rewardInTune"]];
            desImage.frame = CGRectMake(0, 0, 50, 18);
            
            NSMutableAttributedString *attachDes =[NSMutableAttributedString yy_attachmentStringWithContent:desImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:desImage.size alignToFont:MOL_REGULAR_FONT(15) alignment:YYTextVerticalAlignmentCenter];
            
            [desStr insertAttributedString:attachDes atIndex:0];
        }
    }
    return desStr;
}

@end
