//
//  TapChangeAlbum.m
//  aletter
//
//  Created by xiaolong li on 2018/8/16.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "TapChangeAlbum.h"


@interface TapChangeAlbum ()
@property (nonatomic,strong)UILabel *titleLalbe;
@property (nonatomic,strong)UIButton *titleButotn;
@property (nonatomic,assign)TapChangeAlbumOption tapChangeAlbumOption;

@end

@implementation TapChangeAlbum

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"init");
        [self addSubview:self.titleLalbe];
        [self addSubview:self.titleButotn];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self addSubview:self.titleLalbe];
//        [self addSubview:self.titleButotn];
//        [self setBackgroundColor:[UIColor redColor]];
//    }
//    return self;
//}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLalbe setFrame:CGRectMake(0, 5, self.width,17)];
    [self.titleButotn setFrame:CGRectMake(0, self.titleLalbe.origin.y+self.titleLalbe.height+2, self.width, 17)];
    

    // 还可增设间距
    CGFloat spacing = 0;
    // 图片右移
    CGSize imageSize = self.titleButotn.imageView.frame.size;
    // 文字左移
    CGSize titleSize = self.titleButotn.titleLabel.frame.size;
    
   //self.titleButotn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width-titleSize.width + spacing, 0.0, 0.0);
    
    // 文字左移
   // CGSize titleSize = self.titleButotn.titleLabel.frame.size;
    self.titleButotn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0,-(titleSize.width + imageSize.width)*2.0 - spacing);
    /* 小结: imageEdgeInsets 为'上左下右', 正值远离中心, 负值向中心聚拢. 具体以单词'inset'来记忆 */

    NSLog(@"layoutSubviews");
}

- (UILabel *)titleLalbe{
    if (!_titleLalbe) {
        _titleLalbe =[UILabel new];
        [_titleLalbe setText:@"相册"];
        [_titleLalbe setTextColor:HEX_COLOR(0x091F38)];
        //[_titleLalbe setBackgroundColor:[UIColor blueColor]];
        [_titleLalbe setTextAlignment:NSTextAlignmentCenter];
        [_titleLalbe setFont:MOL_REGULAR_FONT(18)];
    }
    return _titleLalbe;
}

- (UIButton *)titleButotn{
    if (!_titleButotn) {
        _titleButotn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_titleButotn setTitle:@"轻触更改相册 " forState:UIControlStateNormal];
        [_titleButotn setTitle:@"轻触收起相册" forState:UIControlStateSelected];
        [_titleButotn.titleLabel setFont:MOL_REGULAR_FONT(11)];
        [_titleButotn setTitleColor:HEX_COLOR(0x091F38) forState:UIControlStateNormal];
        [_titleButotn setImage:[UIImage imageNamed:@"轻触更改相册"] forState:UIControlStateNormal];
        [_titleButotn setImage:[UIImage imageNamed:@"轻触收起相册"] forState:UIControlStateSelected];
        [_titleButotn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _titleButotn;
}

//
-(void)buttonClick:(UIButton*)button
{
    
    if (button.selected) { //选中
        
        [button setSelected:NO];
        
        //取消
        
        self.tapChangeAlbumOption  =TapChangeAlbumCancelOption;
        
        
    }else{//未选中
        
        [button setSelected:YES];
        
        //选中事件
        self.tapChangeAlbumOption =TapChangeAlbumSelectOption;
        
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(tapChangeAlbum:option:)])
    {
        [_delegate tapChangeAlbum:self option:self.tapChangeAlbumOption];
        
    }
    
}

-(void)initTapChangeAlbumTitleButotn{
    [self.titleButotn setSelected:NO];
    //取消
    self.tapChangeAlbumOption  =TapChangeAlbumCancelOption;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
