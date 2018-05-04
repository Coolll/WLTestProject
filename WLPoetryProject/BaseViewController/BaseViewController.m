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

#pragma mark - 初始化导航栏

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
    
    //返回按钮
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.backgroundColor = NavigationColor;
    [self.backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviView addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.naviView.mas_left).offset(0);
        make.top.equalTo(self.naviView.mas_top).offset(0);
        make.bottom.equalTo(self.naviView.mas_bottom).offset(0);
        make.width.mas_equalTo(50);
        
    }];
    
    //返回的图片
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
    
    //导航栏标题
    self.naviTitleLabel = [[UILabel alloc]init];
    self.naviTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.naviTitleLabel.font = [UIFont systemFontOfSize:16.f];
    [self.naviView addSubview:self.naviTitleLabel];
    //元素的布局
    [self.naviTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.naviView.mas_bottom).offset(-10);
        make.width.mas_equalTo(PhoneScreen_WIDTH-100);
        make.height.mas_equalTo(25);
        make.centerX.equalTo(self.naviView.mas_centerX);
    }];
}

#pragma mark - 属性设置与点击事件

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

#pragma mark - 添加全屏返回按钮

- (void)addBackButtonForFullScreen
{
    self.naviView.hidden = YES;
    CGFloat backWidth = 30;//返回箭头的宽度
    CGFloat leftSpace = 20;//箭头左侧间距
    CGFloat bottomSpace = 10;//箭头底部间距
    CGFloat touchOffset = 15;//箭头触摸区域超出的offset
    
    //圆形背景
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = NavigationColor;
    backView.layer.cornerRadius = backWidth/2;
    [self.view addSubview:backView];
    //元素的布局
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(leftSpace);
        make.bottom.equalTo(self.naviView.mas_bottom).offset(-bottomSpace);
        make.width.mas_equalTo(backWidth);
        make.height.mas_equalTo(backWidth);
        
    }];
    
    CGFloat backW = 8;
    CGFloat backH = 16;
    //返回图片
    UIImageView *backImageView = [[UIImageView alloc]init];
    backImageView.backgroundColor = NavigationColor;
    backImageView.image = [UIImage imageNamed:@"nav_back"];
    [backView addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(backView.mas_left).offset((backWidth-backW)/2);
        make.top.equalTo(backView.mas_top).offset((backWidth-backH)/2);
        make.width.mas_equalTo(backW);
        make.height.mas_equalTo(backH);
        
    }];
    
    //点击响应的按钮
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    clearBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:clearBtn];
    //元素的布局
    [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(leftSpace-touchOffset);
        make.bottom.equalTo(self.naviView.mas_bottom).offset(-bottomSpace+touchOffset);
        make.width.mas_equalTo(backWidth+touchOffset*2);
        make.height.mas_equalTo(backWidth+touchOffset*2);
    }];
    
    //如果没有标题，则不创建
    if (![self.titleForNavi isKindOfClass:[NSString class]] || self.titleForNavi.length < 1) {
        return;
    }
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:18.f];
    titleLabel.text = self.titleForNavi;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    CGFloat titleW = PhoneScreen_WIDTH-(leftSpace+backWidth+10)*2;
    CGFloat titleHeight = [WLPublicTool heightForTextString:self.titleForNavi width:titleW fontSize:18.f];
    
    //元素的布局
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.naviView.mas_bottom).offset(-30);
        make.centerX.equalTo(self.naviView.mas_centerX);
        make.width.mas_equalTo(titleW);
        make.height.mas_equalTo(titleHeight);
        
    }];
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
