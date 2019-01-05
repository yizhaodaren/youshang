//
//  EDInputView.h
//  aletter
//
//  Created by moli-2017 on 2018/8/30.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EDInputViewDelegate <NSObject>
- (void)input_sendTextMessage:(NSString *)message;  // 发送文本
- (void)input_sendImageMessage:(UIImage *)message;  // 发送图片
@end

@interface EDInputView : UIView

@property (nonatomic, weak) id <EDInputViewDelegate> delegate;
@property (nonatomic, copy) NSString *placeholder;
- (void)inputResetText;
- (void)inputRegist;
- (void)inputBecomeFirstResponse;
@end
