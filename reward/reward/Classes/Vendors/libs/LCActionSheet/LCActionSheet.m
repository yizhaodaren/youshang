//
//  Created by 刘超 on 15/4/26.
//  Copyright (c) 2015年 Leo. All rights reserved.
//
//  Email:  leoios@sina.com
//  GitHub: http://github.com/LeoiOS
//  如有问题或建议请给我发Email, 或在该项目的GitHub主页lssues我, 谢谢:)
//

#import "LCActionSheet.h"
#import <objc/runtime.h>

// 按钮高度
#define BUTTON_H 49.0f
// 屏幕尺寸
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
// 颜色
#define LCColor(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]

@interface LCActionSheet () {
    
    /** 所有按钮 */
    NSArray *_buttonTitles;
    
    /** 暗黑色的view */
    UIView *_darkView;
    
    /** 所有按钮的底部view */
    UIView *_bottomView;
    
    /** 代理 */
   __weak id<LCActionSheetDelegate> _delegate;
}

@property (nonatomic, strong) UIWindow *backWindow;


@end

static const void *kLCActionSheetCompletionBlock = &kLCActionSheetCompletionBlock;

@implementation LCActionSheet

+ (instancetype)sheetWithTitle:(NSString *)title buttonTitles:(NSArray *)titles redButtonIndex:(NSInteger)buttonIndex delegate:(id<LCActionSheetDelegate>)delegate {
    
    return [[self alloc] initWithTitle:title buttonTitles:titles redButtonIndex:buttonIndex delegate:delegate];
}

- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSArray *)titles
               redButtonIndex:(NSInteger)buttonIndex
                     delegate:(id<LCActionSheetDelegate>)delegate {
    
    if (self = [super init]) {
        
        _delegate = delegate;
        
        // 暗黑色的view
        UIView *darkView = [[UIView alloc] init];
        [darkView setAlpha:0];
        [darkView setUserInteractionEnabled:NO];
        [darkView setFrame:(CGRect){0, 0, SCREEN_SIZE}];
        [darkView setBackgroundColor:LCColor(46, 49, 50)];
        [self addSubview:darkView];
        _darkView = darkView;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        [darkView addGestureRecognizer:tap];
        
        // 所有按钮的底部view
        UIView *bottomView = [[UIView alloc] init];
        [bottomView setBackgroundColor:LCColor(233, 233, 238)];
        [self addSubview:bottomView];
        _bottomView = bottomView;
        
        if (title) {
            
            // 标题
            UILabel *label = [[UILabel alloc] init];
            [label setText:title];
            // 改动标题
            [label setTextColor:LCColor(153, 153, 153)];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setFont:[UIFont systemFontOfSize:12.0f]];
//            [label setFont:[[BHFont sharedObject] bhFont6]];
            [label setBackgroundColor:[UIColor whiteColor]];
            [label setFrame:CGRectMake(0, 0, SCREEN_SIZE.width, BUTTON_H)];
            [bottomView addSubview:label];
        }
        
        if (titles.count) {
            
            _buttonTitles = titles;
            
            for (int i = 0; i < titles.count; i++) {
                
                // 所有按钮
                UIButton *btn = [[UIButton alloc] init];
                [btn setTag:i];
                [btn setBackgroundColor:[UIColor whiteColor]];
                [btn setTitle:titles[i] forState:UIControlStateNormal];
                [[btn titleLabel] setFont:[UIFont systemFontOfSize:15.0f]];
//                [[btn titleLabel] setFont:[[BHFont sharedObject] bhFont4]];
                
                UIColor *titleColor = nil;
                if (i == buttonIndex) {
                    titleColor = HEX_COLOR(0x322200);
                    [btn setTitleColor:titleColor forState:UIControlStateNormal];
                } else {
                    [btn setTitleColor:LCColor(102, 102, 102) forState:UIControlStateNormal];
                }
                
                [btn setBackgroundImage:[UIImage imageNamed:@"bgImage_HL"] forState:UIControlStateHighlighted];
                [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
                
                CGFloat btnY = BUTTON_H * (i + (title ? 1 : 0));
                [btn setFrame:CGRectMake(0, btnY, SCREEN_SIZE.width, BUTTON_H)];
                [bottomView addSubview:btn];
            }
            
            for (int i = 0; i < titles.count; i++) {
                
                // 所有线条
                UIImageView *line = [[UIImageView alloc] init];
                [line setImage:[UIImage imageNamed:@"cellLine"]];
                [line setContentMode:UIViewContentModeCenter];
                CGFloat lineY = (i + (title ? 1 : 0)) * BUTTON_H;
                [line setFrame:CGRectMake(0, lineY, SCREEN_SIZE.width, 1.0f)];
                [bottomView addSubview:line];
            }
        }
        
        // 取消按钮
        UIButton *cancelBtn = [[UIButton alloc] init];
        [cancelBtn setTag:titles.count];
        [cancelBtn setBackgroundColor:[UIColor whiteColor]];
        
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [[cancelBtn titleLabel] setFont:[UIFont systemFontOfSize:15.0f]];
//        [[cancelBtn titleLabel] setFont:[[BHFont sharedObject] bhFont4]];
        // 改动颜色
        [cancelBtn setTitleColor:HEX_COLOR(0xFE6257) forState:UIControlStateNormal];
       // [cancelBtn setTitleColor:LCColor(51, 51, 51) forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"bgImage_HL"] forState:UIControlStateHighlighted];
        [cancelBtn addTarget:self action:@selector(didClickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        
        // 改动最后10间距
        CGFloat btnY = BUTTON_H * (titles.count + (title ? 1 : 0)) + 10.0f;
        [cancelBtn setFrame:CGRectMake(0, btnY, SCREEN_SIZE.width, BUTTON_H)];
        [bottomView addSubview:cancelBtn];
        
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, cancelBtn.bottom, SCREEN_SIZE.width, MOL_TabbarSafeBottomMargin)];
        paddingView.backgroundColor = [UIColor whiteColor];
        [bottomView addSubview:paddingView];
        
        CGFloat bottomH = (title ? BUTTON_H : 0) + BUTTON_H * titles.count + BUTTON_H + 5.0f;
        [bottomView setFrame:CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, bottomH+MOL_TabbarSafeBottomMargin)];
        
        [self setFrame:(CGRect){0, 0, SCREEN_SIZE}];
        [self.backWindow addSubview:self];
//        [self.backWindow bringSubviewToFront:self];
        
//        for (UIWindow *tempWindow in [UIApplication sharedApplication].windows)
//        {
//            if([[tempWindow description] hasPrefix:@"<UITextEffectsWindow"] == YES)
//            {
//                [tempWindow addSubview:self];
//                [tempWindow bringSubviewToFront:self];
//            }
//        }
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSArray *)titles
               redButtonIndex:(NSInteger)buttonIndex
                   completion:(void (^)(NSInteger buttonIndex, LCActionSheet *actionSheet))completion {
    objc_setAssociatedObject(self, kLCActionSheetCompletionBlock, [completion copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [self initWithTitle:title buttonTitles:titles redButtonIndex:buttonIndex delegate:nil];
}

- (UIWindow *)backWindow {
    
    if (_backWindow == nil) {
        
        _backWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        _backWindow.windowLevel       = UIWindowLevelStatusBar;
        _backWindow.windowLevel       = 10000000;   // MAXFLOAT, 自定义一个级别值
        _backWindow.backgroundColor   = [UIColor clearColor];
        _backWindow.hidden = NO;
    }
    
    return _backWindow;
}


- (void)didClickBtn:(UIButton *)btn {
    
    [self dismiss:nil];
    
    if ([_delegate respondsToSelector:@selector(actionSheet:didClickedButtonAtIndex:)]) {
        
        [_delegate actionSheet:self didClickedButtonAtIndex:btn.tag];
    }
    void (^ completion)(NSInteger buttonIndex, LCActionSheet *actionSheet) = objc_getAssociatedObject(self, kLCActionSheetCompletionBlock);
    if (completion) {
        completion(btn.tag,self);
    }
}

- (void)dismiss:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         [_darkView setAlpha:0];
                         [_darkView setUserInteractionEnabled:NO];
                         
                         CGRect frame = _bottomView.frame;
                         frame.origin.y += frame.size.height;
                         [_bottomView setFrame:frame];
                         
                     }
                     completion:^(BOOL finished) {
                         
                         _backWindow.hidden = YES;
                         
                         [self removeFromSuperview];
                     }];
}

- (void)didClickCancelBtn {
    
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         [_darkView setAlpha:0];
                         [_darkView setUserInteractionEnabled:NO];
                         
                         CGRect frame = _bottomView.frame;
                         frame.origin.y += frame.size.height;
                         [_bottomView setFrame:frame];
                         
                     }
                     completion:^(BOOL finished) {
                         
                         _backWindow.hidden = YES;
                         
                         [self removeFromSuperview];
                         
                         if ([_delegate respondsToSelector:@selector(actionSheet:didClickedButtonAtIndex:)]) {
                             
                             [_delegate actionSheet:self didClickedButtonAtIndex:_buttonTitles.count];
                         }
                         
                         void (^ completion)(NSInteger buttonIndex, LCActionSheet *actionSheet) = objc_getAssociatedObject(self, kLCActionSheetCompletionBlock);
                         if (completion) {
                             completion(_buttonTitles.count,self);
                         }
                     }];
}

- (void)show {
    
    _backWindow.hidden = NO;
    
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         [_darkView setAlpha:0.4f];
                         [_darkView setUserInteractionEnabled:YES];
                         
                         CGRect frame = _bottomView.frame;
                         frame.origin.y -= frame.size.height;
                         [_bottomView setFrame:frame];
                         
                     }
                     completion:nil];
}

@end
