//
//  BaseViewController.m
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/1.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"
@interface BaseViewController ()

@property (nonatomic,strong)MBProgressHUD *progressHUD;

/**
 *  标题
 **/
@property (nonatomic,strong) UILabel *naviTitleLabel;
/**
 *  返回按钮
 **/
@property (nonatomic,strong) UIButton *backButton;

/**
 *  返回图片
 **/
@property (nonatomic,strong) UIImageView *backImageView;



@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadCustomNavi];
    
}

- (void)loadCustomNavi
{
    self.naviView = [[UIView alloc]init];
    self.naviView.backgroundColor = NavigationColor;
    [self.view addSubview:self.naviView];
    
    if (@available(iOS 11.0, *)) {
        //元素的布局
        [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(0);
            make.top.equalTo(self.view.mas_top).offset(0);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(44);
            make.right.equalTo(self.view.mas_right).offset(0);
            
        }];
    }else{
        //元素的布局
        [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view.mas_left).offset(0);
            make.top.equalTo(self.view.mas_top).offset(0);
            make.right.equalTo(self.view.mas_right).offset(0);
            make.height.mas_equalTo(64);
            
        }];
    }
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.backgroundColor = NavigationColor;
    [self.backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviView addSubview:self.backButton];
    //元素的布局
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.naviView.mas_left).offset(0);
        make.top.equalTo(self.naviView.mas_top).offset(0);
        make.bottom.equalTo(self.naviView.mas_bottom).offset(0);
        make.width.mas_equalTo(50);
        
    }];
    
    CGFloat backW = 8;
    CGFloat backH = 16;
    self.backImageView = [[UIImageView alloc]init];
    self.backImageView.backgroundColor = NavigationColor;
    self.backImageView.image = [UIImage imageNamed:@"nav_back"];
    [self.naviView addSubview:self.backImageView];
    //元素的布局
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.naviView.mas_left).offset(15);
        make.bottom.equalTo(self.naviView.mas_bottom).offset(-15);
        make.width.mas_equalTo(backW);
        make.height.mas_equalTo(backH);
        
    }];
    
    
    self.naviTitleLabel = [[UILabel alloc]init];
    self.naviTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.naviView addSubview:self.naviTitleLabel];
    //元素的布局
    [self.naviTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.naviView.mas_bottom).offset(-10);
        make.width.mas_equalTo(PhoneScreen_WIDTH-100);
        make.height.mas_equalTo(25);
        make.centerX.equalTo(self.naviView.mas_centerX);
    }];
}


- (void)backAction:(UIButton*)sender
{

}

- (void)setIsShowBack:(BOOL)isShowBack
{
    _isShowBack = isShowBack;
    if (!_isShowBack) {
        self.backButton.hidden = YES;
        self.backImageView.hidden = YES;
    }
}

- (void)setTitleForNavi:(NSString *)titleForNavi
{
    _titleForNavi = titleForNavi;
    self.naviTitleLabel.text = titleForNavi;
}
#pragma mark - 菊花Delegate

- (void)hideHUD
{
    [self.progressHUD hideAnimated:YES];
}

- (void)showHUDWithText:(NSString *)text
{
 
    self.progressHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    self.progressHUD.mode = MBProgressHUDModeText;
    // Move to bottm center.
    self.progressHUD.offset = CGPointMake(0.f, 0);
    [self.progressHUD hideAnimated:YES afterDelay:1.5f];

    
    self.progressHUD.detailsLabel.text = NSLocalizedString(text, @"HUD message title");

}


#pragma mark - alerController
- (void)showAlert:(NSString*)content
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:content preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"确定");
    }];
    
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:NO completion:nil];
}


- (MBProgressHUD *)progressHUD{
    
    if (!_progressHUD) {
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    }
    return _progressHUD;
}


@end
