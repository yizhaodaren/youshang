//
//  TapChangeAlbum.h
//  aletter
//
//  Created by xiaolong li on 2018/8/16.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TapChangeAlbumOption) {
    TapChangeAlbumSelectOption = 1000, //选中
    TapChangeAlbumCancelOption         //取消
};


@class TapChangeAlbum;
@protocol TapChangeAlbumDelegate <NSObject>

- (void)tapChangeAlbum:(TapChangeAlbum*)view option:(TapChangeAlbumOption)option;

@end

@interface TapChangeAlbum : UIView
@property (nonatomic,assign) id<TapChangeAlbumDelegate>delegate;

-(void)initTapChangeAlbumTitleButotn;

@end
