//
//  WLMyTableViewCell.m
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/14.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import "WLMyTableViewCell.h"

@interface WLMyTableViewCell ()
/**
 *  标题
 **/
@property (nonatomic,strong) UILabel *titelLabel;

/**
 *  图标
 **/
@property (nonatomic,strong) UIImageView *iconImageView;

/**
 *  视图高度
 **/
@property (nonatomic,assign) CGFloat viewHeight;



@end

@implementation WLMyTableViewCell


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
    
    CGFloat iconW = 19;
    CGFloat iconH = 19;
    CGFloat iconTopSpace = (self.viewHeight-iconH)/2;
    
    self.iconImageView = [[UIImageView alloc]init];
    [self addSubview:self.iconImageView];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(space);
        make.top.equalTo(self.mas_top).offset(iconTopSpace);
        make.height.mas_equalTo(iconH);
        make.width.mas_equalTo(iconW);
    }];
    
    
    
    self.titelLabel = [[UILabel alloc]init];
    self.titelLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:self.titelLabel];
    
    [self.titelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.iconImageView.mas_right).offset(12);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(-1);
        make.right.equalTo(self.mas_right).offset(-50);
        
    }];
    
    
    
    CGFloat imageW = 10;
    CGFloat imageH = 12;
    CGFloat topSpace = (self.frame.size.height-imageH)/2;
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"myArrow"];
    [self addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(topSpace);
        make.right.equalTo(self.mas_right).offset(-space-imageW);
        make.height.mas_equalTo(imageH);
        make.width.mas_equalTo(imageW);
    }];
    
    UIImageView *lineView = [[UIImageView alloc]init];
    lineView.image = [UIImage imageNamed:@"lineImage"];
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(space);
        make.bottom.equalTo(self.mas_bottom).offset(-0.7);
        make.right.equalTo(self.mas_right).offset(-space);
        make.height.mas_equalTo(0.7);
    }];
}

- (void)setTitleString:(NSString *)titleString
{
    _titleString = titleString;
    
    if (self.titelLabel) {
        self.titelLabel.text = titleString;
        
    }
}


- (void)setIconImageName:(NSString *)iconImageName
{
    _iconImageName = iconImageName;
    if (self.iconImageView) {
        
        self.iconImageView.image = [UIImage imageNamed:iconImageName];
    }
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
