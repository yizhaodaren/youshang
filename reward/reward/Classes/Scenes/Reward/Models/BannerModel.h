//
//  BannerModel.h
//  SuperShopping
//
//  Created by ACTION on 2017/12/4.
//  Copyright © 2017年 xiaoling li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerModel : NSObject

@property (nonatomic,copy)NSString *bannerType;//0网页 1作品ID 2.其它
@property (nonatomic,copy)NSString *image; //图片Url
@property (nonatomic,copy)NSString *typeInfo; //url or id

@end
