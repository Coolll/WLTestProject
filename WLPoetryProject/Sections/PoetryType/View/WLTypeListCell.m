//
//  WLTypeListCell.m
//  WLPoetryProject
//
//  Created by 龙培 on 2018/6/9.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLTypeListCell.h"

@implementation WLTypeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTypeString:(NSString *)typeString
{
    _typeString = typeString;
    [self loadCustomView];
}

- (void)loadCustomView
{
    UIImageView *mainImageView = [[UIImageView alloc]init];
    mainImageView.image = [UIImage imageNamed:@"typeBgImage"];
    mainImageView.opaque = YES;
    [self.contentView addSubview:mainImageView];
    
    //元素的布局
    [mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        
    }];
    
//    CGFloat leftSpace = 15;

//    UILabel *iconLabel = [[UILabel alloc]init];
//    iconLabel.text = [_typeString substringToIndex:1];
//    iconLabel.textAlignment = NSTextAlignmentCenter;
//    iconLabel.backgroundColor=  RGBCOLOR(169, 145, 116, 1.0);
//    [mainImageView addSubview:iconLabel];
//    //元素的布局
//    [iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(mainImageView.mas_left).offset(leftSpace);
//        make.centerY.equalTo(mainImageView.mas_centerY);
//        make.width.mas_equalTo(40);
//        make.height.mas_equalTo(40);
//    }];
//
//    UIImageView *iconImageView = [[UIImageView alloc]init];
//    iconImageView.image = [UIImage imageNamed:@"typeIcon"];
//    [mainImageView addSubview:iconImageView];
//    //元素的布局
//    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(mainImageView.mas_left).offset(leftSpace);
//        make.centerY.equalTo(mainImageView.mas_centerY);
//        make.width.mas_equalTo(40);
//        make.height.mas_equalTo(40);
//
//    }];
//
    
    
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.text = _typeString;
    contentLabel.textAlignment = NSTextAlignmentCenter;
//    contentLabel.backgroundColor = RGBCOLOR(169, 145, 116, 1.0);
    [mainImageView addSubview:contentLabel];
    //元素的布局
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
//        make.centerX.equalTo(mainImageView.mas_centerX);
        make.left.equalTo(mainImageView.mas_left).offset(15);
        make.top.equalTo(mainImageView.mas_top).offset(15);
        make.bottom.equalTo(mainImageView.mas_bottom).offset(-15);
        make.right.equalTo(mainImageView.mas_right).offset(-15);
       
        
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
