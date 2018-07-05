//
//  WLImageCell.m
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/6/22.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLImageCell.h"
@interface WLImageCell ()
/**
 *  点击的block
 **/
@property (nonatomic, copy) ImageCellTouchBlock block;

@end
@implementation WLImageCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)loadCustomView
{
    UILabel *imageTipLabel = [[UILabel alloc]init];
    imageTipLabel.text = @"题画";
    imageTipLabel.font = [UIFont systemFontOfSize:14.f];
    imageTipLabel.textColor = RGBCOLOR(100, 100, 100, 1.0);
    [self addSubview:imageTipLabel];
    //元素的布局
    [imageTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(10);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.mas_equalTo(20);
        
    }];
    UIImageView *topImageView = [[UIImageView alloc]init];
    topImageView.layer.cornerRadius = 8.f;
    topImageView.clipsToBounds = YES;
    topImageView.image = [UIImage imageNamed:@"topImage.jpg"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchImageAction:)];
    [topImageView addGestureRecognizer:tap];
    topImageView.userInteractionEnabled = YES;
    [self addSubview:topImageView];
    
    //设置UI布局约束
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(imageTipLabel.mas_bottom).offset(5);//元素顶部约束
        make.leading.equalTo(self.mas_leading).offset(15);//元素左侧约束
        make.trailing.equalTo(self.mas_trailing).offset(-15);//元素右侧约束
        make.bottom.equalTo(self.mas_bottom).offset(-25);//元素底部约束
        
    }];
    
    UILabel *poetryTipLabel = [[UILabel alloc]init];
    poetryTipLabel.text = @"诗词";
    poetryTipLabel.font = [UIFont systemFontOfSize:14.f];
    poetryTipLabel.textColor = RGBCOLOR(100, 100, 100, 1.0);
    [self addSubview:poetryTipLabel];
    //元素的布局
    [poetryTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(topImageView.mas_bottom).offset(5);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.mas_equalTo(20);
        
    }];
    
}

- (void)touchImageAction:(UIButton*)sender
{
    if (self.block) {
        self.block();
    }
}

- (void)touchImageWithBlock:(ImageCellTouchBlock)block
{
    if (block) {
        self.block = block;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
