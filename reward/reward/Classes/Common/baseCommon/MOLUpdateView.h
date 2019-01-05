//
//  MOLUpdateView.h
//  aletter
//
//  Created by moli-2017 on 2018/9/1.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOLUpdateView : UIView
- (void)showUpdateWithVersion:(NSString *)version content:(NSString *)content force:(BOOL)force;
@end
