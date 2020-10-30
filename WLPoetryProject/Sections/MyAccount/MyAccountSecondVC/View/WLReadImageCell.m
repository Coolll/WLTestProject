//
//  WLSettingCell.m
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/6/16.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLReadImageCell.h"
@interface WLReadImageCell()

/**
 *  视图高度
 **/
@property (nonatomic,assign) CGFloat viewHeight;

/**
 *  分割线
 **/
@property (nonatomic, strong) UIImageView *lineView;
/**
 *  左右间距
 **/
@property (nonatomic,assign) CGFloat space;
/**
 *  开关
 **/
@property (nonatomic,strong) UISwitch *rightSwitch;
/**
 *  回调
 **/
@property (nonatomic,copy) ReadImageEffectBlock effectBlock;

@end
@implementation WLReadImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.viewHeight = 50;
        self.space = 22;
    }
    return self;
}

- (void)loadCustomView
{

    self.rightArrow.image = [UIImage imageNamed:@"settingArrow"];

    self.lineView.image = [UIImage imageNamed:@"lineImage"];
    
}

- (void)setShowLine:(BOOL)showLine
{
    _showLine = showLine;
    if (!showLine) {
        self.lineView.hidden = YES;
    }else{
        self.lineView.hidden = NO;
    }
}
- (void)updateWithSwitchBlock:(ReadImageEffectBlock)block{
    if (block) {
        self.effectBlock = block;
    }
}

- (void)setNeedSwitch:(BOOL)needSwitch{
    _needSwitch = needSwitch;
    if (needSwitch) {
        self.rightSwitch.backgroundColor = [UIColor whiteColor];
        self.rightArrow.hidden = YES;
    }else{
        self.rightArrow.hidden = NO;
    }
}
- (void)setSwitchOpen:(BOOL)switchOpen{
    _switchOpen = switchOpen;
    if (switchOpen) {
        self.rightSwitch.on = YES;
    }
}
- (void)setTitleString:(NSString *)titleString
{
    _titleString = titleString;
    
    if (self.titleLabel) {
        self.titleLabel.text = titleString;
    }
}

- (void)openAction:(UISwitch*)sender{
    if (sender.isOn) {
        NSLog(@"打开");
        if (self.effectBlock) {
            self.effectBlock(YES);
        }
    }else{
        NSLog(@"关闭");
        if (self.effectBlock) {
            self.effectBlock(NO);
        }
    }
}

- (UILabel*)titleLabel
{
    if (!_titleLabel) {

        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.mas_leading).offset(self.space);
            make.top.equalTo(self.mas_top).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(-1);
            make.trailing.equalTo(self.mas_trailing).offset(-self.space);
            
        }];
    }
    return _titleLabel;
}

- (UIImageView*)rightArrow
{
    if (!_rightArrow) {
        
        CGFloat imageW = 10;
        CGFloat imageH = 12;
        
        _rightArrow = [[UIImageView alloc]init];
        [self addSubview:_rightArrow];
        
        [_rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.mas_top).offset((self.viewHeight-imageH)/2);
            make.trailing.equalTo(self.mas_trailing).offset(-self.space-imageW);
            make.height.mas_equalTo(imageH);
            make.width.mas_equalTo(imageW);
        }];
    }
    return _rightArrow;
}

- (UIImageView*)lineView
{
    if (!_lineView) {
        _lineView = [[UIImageView alloc]init];
        [self addSubview:_lineView];
        
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.mas_leading).offset(self.space);
            make.bottom.equalTo(self.mas_bottom).offset(-0.7);
            make.trailing.equalTo(self.mas_trailing).offset(-self.space);
            make.height.mas_equalTo(0.7);
        }];
    }
    return _lineView;
}

- (UISwitch *)rightSwitch{
    if (!_rightSwitch) {
        _rightSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(PhoneScreen_WIDTH-80, 12, 60, 26)];
        [_rightSwitch addTarget:self action:@selector(openAction:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_rightSwitch];
    }
    return _rightSwitch;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
