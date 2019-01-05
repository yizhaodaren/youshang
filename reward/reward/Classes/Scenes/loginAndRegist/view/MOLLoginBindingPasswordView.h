//
//  MOLLoginBindingPasswordView.h
//  reward
//
//  Created by moli-2017 on 2018/9/21.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOLLoginBindingPasswordView : UIView
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, weak) UITextField *codeTextField;
@property (nonatomic, weak) UITextField *pswTextField;


@property (nonatomic, weak) UIButton *codeButton;
@property (nonatomic, weak) UIButton *nextButton;
@end
