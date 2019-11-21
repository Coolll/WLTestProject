//
//  WLTypeListCell.m
//  WLPoetryProject
//
//  Created by 龙培 on 2018/6/9.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLTypeListCell.h"
@interface WLTypeListCell ()
/**
 *  分割线
 **/
@property (nonatomic, strong) UIView *lineView;
@end
@implementation WLTypeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _needLine = YES;
}

- (void)setTypeString:(NSString *)typeString
{
    _typeString = typeString;
    [self loadCustomView];
}

- (void)setNeedLine:(BOOL)needLine
{
    _needLine = needLine;
    if (!needLine) {
        self.lineView.hidden = YES;
    }
}

- (void)loadCustomView
{
    UIImageView *mainImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:mainImageView];

    if (self.imageName && [self.imageName isKindOfClass:[NSString class]] && self.imageName.length > 0) {
        mainImageView.image = [UIImage imageNamed:self.imageName];
        
        //元素的布局
        [mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.contentView.mas_leading).offset(15);
            make.top.equalTo(self.contentView.mas_top).offset(20);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
            
        }];
    }else{
        mainImageView.image = [UIImage imageNamed:@"bookType"];
        
        CGFloat imageW = 30;
        
        //元素的布局
        [mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.contentView.mas_leading).offset(15);
            make.top.equalTo(self.contentView.mas_top).offset(15);
            make.width.mas_equalTo(imageW);
            make.height.mas_equalTo(imageW);
            
        }];
        
    }
    
    
    
    
    
    
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.text = _typeString;
    contentLabel.font = [UIFont systemFontOfSize:14.f];//字号设置
    [self.contentView addSubview:contentLabel];
    //元素的布局
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(mainImageView.mas_trailing).offset(20);
        make.top.equalTo(mainImageView.mas_top).offset(0);
        make.bottom.equalTo(mainImageView.mas_bottom).offset(0);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-15);
        
    }];
    

    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = RGBCOLOR(235, 235, 235, 1.9);
    [self.contentView addSubview:self.lineView];
    //设置UI布局约束
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView.mas_bottom).offset(-1);//元素顶部约束
        make.leading.equalTo(mainImageView.mas_leading).offset(0);//元素左侧约束
        make.trailing.equalTo(self.contentView.mas_trailing).offset(0);//元素右侧约束
        make.height.mas_equalTo(1);//元素高度
    }];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
