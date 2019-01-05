//
//  MOLMyEditImageCell.m
//  reward
//
//  Created by moli-2017 on 2018/9/14.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLMyEditImageCell.h"
#import "TZImagePickerController.h"
#import "XDImageViewController.h"

@interface MOLMyEditImageCell ()<TZImagePickerControllerDelegate>

@property (nonatomic, weak) UIImageView *iconImageView; // 头像
@property (nonatomic, weak) UIView *coverView;       // 遮罩
@property (nonatomic, weak) UIImageView *cameraImageView;  //相机图片
@property (nonatomic, weak) UILabel *titleLabel;
@end

@implementation MOLMyEditImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupMyEditImageCellUI];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - 数据
- (void)setModel:(MOLMyEditModel *)model
{
    _model = model;
    NSString *image = model.image;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:image]];
}

- (void)setFormDic:(NSDictionary *)formDic
{
    _formDic = formDic;
}

#pragma mark - 按钮点击
 - (void)button_clickEditImage
{
    // 弹出图片选择
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    
    [[[MOLGlobalManager shareGlobalManager] global_currentViewControl] presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    
    // 去编辑界面
    UIImage *image = photos.firstObject;
    XDImageViewController *vc = [[XDImageViewController alloc] init];
    vc.userImage = image;
    
    @weakify(self);
    vc.imageBlock = ^(UIImage *newImg){
        @strongify(self);
        self.iconImageView.image = newImg;
        // 压缩图片上传
        [[MOLUploadManager shareUploadManager] qiNiu_uploadImage:newImg complete:^(NSString *name) {
           
            if (name.length) {
                [self.formDic setValue:name forKey:self.model.key];
                
            }else{
                [MBProgressHUD showMessageAMoment:@"头像上传失败,请重试"];
                [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.image]];
            }
        }];
    };
    
    [[[MOLGlobalManager shareGlobalManager] global_currentViewControl] presentViewController:vc animated:NO completion:nil];
}

#pragma mark - UI
- (void)setupMyEditImageCellUI
{
    UIImageView *iconImageView = [[UIImageView alloc] init];
    _iconImageView = iconImageView;
    iconImageView.backgroundColor = [UIColor lightGrayColor];
    iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(button_clickEditImage)];
    [iconImageView addGestureRecognizer:tap];
    [self.contentView addSubview:iconImageView];
    
//    UIView *coverView = [[UIView alloc] init];
//    _coverView = coverView;
//    coverView.userInteractionEnabled = NO;
//    coverView.backgroundColor = HEX_COLOR_ALPHA(0x000000, 0.5);
//    [iconImageView addSubview:coverView];
    
    UIImageView *cameraImageView = [[UIImageView alloc] init];
    _cameraImageView = cameraImageView;
    cameraImageView.image = [UIImage imageNamed:@"mine_camera"];
    [iconImageView addSubview:cameraImageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    titleLabel.text = @"点击更换头像";
    titleLabel.textColor = HEX_COLOR_ALPHA(0xffffff, 0.4);
    titleLabel.font = MOL_REGULAR_FONT(12);
    [self.contentView addSubview:titleLabel];
}

- (void)calculatorMyEditImageCellFrame
{
    self.iconImageView.width = 84;
    self.iconImageView.height = 84;
    self.iconImageView.centerX = self.contentView.width * 0.5;
    self.iconImageView.y = 20;
    self.iconImageView.layer.cornerRadius = self.iconImageView.height * 0.5;
    self.iconImageView.clipsToBounds = YES;
    
    self.coverView.frame = self.iconImageView.bounds;
    
    self.cameraImageView.frame = self.iconImageView.bounds;
    
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX = self.iconImageView.centerX;
    self.titleLabel.y = self.iconImageView.bottom + 15;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorMyEditImageCellFrame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
