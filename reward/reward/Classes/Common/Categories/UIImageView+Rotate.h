//
//  UIImageView+Rotate.h
//  reward
//
//  Created by xujin on 2018/10/11.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (Rotate)
- (void)startRotating;

- (void)stopRotating;

- (void)resumeRotate;
@end

NS_ASSUME_NONNULL_END
