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
        
        [self loadCustomView];
        
    }
    return self;
}

- (void)loadCustomView
{
    CGFloat space = 22;

    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(space);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(-1);
        make.right.equalTo(self.mas_right).offset(-space);
        
    }];
    
    
    
    CGFloat imageW = 10;
    CGFloat imageH = 12;
    CGFloat topSpace = (self.frame.size.height-imageH)/2;
    
    self.rightArrow = [[UIImageView alloc]init];
    self.rightArrow.image = [UIImage imageNamed:@"settingArrow"];
    [self addSubview:self.rightArrow];
    
    [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(topSpace);
        make.right.equalTo(self.mas_right).offset(-space-imageW);
        make.height.mas_equalTo(imageH);
        make.width.mas_equalTo(imageW);
    }];
    
    self.lineView = [[UIImageView alloc]init];
    self.lineView.image = [UIImage imageNamed:@"lineImage"];
    [self addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(space);
        make.bottom.equalTo(self.mas_bottom).offset(-0.7);
        make.right.equalTo(self.mas_right).offset(-space);
        make.height.mas_equalTo(0.7);
    }];
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





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
