//
//  MOLSameMusicStoryViewController.h
//  reward
//
//  Created by apple on 2018/11/20.
//  Copyright © 2018 reward. All rights reserved.
//

#import "MOLBaseViewController.h"

@interface MOLSameMusicStoryViewController : MOLBaseViewController


@property (nonatomic,strong)dispatch_block_t stopMusicBlock;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) UICollectionView *collectionView;

-(instancetype)initWith:(NSInteger)musicID;
@end
