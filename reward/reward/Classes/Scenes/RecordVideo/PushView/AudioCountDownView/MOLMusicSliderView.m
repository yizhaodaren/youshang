//
//  MKMusicSliderView.m
//  reward
//
//  Created by apple on 2018/9/14.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLMusicSliderView.h"

@implementation MKMusicSliderView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    CGPoint currentTouchPoint = [touch locationInView: self];
    if(self.touchBeginBlock) {
        self.touchBeginBlock();
    }
    
    if(self.touchBlock) {
        self.touchBlock(currentTouchPoint);
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    CGPoint currentTouchPoint = [touch locationInView: self];
    if(self.touchBeginBlock) {
        self.touchBeginBlock();
    }
    
    if(self.touchBlock) {
        self.touchBlock(currentTouchPoint);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if(self.touchEndBlock) {
        self.touchEndBlock();
    }

}

@end
