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
/**
 *  点击的回调
 **/
@property (nonatomic,copy) headImageSelectBlock selectBlock;

@end

@implementation WLHeadImageSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)loadCustomCellWithCompletion:(headImageSelectBlock)block{
    self.itemWith = (PhoneScreen_WIDTH-60)/3;
    self.frame = CGRectMake(0, 0, PhoneScreen_WIDTH, (self.itemWith+20));
    [self.oneImageView sd_setImageWithURL:[NSURL URLWithString:self.oneImageUrlString]];
    [self.twoImageView sd_setImageWithURL:[NSURL URLWithString:self.twoImageUrlString]];
    [self.threeImageView sd_setImageWithURL:[NSURL URLWithString:self.threeImageUrlString]];
    
    if (block) {
        self.selectBlock = block;
    }
    
    self.oneImageView.layer.borderWidth = 0;
    self.twoImageView.layer.borderWidth = 0;
    self.threeImageView.layer.borderWidth = 0;

    if (self.containSelected) {
        [self updateViewWithIndex:self.currentSelectIndex];
    }
}

- (void)updateViewWithIndex:(NSInteger)index{
    if (index == 0) {
        self.oneImageView.layer.borderWidth = 2;
        self.oneImageView.layer.borderColor = NavigationColor.CGColor;
    }else if (index == 1){
        self.twoImageView.layer.borderWidth = 2;
        self.twoImageView.layer.borderColor = NavigationColor.CGColor;
    }else if (index == 2){
        self.threeImageView.layer.borderWidth = 2;
        self.threeImageView.layer.borderColor = NavigationColor.CGColor;
    }
    
}

- (void)selectOneAction:(UITapGestureRecognizer*)sender{
    if (self.selectBlock) {
        self.selectBlock(self.rowIndex, 0, self.oneImageUrlString);
    }
    [self updateViewWithIndex:0];
}
- (void)selectTwoAction:(UITapGestureRecognizer*)sender{
    if (self.selectBlock) {
        self.selectBlock(self.rowIndex, 1, self.twoImageUrlString);
    }
    [self updateViewWithIndex:1];

}
- (void)selectThreeAction:(UITapGestureRecognizer*)sender{
    if (self.selectBlock) {
        self.selectBlock(self.rowIndex, 2, self.threeImageUrlString);
    }
    [self updateViewWithIndex:2];

}

- (UIImageView*)oneImageView{
    if (!_oneImageView) {
        _oneImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_oneImageView];
        //元素的布局
        [_oneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(self.mas_top).offset(10);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.width.mas_equalTo(self.itemWith);
        }];
        _oneImageView.userInteractionEnabled = YES;
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectOneAction:)];
        [_oneImageView addGestureRecognizer:tap];
        //使用按钮的话，需要放在contentView上
        /*
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(selectOneAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        //元素的布局
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_oneImageView.mas_left).offset(0);
            make.top.equalTo(_oneImageView.mas_top).offset(0);
            make.right.equalTo(_oneImageView.mas_right).offset(-0);
            make.bottom.equalTo(_oneImageView.mas_bottom).offset(-0);
        }];*/

    }
    return _oneImageView;
}
- (UIImageView*)twoImageView{
    if (!_twoImageView) {
        _twoImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_twoImageView];
        //元素的布局
        [_twoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.oneImageView.mas_right).offset(15);
            make.top.equalTo(self.mas_top).offset(10);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.width.mas_equalTo(self.itemWith);
        }];
        _twoImageView.userInteractionEnabled = YES;
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTwoAction:)];
        [_twoImageView addGestureRecognizer:tap];


    }
    return _twoImageView;
}


- (UIImageView*)threeImageView{
    if (!_threeImageView) {
        _threeImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_threeImageView];
        //元素的布局
        [_threeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.twoImageView.mas_right).offset(15);
            make.top.equalTo(self.mas_top).offset(10);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.width.mas_equalTo(self.itemWith);
        }];
        _threeImageView.userInteractionEnabled = YES;
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectThreeAction:)];
        [_threeImageView addGestureRecognizer:tap];


    }
    return _threeImageView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
