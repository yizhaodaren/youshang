//
//  MOLMyEditInfoCell.m
//  reward
//
//  Created by moli-2017 on 2018/9/14.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLMyEditInfoCell.h"
#import "JAGrowingTextView.h"

@interface MOLMyEditInfoCell ()<JAGrowingTextViewDelegate>
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) JAGrowingTextView *textView;
@property (nonatomic, weak) UIButton *gecognizeButton;  // 手势按钮
@property (nonatomic, weak) UIView *lineView;

@property (nonatomic, strong) NSString *frontFrom;
@property (nonatomic, weak) UIDatePicker *datePicker;
@end

@implementation MOLMyEditInfoCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupMyEditInfoCellUI];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

#pragma mark - 按钮的点击
- (void)button_clickGecognizeButton
{
    if (self.model.keyboardType == MOLMyEditKeyboardType_birthday){
        
        [self chooseBirthday];
    }else if (self.model.keyboardType == MOLMyEditKeyboardType_sex){
        
        [self chooseSex];
    }
}

- (void)chooseSex
{
    [MOLAppDelegateWindow endEditing:YES];
    
    NSArray *titleButtons = @[@"男",@"女"];
    @weakify(self);
    LCActionSheet *actionS = [[LCActionSheet alloc] initWithTitle:nil buttonTitles:titleButtons redButtonIndex:-1 completion:^(NSInteger buttonIndex, LCActionSheet *actionSheet) {
        @strongify(self);
        if (buttonIndex >= titleButtons.count) {
            return;
        }
        NSString *title = titleButtons[buttonIndex];
        if ([title isEqualToString:@"男"]) {
            self.textView.text = @"男";
        }else if ([title isEqualToString:@"女"]){
            self.textView.text = @"女";
        }
        [self.formDic setValue:self.textView.text forKey:self.model.key];
    }];
    [actionS show];
}

- (void)chooseBirthday
{
    UIView *topview = [[UIView alloc] init];
    topview.backgroundColor = [UIColor whiteColor];
    topview.width = MOL_SCREEN_WIDTH;
    topview.height = 32;
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:HEX_COLOR(0x322200) forState:UIControlStateNormal];
    sureButton.titleLabel.font = MOL_MEDIUM_FONT(14);
    sureButton.backgroundColor = HEX_COLOR(0xFFEC00);
    sureButton.width = 50;
    sureButton.height = 22;
    sureButton.y = 10;
    sureButton.right = topview.width - 15;
    sureButton.layer.cornerRadius = 3;
    sureButton.clipsToBounds = YES;
    [sureButton addTarget:self action:@selector(button_clickSureButton) forControlEvents:UIControlEventTouchUpInside];
    [topview addSubview:sureButton];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.width = MOL_SCREEN_WIDTH;
    _datePicker = datePicker;
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.maximumDate = [NSDate date];
    
    [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    self.textView.inputView = datePicker;
    self.textView.textViewInputAccessoryView = topview;
}
- (void)dateChange:(UIDatePicker *)datePicker
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [fmt stringFromDate:datePicker.date];
    // 给生日文本框赋值
    self.textView.text = dateStr;
}
- (void)button_clickSureButton
{
    [MOLAppDelegateWindow endEditing:YES];
}
#pragma mark - 数据
- (void)setModel:(MOLMyEditModel *)model
{
    _model = model;
    
    self.nameLabel.text = model.title;
    
    NSMutableAttributedString *place = [[NSMutableAttributedString alloc] initWithString:model.placeholder];
    [place addAttributes:@{NSFontAttributeName : MOL_REGULAR_FONT(15), NSForegroundColorAttributeName : HEX_COLOR_ALPHA(0xffffff, 0.5)} range:[model.placeholder rangeOfString:model.placeholder]];
    self.textView.placeholderAttributedText = place;
    
    if (model.keyboardType == MOLMyEditKeyboardType_introduction) {
        self.textView.maxNumberOfLines = 3;
        self.textView.maxNumberOfWords = 40;
        self.textView.editable = YES;
        self.gecognizeButton.hidden = YES;
        self.textView.inputView = nil;
    }else if (model.keyboardType == MOLMyEditKeyboardType_id){
        self.textView.maxNumberOfLines = 1;
        self.textView.maxNumberOfWords = 16;
        self.textView.editable = NO;
        self.gecognizeButton.hidden = YES;
        self.textView.inputView = nil;
    }else if (model.keyboardType == MOLMyEditKeyboardType_birthday){
        self.textView.maxNumberOfLines = 1;
        self.textView.maxNumberOfWords = 16;
        self.textView.editable = YES;
        self.gecognizeButton.hidden = YES;
        [self chooseBirthday];
    }else if (model.keyboardType == MOLMyEditKeyboardType_sex){
        self.textView.maxNumberOfLines = 1;
        self.textView.maxNumberOfWords = 16;
        self.textView.editable = NO;
        self.gecognizeButton.hidden = NO;
        self.textView.inputView = nil;
    }else{
        self.textView.maxNumberOfLines = 1;
        self.textView.maxNumberOfWords = 16;
        self.textView.editable = YES;
        self.gecognizeButton.hidden = YES;
        self.textView.inputView = nil;
    }
}

