//
//  PoetryDetailViewController.m
//  WLPoetryProject
//
//  Created by 龙培 on 2018/4/23.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "PoetryDetailViewController.h"

@interface PoetryDetailViewController ()
/**
 *  scrollView
 **/
@property (nonatomic,strong) UIScrollView *mainScroll;


@end

@implementation PoetryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleForNavi = self.dataModel.name;
    self.imageForNavi = @"clearNavi";
    [self loadCustomView];
}

- (void)loadCustomView
{
    
    
    UIImageView *mainImageView = [[UIImageView alloc]init];
    mainImageView.image = [UIImage imageNamed:@"poetryBack.jpg"];
    [self.view addSubview:mainImageView];
    //元素的布局
//    [mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(self.view.mas_left).offset(0);
//        make.top.equalTo(self.view.mas_top).offset(0);
//        make.bottom.equalTo(self.view.mas_bottom).offset(0);
//        make.right.equalTo(self.view.mas_right).offset(0);
//
//    }];
    [mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.naviView.mas_bottom).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        
    }];
//    [self.view bringSubviewToFront:self.naviView];
}

- (void)backAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
