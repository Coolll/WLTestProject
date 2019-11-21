//
//  WLShapeLayer.m
//  BLBalance
//
//  Created by 变啦 on 2018/10/19.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLShapeLayer.h"
@interface WLShapeLayer()
/**
 *  展示文本的label
 **/
@property (nonatomic,strong) UILabel *textLabel;


@end

@implementation WLShapeLayer
- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    
    if (isSelected) {
        self.strokeColor = RGBCOLOR(117, 201, 250, 1.0).CGColor;
        self.textLabel.text = [NSString stringWithFormat:@"%@",self.text];
    }else{
        self.strokeColor = RGBCOLOR(59, 167, 249, 1.0).CGColor;
        self.textLabel.hidden = YES;
        [self.textLabel removeFromSuperview];
        self.textLabel = nil;
    }
}

- (UILabel*)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.font = [UIFont systemFontOfSize:16.f];
        _textLabel.backgroundColor = [UIColor whiteColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.alpha = 0.6;
        [self.supView addSubview:_textLabel];
        //元素的布局
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(self.supView.mas_top).offset(self.chartTopY);
            make.centerX.equalTo(self.supView.mas_leading).offset(self.chartCenterX);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(20);
            
        }];
    }
    return _textLabel;
}

@end
