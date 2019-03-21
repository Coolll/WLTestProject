//
//  WLPoetryContentCell.m
//  WLPoetryProject
//
//  Created by 龙培 on 2018/5/5.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLPoetryContentCell.h"
@interface WLPoetryContentCell()



@end
@implementation WLPoetryContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadContentView];
    }
    return self;
}

- (void)loadContentView
{
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.font = [AppConfig config].contentFont;
    self.contentLabel.textColor = RGBCOLOR(60, 60, 120, 1.0);
    [self.contentView addSubview:self.contentLabel];
    //元素的布局
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.contentView.mas_leading).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-10);
        
    }];
}

- (void)setContentString:(NSString *)contentString
{
    _contentString = contentString;
    if ([contentString isKindOfClass:[NSString class]] && contentString.length > 0) {
        self.contentLabel.text = contentString;
    }
}

+ (CGFloat)heightForContent:(NSString*)content withWidth:(CGFloat)width
{
    
    CGFloat contentHeight = [WLPublicTool heightForTextString:content width:width fontSize:[AppConfig config].contentFont.pointSize]+2;
    
    if (contentHeight < 40) {
        return 40;
    }
    return contentHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
