//
//  RecitePoetryController.m
//  WLPoetryProject
//
//  Created by 变啦 on 2018/11/5.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "RecitePoetryController.h"

@interface RecitePoetryController ()

@end

@implementation RecitePoetryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleForNavi = @"背诵诗词";
    [self loadCustomView];
    [self loadRightBtn];
}
- (void)loadRightBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addEventWithAction:^(UIButton *sender) {
        [self optionAction];
    }];
    [self.naviView addSubview:btn];
    
    //元素的布局
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.naviView.mas_bottom).offset(-10);
        make.trailing.equalTo(self.naviView.mas_trailing).offset(-15);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
        
    }];
    
    UIImageView *optionImage = [[UIImageView alloc]init];
    optionImage.image = [UIImage imageNamed:@"optionIcon"];
    [self.naviView addSubview:optionImage];
    //元素的布局
    [optionImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.naviView.mas_bottom).offset(-12);
        make.trailing.equalTo(self.naviView.mas_trailing).offset(-20);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
        
    }];
    
}
- (void)optionAction{
    NSLog(@"展开选项");
}
- (void)loadCustomView
{
   
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