- (void)setFormDic:(NSDictionary *)formDic
{
    _formDic = formDic;
    
    self.frontFrom = [formDic mol_jsonString:self.model.key];  // 记录上一次的值
    if (self.frontFrom.length) {
        self.textView.text = self.frontFrom;
    }
}

#pragma mark - delegate
- (void)textViewDidBeginEditing:(JAGrowingTextView *)growingTextView
{
    if (self.model.keyboardType == MOLMyEditKeyboardType_birthday) {
        NSString *birthdayStr=[self.formDic mol_jsonString:self.model.key];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
        NSDate *birthdayDate = [dateFormatter dateFromString:birthdayStr];
        if (birthdayDate) {
            self.datePicker.date = birthdayDate;
        }
    }
}
- (void)textViewDidChange:(JAGrowingTextView *)growingTextView
{
    if (!self.model) {
        return;
    }
    
    [self.formDic setValue:self.textView.text forKey:self.model.key];
    self.lineView.bottom = self.textView.bottom + 6;
}

- (BOOL)textViewShouldBeginEditing:(JAGrowingTextView *)growingTextView
{
    if (self.clickTextfieldBlock) {
        self.clickTextfieldBlock(growingTextView.frame);
    }
    
    return growingTextView.editable;
}

#pragma mark - UI
- (void)setupMyEditInfoCellUI
{
    UILabel *nameLabel = [[UILabel alloc] init];
    _nameLabel = nameLabel;
    nameLabel.text = @" ";
    nameLabel.textColor = HEX_COLOR(0xFFFFFF);
    nameLabel.font = MOL_REGULAR_FONT(15);
    [self.contentView addSubview:nameLabel];
    
    JAGrowingTextView *textView = [[JAGrowingTextView alloc] initWithFrame:CGRectZero];
    _textView = textView;
    textView.maxNumberOfLines = 1;
    textView.minNumberOfLines = 1;
    textView.font = MOL_REGULAR_FONT(15);
    textView.textColor = HEX_COLOR(0xffffff);
    textView.size = [textView intrinsicContentSize];
    textView.textViewDelegate = self;
    [self.contentView addSubview:textView];
    
    UIButton *gecognizeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _gecognizeButton = gecognizeButton;
    gecognizeButton.backgroundColor = [UIColor clearColor];
    [gecognizeButton addTarget:self action:@selector(button_clickGecognizeButton) forControlEvents:UIControlEventTouchUpInside];
    [textView addSubview:gecognizeButton];
    
    UIView *lineView = [[UIView alloc] init];
    _lineView = lineView;
    lineView.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.1);
    [self.contentView addSubview:lineView];
}

- (void)calculatorMyEditInfoCellFrame
{
    [self.nameLabel sizeToFit];
    self.nameLabel.height = 20;
    self.nameLabel.x = 15;
    self.nameLabel.y = 15;
    
    self.textView.width = self.contentView.width - 70 - 15;
    self.textView.x = 70;
    self.textView.y = 6;
    
    self.gecognizeButton.frame = self.textView.bounds;
    
    self.lineView.width = self.contentView.width - 70;
    self.lineView.height = 1;
    self.lineView.x = 70;
    self.lineView.bottom = self.textView.bottom + 6;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorMyEditInfoCellFrame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
