//
//  AnimateView.h
//  ani
//
//  Created by moli-2017 on 2018/11/1.
//  Copyright © 2018 aletter-2018. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, MOLAnimateViewTYPE) {
    MOLAnimateViewTYPEe_flower,
    MOLAnimateViewTYPEe_god,
    
};
NS_ASSUME_NONNULL_BEGIN

@interface AnimateView : UIView

@property(nonatomic,assign)MOLAnimateViewTYPE animateType;
//- (void)beginAnimate;
- (void)pauseAnimate;
- (void)resumeAnimate;
- (void)stopAnimate;

- (instancetype)initWithFrame:(CGRect)frame withTpye:(MOLAnimateViewTYPE)type;
@end

NS_ASSUME_NONNULL_END
