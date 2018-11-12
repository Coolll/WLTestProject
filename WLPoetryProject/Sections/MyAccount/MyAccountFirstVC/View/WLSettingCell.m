//
//  WLSettingCell.m
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/6/16.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLSettingCell.h"
@interface WLSettingCell()

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



@end
@implementation WLSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.viewHeight = frame.size.height;
        self.space = 22;

//        [self loadCustomView];
        
    }
    return self;
}

- (void)loadCustomView
{

    if (self.needRight) {
        self.rightLabel.textColor = RGBCOLOR(150, 150, 150, 1.0);
    }
    self.rightArrow.image = [UIImage imageNamed:@"settingArrow"];

    self.lineView.image = [UIImage imageNamed:@"lineImage"];
    
}

- (void)setShowLine:(BOOL)showLine
{
    _showLine = showLine;
    if (!showLine) {
        self.lineView.hidden = YES;
    }
}


- (void)setTitleString:(NSString *)titleString
{
    _titleString = titleString;
    
    if (self.titleLabel) {
        self.titleLabel.text = titleString;
        
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


- (UILabel*)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc]init];
        _rightLabel.font = [UIFont systemFontOfSize:14.f];
        _rightLabel.textColor = RGBCOLOR(150, 150, 150, 1.0);
        _rightLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_rightLabel];
        //元素的布局
        [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.mas_centerX).offset(0);
            make.top.equalTo(self.mas_top).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.trailing.equalTo(self.rightArrow.mas_leading).offset(-4);
            
        }];
        
        
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.trailing.equalTo(self.mas_centerX);
        }];
    }
    return _rightLabel;
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
