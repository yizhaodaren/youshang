//
//  UIImage+MOLImageExtention.h
//  aletter
//
//  Created by moli-2017 on 2018/7/30.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MOLImageExtention)
-(NSData *)mol_compressWithLengthLimit:(NSUInteger)maxLength;
+ (UIImage *)imageWithColor:(UIColor*) color;
@end
