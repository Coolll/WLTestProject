//
//  WLHeadImageSelectCell.m
//  WLPoetryProject
//
//  Created by 龙培 on 2020/6/11.
//  Copyright © 2020年 龙培. All rights reserved.
//

#import "WLHeadImageSelectCell.h"
@interface WLHeadImageSelectCell()
/**
 *  第一张图
 **/
@property (nonatomic,strong) UIImageView *oneImageView;
/**
 *  第二张图
 **/
@property (nonatomic,strong) UIImageView *twoImageView;
/**
 *  第三张图
 **/
@property (nonatomic,strong) UIImageView *threeImageView;
/**
 *  单个图片的宽度
 **/
@property (nonatomic,assign) CGFloat itemWith;


@end

@implementation WLHeadImageSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)loadCustomCell{
    self.itemWith = (PhoneScreen_WIDTH-60)/3;
    self.frame = CGRectMake(0, 0, PhoneScreen_WIDTH, (self.itemWith+20));
    if (self.isLocalImage) {
        [self.oneImageView setImage:[UIImage imageNamed:self.oneImageUrlString]];
        [self.twoImageView setImage:[UIImage imageNamed:self.twoImageUrlString]];
        [self.threeImageView setImage:[UIImage imageNamed:self.threeImageUrlString]];
    }else{
        [self.oneImageView sd_setImageWithURL:[NSURL URLWithString:self.oneImageUrlString]];
        [self.twoImageView sd_setImageWithURL:[NSURL URLWithString:self.twoImageUrlString]];
        [self.threeImageView sd_setImageWithURL:[NSURL URLWithString:self.threeImageUrlString]];
    }
}

- (UIImageView*)oneImageView{
    if (!_oneImageView) {
        _oneImageView = [[UIImageView alloc]init];
        [self addSubview:_oneImageView];
        //元素的布局
        [_oneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(self.mas_top).offset(10);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.width.mas_equalTo(self.itemWith);
        }];
    }
    return _oneImageView;
}
- (UIImageView*)twoImageView{
    if (!_twoImageView) {
        _twoImageView = [[UIImageView alloc]init];
        [self addSubview:_twoImageView];
        //元素的布局
        [_twoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.oneImageView.mas_right).offset(15);
            make.top.equalTo(self.mas_top).offset(10);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.width.mas_equalTo(self.itemWith);
        }];
    }
    return _twoImageView;
}


- (UIImageView*)threeImageView{
    if (!_threeImageView) {
        _threeImageView = [[UIImageView alloc]init];
        [self addSubview:_threeImageView];
        //元素的布局
        [_threeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.twoImageView.mas_right).offset(15);
            make.top.equalTo(self.mas_top).offset(10);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.width.mas_equalTo(self.itemWith);
        }];
    }
    return _threeImageView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
