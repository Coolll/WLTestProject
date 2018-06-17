//
//  AboutViewController.m
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/6/17.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleForNavi = @"关于";
    self.view.backgroundColor = ViewBackgroundColor;
    [self loadCustomView];
}

- (void)loadCustomView
{
    CGFloat iconWidth = 50;
    UIImageView *iconImageView = [[UIImageView alloc]init];
    iconImageView.image = [UIImage imageNamed:@"poetryIcon"];
    iconImageView.layer.cornerRadius = 4.f;
    [self.view addSubview:iconImageView];
    //设置UI布局约束
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.naviView.mas_bottom).offset(25);//元素顶部约束
        make.leading.equalTo(self.view.mas_leading).offset((PhoneScreen_WIDTH-iconWidth)/2);//元素左侧约束
        make.width.mas_equalTo(iconWidth);//元素宽度
        make.height.mas_equalTo(iconWidth);//元素高度
    }];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = @"诗词汇";
    nameLabel.font = [UIFont systemFontOfSize:16.f];//字号设置
    [self.view addSubview:nameLabel];
    //设置UI布局约束
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(iconImageView.mas_bottom).offset(15);//元素顶部约束
        make.leading.equalTo(self.view.mas_leading).offset(0);//元素左侧约束
        make.trailing.equalTo(self.view.mas_trailing).offset(0);//元素右侧约束
        make.height.mas_equalTo(20);//元素高度
    }];
    
    
    UILabel *versionLabel = [[UILabel alloc]init];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.font = [UIFont systemFontOfSize:16.f];//字号设置
    [self.view addSubview:versionLabel];
    
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];//1.0.5
    versionLabel.text = [NSString stringWithFormat:@"当前版本 %@",appVersion];
    //设置UI布局约束
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(nameLabel.mas_bottom).offset(10);//元素顶部约束
        make.leading.equalTo(nameLabel.mas_leading).offset(0);//元素左侧约束
        make.trailing.equalTo(nameLabel.mas_trailing).offset(0);//元素右侧约束
        make.height.mas_equalTo(20);//元素高度
    }];
    
    
    UILabel *infoLabel = [[UILabel alloc]init];
    infoLabel.font = [UIFont systemFontOfSize:14.f];//字号设置
    infoLabel.text = @"  诗词汇是一款掌上诗词的应用。\n  诗词中，有宽广的视野、豁达的心态、理性的思维、美好的意境以及高雅的气质。进入诗词的世界中，你将会受益终身。";//设置文本
    infoLabel.numberOfLines = 0;
    [self.view addSubview:infoLabel];
    //设置UI布局约束
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(versionLabel.mas_bottom).offset(10);//元素顶部约束
        make.leading.equalTo(self.view.mas_leading).offset(15);//元素左侧约束
        make.trailing.equalTo(self.view.mas_trailing).offset(-15);//元素右侧约束
        make.height.mas_equalTo(80);//元素高度
    }];
    
}
#pragma mark - 返回事件

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
