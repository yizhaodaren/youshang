//
//  JACollectionView.m
//  PageView
//
//  Created by 刘宏亮 on 2017/12/4.
//  Copyright © 2017年 刘宏亮. All rights reserved.
//

#import "JACollectionView.h"

@implementation JACollectionView

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
    {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        if([pan translationInView:self].x > 0.0f && self.contentOffset.x == 0.0f)
        {
            return NO;
        }
    }
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

@end
