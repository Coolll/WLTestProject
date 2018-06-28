//
//  WLImagePoetryController.m
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/6/27.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLImagePoetryController.h"

@interface WLImagePoetryController ()
/**
 *  内容view
 **/
@property (nonatomic, strong) UIView *contentView;
/**
 *  搜索
 **/
@property (nonatomic, strong) UIView *searchView;
/**
 *  输入框
 **/
@property (nonatomic, strong) UITextView *inputTextView;
/**
 *  完成按钮
 **/
@property (nonatomic, strong) UIButton *finishBtn;
@end

@implementation WLImagePoetryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewBackgroundColor;
    self.titleForNavi = @"题画内容";
    
    [self loadCustomView];
}

- (void)loadCustomView
{
    self.searchView.backgroundColor = [UIColor whiteColor];
    self.inputTextView.backgroundColor = [UIColor whiteColor];
    self.finishBtn.backgroundColor = NavigationColor;

}

- (void)finishAction:(UIButton*)sender
{
    NSLog(@"完成");
}

- (UIView*)searchView
{
    if (!_searchView) {
        _searchView = [[UIView alloc]init];
        [self.view addSubview:_searchView];
        //设置UI布局约束
        [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.naviView.mas_bottom).offset(20);//元素顶部约束
            make.leading.equalTo(self.view.mas_leading).offset(15);//元素左侧约束
            make.trailing.equalTo(self.view.mas_trailing).offset(-15);//元素右侧约束
            make.height.mas_equalTo(50);//元素高度
        }];
    }
    return _searchView;
}
- (UITextView*)inputTextView
{
    if (!_inputTextView) {
        
        _inputTextView = [[UITextView alloc]init];
        _inputTextView.layer.cornerRadius = 4.f;
        [self.view addSubview:_inputTextView];
        
        //设置UI布局约束
        [_inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.searchView.mas_bottom).offset(20);//元素顶部约束
            make.leading.equalTo(self.naviView.mas_leading).offset(15);//元素左侧约束
            make.trailing.equalTo(self.naviView.mas_trailing).offset(-15);//元素右侧约束
            make.height.mas_equalTo(160);//元素高度
        }];
    }
    return _inputTextView;
}


- (UIButton*)finishBtn
{
    if (_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_finishBtn addTarget:self action:@selector(finishAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_finishBtn];
        
        if (@available(iOS 11.0, *)) {
            //设置UI布局约束
            [_finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-49);//元素顶部约束
                make.leading.equalTo(self.view.mas_leading).offset(0);//元素左侧约束
                make.trailing.equalTo(self.view.mas_trailing).offset(0);//元素右侧约束
                make.bottom.equalTo(self.view.mas_bottom).offset(0);//元素底部约束
            }];
        }else{
            //设置UI布局约束
            [_finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(self.view.mas_bottom).offset(-49);//元素顶部约束
                make.leading.equalTo(self.view.mas_leading).offset(0);//元素左侧约束
                make.trailing.equalTo(self.view.mas_trailing).offset(0);//元素右侧约束
                make.bottom.equalTo(self.view.mas_bottom).offset(0);//元素底部约束
            }];
        }
        
        
        
    }
    
    return _finishBtn;
    
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
