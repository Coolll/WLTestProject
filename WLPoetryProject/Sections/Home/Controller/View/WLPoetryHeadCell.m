//
//  WLPoetryHeadCell.m
//  WLPoetryProject
//
//  Created by 变啦 on 2018/11/8.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLPoetryHeadCell.h"

@implementation WLPoetryHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)loadCustomView
{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.name;
    titleLabel.font = [UIFont systemFontOfSize:18.f];
    titleLabel.frame = CGRectMake(15, 10, PhoneScreen_WIDTH-30, 20);
    titleLabel.textColor = RGBCOLOR(50, 50, 50, 1.0);
    [self addSubview:titleLabel];
    
    UILabel *authorLabel = [[UILabel alloc]init];
    authorLabel.textAlignment = NSTextAlignmentCenter;
    authorLabel.text = self.author;
    authorLabel.font = [UIFont systemFontOfSize:14.f];
    authorLabel.textColor = RGBCOLOR(120, 120, 120, 1.0);
    authorLabel.frame = CGRectMake(20, 40, PhoneScreen_WIDTH-40, 16);
    [self addSubview:authorLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
