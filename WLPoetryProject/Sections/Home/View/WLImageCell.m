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
    UIImageView *topImageView = [[UIImageView alloc]init];
    topImageView.layer.cornerRadius = 6.f;
    topImageView.image = [UIImage imageNamed:@"topImage.jpg"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchImageAction:)];
    [topImageView addGestureRecognizer:tap];
    topImageView.userInteractionEnabled = YES;
    [self addSubview:topImageView];
    
    //设置UI布局约束
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(10);//元素顶部约束
        make.leading.equalTo(self.mas_leading).offset(15);//元素左侧约束
        make.trailing.equalTo(self.mas_trailing).offset(-15);//元素右侧约束
        make.bottom.equalTo(self.mas_bottom).offset(-10);//元素底部约束
        
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
