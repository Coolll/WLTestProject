//
//  WLShowImageController.m
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/7/13.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLShowImageController.h"

@interface WLShowImageController ()
/**
 *  图片
 **/
@property (nonatomic, strong) UIImageView *mainImageView;
@end

@implementation WLShowImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}
- (void)configureUI
{
    [self loadMainBackImageView];//背景
    [self addFullTitleLabel];//诗词名字 添加背景之后调用，否则会被背景图遮住
    [self addBackButtonForFullScreen];//返回按钮，需要最后添加
    [self loadLikeButton];
}

- (void)loadLikeButton
{
    UIImageView *shareImage = [[UIImageView alloc]init];
    shareImage.image = [UIImage imageNamed:@"shareIcon"];
    [self.view addSubview:shareImage];
    
    if (@available(iOS 11.0, *)) {
        //元素的布局
        [shareImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(35);
            make.right.equalTo(self.view.mas_right).offset(-20);
            make.width.mas_equalTo(20);//元素宽度
            make.height.mas_equalTo(20);//元素高度
            
        }];
    }else{
        //设置UI布局约束
        [shareImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.view.mas_top).offset(24);//元素顶部约束
            make.trailing.equalTo(self.view.mas_trailing).offset(-20);//元素右侧约束
            make.width.mas_equalTo(20);//元素宽度
            make.height.mas_equalTo(20);//元素高度
        }];
    }
   
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.backgroundColor = [UIColor clearColor];
    [shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    //设置UI布局约束
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(shareImage.mas_top).offset(-10);//元素顶部约束
        make.trailing.equalTo(shareImage.mas_trailing).offset(10);//元素右侧约束
        make.bottom.equalTo(shareImage.mas_bottom).offset(10);//元素底部约束
        make.leading.equalTo(shareImage.mas_leading).offset(-10);
    }];
    
    
}


- (void)setMainImage:(UIImage *)mainImage
{
    _mainImage = mainImage;
    if ([mainImage isKindOfClass:[UIImage class]]) {
        self.mainImageView.image = mainImage;
    }
}


- (void)loadMainBackImageView
{
    //诗词主背景
    self.mainImageView = [[UIImageView alloc]init];
    self.mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    if ([self.mainImage isKindOfClass:[UIImage class]]) {
        self.mainImageView.image = self.mainImage;
        [self.view addSubview:self.mainImageView];
        
        //元素的布局
        [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view.mas_left).offset(0);
            make.top.equalTo(self.view.mas_top).offset(0);
            make.bottom.equalTo(self.view.mas_bottom).offset(0);
            make.right.equalTo(self.view.mas_right).offset(0);
            
        }];
    }
    
}

- (void)shareAction:(UIButton*)sender
{
    [self shareWithImageArray:@[self.mainImage]];
    
}

@end
