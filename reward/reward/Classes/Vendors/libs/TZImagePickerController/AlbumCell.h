//
//  AlbumCell.h
//  aletter
//
//  Created by xiaolong li on 2018/8/16.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TZAlbumModel;
@interface AlbumCell : UITableViewCell

-(void)setAlbumCellViewContentBy:(TZAlbumModel*)model indexPath:(NSIndexPath *)indexPath;

@end
