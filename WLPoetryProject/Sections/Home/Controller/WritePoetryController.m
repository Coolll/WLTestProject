//
//  WritePoetryController.m
//  WLPoetryProject
//
//  Created by 龙培 on 2018/7/28.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WritePoetryController.h"
#import "WLCustomTextView.h"
@interface WritePoetryController ()
/**
 *  标题
 **/
@property (nonatomic, strong) WLCustomTextView *titleTextView;
/**
 *  名字
 **/
@property (nonatomic, strong) WLCustomTextView *nameTextView;
/**
 *  内容
 **/
@property (nonatomic, strong) WLCustomTextView *contentTextView;

@end

@implementation WritePoetryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleForNavi = @"创作诗词";
    [self loadCustomView];
}

- (void)loadCustomView
{
    self.titleTextView.placeHolderString = @"标题";
    self.nameTextView.placeHolderString = @"姓名";
    self.contentTextView.placeHolderString = @"内容";
}

#pragma mark - 点击事件
- (void)backAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (WLCustomTextView*)titleTextView
{
    if (!_titleTextView) {
        _titleTextView = [[WLCustomTextView alloc]init];
        [self.view addSubview:_titleTextView];
        _titleTextView.leftSpace = 5;
        //设置UI布局约束
        [_titleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.naviView.mas_bottom).offset(20);//元素顶部约束
            make.leading.equalTo(self.view.mas_leading).offset(10);//元素左侧约束
            make.trailing.equalTo(self.view.mas_trailing).offset(-10);//元素右侧约束
            make.height.mas_equalTo(48);//元素高度
        }];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = RGBCOLOR(240, 240, 242, 1.0);
        [self.view addSubview:lineView];
        //设置UI布局约束
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_titleTextView.mas_bottom).offset(10);//元素顶部约束
            make.leading.equalTo(self.view.mas_leading).offset(0);//元素左侧约束
            make.trailing.equalTo(self.view.mas_trailing).offset(0);//元素右侧约束
            make.height.mas_equalTo(0.8);//元素高度
        }];
    }
    return _titleTextView;
}


- (WLCustomTextView*)nameTextView
{
    if (!_nameTextView) {
        _nameTextView = [[WLCustomTextView alloc]init];
        [self.view addSubview:_nameTextView];
        _nameTextView.leftSpace = 5;
        //设置UI布局约束
        [_nameTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.titleTextView.mas_bottom).offset(20);//元素顶部约束
            make.leading.equalTo(self.view.mas_leading).offset(10);//元素左侧约束
            make.trailing.equalTo(self.view.mas_trailing).offset(-10);//元素右侧约束
            make.height.mas_equalTo(48);//元素高度
        }];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = RGBCOLOR(240, 240, 242, 1.0);
        [self.view addSubview:lineView];
        //设置UI布局约束
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_nameTextView.mas_bottom).offset(10);//元素顶部约束
            make.leading.equalTo(self.view.mas_leading).offset(0);//元素左侧约束
            make.trailing.equalTo(self.view.mas_trailing).offset(0);//元素右侧约束
            make.height.mas_equalTo(0.8);//元素高度
        }];
    }
    return _nameTextView;
}

- (WLCustomTextView*)contentTextView
{
    if (!_contentTextView) {
        _contentTextView = [[WLCustomTextView alloc]init];
        [self.view addSubview:_contentTextView];
        _contentTextView.leftSpace = 5;
        
        //设置UI布局约束
        [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.nameTextView.mas_bottom).offset(20);//元素顶部约束
            make.leading.equalTo(self.view.mas_leading).offset(10);//元素左侧约束
            make.trailing.equalTo(self.view.mas_trailing).offset(-10);//元素右侧约束
            make.height.mas_equalTo(48);//元素高度
        }];
    }
    return _contentTextView;
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
