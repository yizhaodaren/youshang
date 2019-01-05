//
//  MOLMyLikeViewController.h
//  reward
//
//  Created by moli-2017 on 2018/9/12.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseViewController.h"

@interface MOLMyLikeViewController : MOLBaseViewController
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) BOOL showNav;
- (void)getUserLike;
@end
