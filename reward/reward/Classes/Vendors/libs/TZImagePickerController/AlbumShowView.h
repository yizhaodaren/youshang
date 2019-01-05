//
//  AlbumShowView.h
//  aletter
//
//  Created by xiaolong li on 2018/8/16.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TZAlbumModel;
typedef void(^AlbumShowViewDidSelectRowAtIndexPathBlock)(NSIndexPath *indexPath,TZAlbumModel *model);

@interface AlbumShowView : UIView

@property (nonatomic,copy)AlbumShowViewDidSelectRowAtIndexPathBlock selectRowBlock;

-(void)cancelView;

-(void)setShowTableCell:(NSMutableArray *)dataArr;

@end
