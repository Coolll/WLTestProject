//
//  WLImageController.m
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/6/25.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLImageController.h"

@interface WLImageController ()
/**
 *  图片
 **/
@property (nonatomic, strong) UIImageView *mainImageView;
@end

@implementation WLImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleForNavi = @"题画";
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadMainBackImageView];//背景
    [self addFullTitleLabel];//诗词名字 添加背景之后调用，否则会被背景图遮住
    [self addBackButtonForFullScreen];//返回按钮，需要最后添加
    
    [self loadCustomView];
}

- (void)loadCustomView
{
    UIButton *showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    showBtn.backgroundColor = [UIColor orangeColor];
    [self.mainImageView addSubview:showBtn];
    
    //设置UI布局约束
//    [showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(<#View#>.mas_top).offset(<#offset#>);//元素顶部约束
//        make.leading.equalTo(<#View#>.mas_leading).offset(<#offset#>);//元素左侧约束
//        make.trailing.equalTo(<#View#>.mas_trailing).offset(-<#offset#>);//元素右侧约束
//        make.bottom.equalTo(<#View#>.mas_bottom).offset(-<#offset#>);//元素底部约束
//        make.width.mas_equalTo(<#value#>);//元素宽度
//        make.height.mas_equalTo(<#value#>);//元素高度
//    }];
}

- (void)loadMainBackImageView
{
    //诗词主背景
    self.mainImageView = [[UIImageView alloc]init];
    self.mainImageView.image = [UIImage imageNamed:@"poetryBack.jpg"];
    [self.view addSubview:self.mainImageView];
    
    //元素的布局
    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
