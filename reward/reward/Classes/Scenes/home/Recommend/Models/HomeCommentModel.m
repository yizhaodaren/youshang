//
//  HomeCommentModel.m
//  reward
//
//  Created by xujin on 2018/9/22.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "HomeCommentModel.h"

@implementation HomeCommentModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"contents":[ContentsItemModel class]
             };
}

- (CGFloat)commentHeight{
    if (_commentHeight == 0) {
        NSString *detailStr=@"";
        if (self.contents && self.contents.count>0) {
        
            for (ContentsItemModel *dto in self.contents) {
                if (dto.type == 2) { //用户
                    detailStr =[detailStr stringByAppendingFormat: @"@%@",dto.text];
                }else{
                    detailStr =[detailStr stringByAppendingFormat: @"%@",dto.text];
                }
            }
            
            
        }else{
            detailStr =[detailStr stringByAppendingFormat: @"%@",self.content?self.content:@""];
        }
        NSMutableAttributedString *desStr = [STSystemHelper attributedContent:detailStr color:HEX_COLOR_ALPHA(0xffffff, 1.0) font:MOL_REGULAR_FONT(14)];
        
        CGFloat textH = [desStr mol_getAttributedTextHeightWithMaxWith:MOL_SCREEN_WIDTH-64-12-32-15 font:MOL_REGULAR_FONT(14)];
        
        _commentHeight +=textH;
    }
    return _commentHeight;
}

- (CGFloat)cellHeight{
    if (_cellHeight ==0) {
        _cellHeight =12+12+1+18;  //顶部间距+底部间距+线高+用户名
        NSString *detailStr=@"";
        
        if (self.contents && self.contents.count>0) {
            
            for (ContentsItemModel *dto in self.contents) {
                if (dto.type == 2) { //用户
                   detailStr =[detailStr stringByAppendingFormat: @"@%@",dto.text];
                }else{
                   detailStr =[detailStr stringByAppendingFormat: @"%@",dto.text];
                }
            }
            
           
        }else{
            detailStr =[detailStr stringByAppendingFormat: @"%@",self.content];
        }
        NSMutableAttributedString *desStr = [STSystemHelper attributedContent:detailStr color:HEX_COLOR_ALPHA(0xffffff, 1.0) font:MOL_REGULAR_FONT(14)];
        
        CGFloat textH = [desStr mol_getAttributedTextHeightWithMaxWith:MOL_SCREEN_WIDTH-64-12-32-15 font:MOL_REGULAR_FONT(14)];
        
        _cellHeight +=textH;
        
        if (self.replyCommentVO) { //存在被评论
            _cellHeight +=10+17+3+10;
            
            /////////////////
            NSString *reviewedText=@"";
            
            if (self.replyCommentVO.contents && self.replyCommentVO.contents.count>0) {
                
                for (ContentsItemModel *model in self.replyCommentVO.contents) {
                    if (model.type == 2) { //用户
                        reviewedText =[reviewedText stringByAppendingFormat: @"@%@",model.text];
                    }else{
                        reviewedText =[reviewedText stringByAppendingFormat: @"%@",model.text];
                    }
                }
                
            }else{
                reviewedText =[reviewedText stringByAppendingFormat: @"%@",self.replyCommentVO.content];
            }
            
            NSMutableAttributedString *reviewed = [STSystemHelper attributedContent:reviewedText color:HEX_COLOR_ALPHA(0xffffff, 1.0) font:MOL_REGULAR_FONT(14)];
            
            CGFloat textH = [reviewed mol_getAttributedTextHeightWithMaxWith:MOL_SCREEN_WIDTH-64-12-32-15-12 font:MOL_REGULAR_FONT(14)];
            
            _cellHeight +=textH;
            
        }
    }
    
    return _cellHeight;
}

@end
