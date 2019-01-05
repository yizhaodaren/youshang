//
//  MOLPageControl.m
//  reward
//
//  Created by apple on 2018/10/27.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLPageControl.h"

#define magrin 6    // 圆点间距
@implementation MOLPageControl
-(void)layoutSubviews{
    [super layoutSubviews];
    //计算圆点间距
    CGFloat marginX = 5 + magrin;

    //遍历subview,设置圆点frame
    for (int i=0; i<[self.subviews count]; i++) {
        UIImageView* dot = [self.subviews objectAtIndex:i];

        if (i == self.currentPage) {
                CGSize size;
                size.height = 5;
                size.width = 5;
                [dot setFrame:CGRectMake(i * marginX, dot.frame.origin.y,
                                             size.width,size.height)];
            }else{
                CGSize size;
                size.height = 3;
                size.width = 3;
                [dot setFrame:CGRectMake(i * marginX, dot.frame.origin.y,
                                             size.width,size.height)];

            }
     }
}
-(void)setCurrentPage:(NSInteger)page{
    [self setValue:[UIImage imageNamed:@"banner_white"] forKeyPath:@"_pageImage"];
    [self setValue:[UIImage imageNamed:@"banner_yellow"] forKeyPath:@"_currentPageImage"];
    [super setCurrentPage:page];


    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];

        if (subviewIndex == page){
            CGSize size;
            size.height = 5;
            size.width = 5;
            [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                         size.width,size.height)];

        }else{
            CGSize size;
            size.height = 3;
            size.width = 3;
            [subview setFrame:CGRectMake(subview.origin.x, subview.frame.origin.y,
                                         size.width,size.height)];

        }
    }
}


@end
