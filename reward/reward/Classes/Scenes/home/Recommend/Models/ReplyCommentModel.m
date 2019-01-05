//
//  ReplyCommentModel.m
//  reward
//
//  Created by xujin on 2018/10/18.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "ReplyCommentModel.h"
#import "ContentsItemModel.h"

@implementation ReplyCommentModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"contents":[ContentsItemModel class]
             };
}

- (CGFloat)replyCommentHeight{
    if (_replyCommentHeight == 0) {
         NSString *reviewedText=@"";
        
        if (self.contents && self.contents.count>0) {
            
            for (ContentsItemModel *model in self.contents) {
                if (model.type == 2) { //用户
                    reviewedText =[reviewedText stringByAppendingFormat: @"@%@",model.text];
                }else{
                    reviewedText =[reviewedText stringByAppendingFormat: @"%@",model.text];
                }
            }
            
        }else{
            reviewedText =[reviewedText stringByAppendingFormat: @"@%@",self.content?self.content:@""];
        }
        
        NSMutableAttributedString *reviewed = [STSystemHelper attributedContent:reviewedText color:HEX_COLOR_ALPHA(0xffffff, 1.0) font:MOL_REGULAR_FONT(14)];
        
        CGFloat textH = [reviewed mol_getAttributedTextHeightWithMaxWith:MOL_SCREEN_WIDTH-64-12-32-15-12 font:MOL_REGULAR_FONT(14)];
        
        _replyCommentHeight +=textH;
    }
    return _replyCommentHeight;
}

@end
