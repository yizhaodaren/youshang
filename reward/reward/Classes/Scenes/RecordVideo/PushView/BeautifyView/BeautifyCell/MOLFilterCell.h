//
//  MOLFilterCell.h
//  reward
//
//  Created by apple on 2018/9/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOLFilterCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbale;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property(assign,nonatomic)BOOL isSelected;
@end
