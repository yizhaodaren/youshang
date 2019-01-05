//
//  ColorMacro.h
//  reward
//
//  Created by apple on 2018/9/10.
//  Copyright © 2018年 reward. All rights reserved.
//

#ifndef ColorMacro_h
#define ColorMacro_h


//****************************** 颜色 ***************************** //
// 十六进制颜色值 使用：HEX_COLOR(0xf8f8f8)
#define HEX_COLOR_ALPHA(_HEX_,a) [UIColor colorWithRed:((float)((_HEX_ & 0xFF0000) >> 16))/255.0 green:((float)((_HEX_ & 0xFF00) >> 8))/255.0 blue:((float)(_HEX_ & 0xFF))/255.0 alpha:a]

#define HEX_COLOR(_HEX_) HEX_COLOR_ALPHA(_HEX_, 1.0)

#define RGB_COLOR_ALPHA(r, g, b, a) [UIColor colorWithRed:(CGFloat)r/255.0f green:(CGFloat)g/255.0f blue:(CGFloat)b/255.0f alpha:a]
#define RGB_COLOR(r, g, b) RGB_COLOR_ALPHA(r, g, b, 1.0)

#endif /* ColorMacro_h */
