//
//  BaseViewController.m
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/1.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

static const CGFloat backFullWidth = 30;//返回箭头的宽度 全屏下
static const CGFloat leftFullSpace = 20;//箭头左侧间距 全屏下
static const CGFloat bottomFullSpace = 10;//箭头底部间距 全屏下
static const CGFloat touchFullOffset = 15;//箭头触摸区域超出的offset 全屏下

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
    
    self.naviView.backgroundColor = NavigationColor;
    
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
    self.naviTitleLabel.backgroundColor = NavigationColor;
}

- (void)setNaviColor:(UIColor *)naviColor
{
    _naviColor = naviColor;
    if ([naviColor isKindOfClass:[UIColor class]]) {
        self.naviView.backgroundColor = naviColor;
        self.backButton.backgroundColor = naviColor;
        self.backImageView.backgroundColor = naviColor;
        self.naviTitleLabel.backgroundColor = naviColor;
        
    }
}
#pragma mark - 属性设置与点击事件

- (void)backAction:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)removeAllNaviItems
{
    for (UIView *view in self.naviView.subviews) {
        [view removeFromSuperview];
    }
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
    
    //圆形背景
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = NavigationColor;
    backView.layer.cornerRadius = backFullWidth/2;
    [self.view addSubview:backView];
    //元素的布局
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(leftFullSpace);
        make.bottom.equalTo(self.naviView.mas_bottom).offset(-bottomFullSpace);
        make.width.mas_equalTo(backFullWidth);
        make.height.mas_equalTo(backFullWidth);
        
    }];
    
    CGFloat backW = 8;
    CGFloat backH = 16;
    //返回图片
    UIImageView *backImageView = [[UIImageView alloc]init];
    backImageView.backgroundColor = NavigationColor;
    backImageView.image = [UIImage imageNamed:@"nav_back"];
    [backView addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(backView.mas_left).offset((backFullWidth-backW)/2);
        make.top.equalTo(backView.mas_top).offset((backFullWidth-backH)/2);
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
        
        make.left.equalTo(self.view.mas_left).offset(leftFullSpace-touchFullOffset);
        make.bottom.equalTo(self.naviView.mas_bottom).offset(-bottomFullSpace+touchFullOffset);
        make.width.mas_equalTo(backFullWidth+touchFullOffset*2);
        make.height.mas_equalTo(backFullWidth+touchFullOffset*2);
    }];
    

   
}


- (void)addFullTitleLabel
{
    //如果没有标题，则不创建
    if (![self.titleForNavi isKindOfClass:[NSString class]] || self.titleForNavi.length < 1) {
        return;
    }
    
    self.titleFullLabel = [[UILabel alloc]init];
    self.titleFullLabel.font = [AppConfig config].titleFont;
    self.titleFullLabel.text = self.titleForNavi;
    self.titleFullLabel.numberOfLines = 0;
    self.titleFullLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleFullLabel];
    
    CGFloat titleW = PhoneScreen_WIDTH-(leftFullSpace+backFullWidth+10)*2;
    CGFloat titleHeight = [WLPublicTool heightForTextString:self.titleForNavi width:titleW fontSize:self.titleFullLabel.font.pointSize]+2;
    
    //元素的布局
    [self.titleFullLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
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

- (void)showLoadingHUDWithText:(NSString*)text
{
    self.progressHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    self.progressHUD.mode = MBProgressHUDModeText;
    self.progressHUD.offset = CGPointMake(0.f, 0);
    self.progressHUD.detailsLabel.text = NSLocalizedString(text, @"HUD message title");
}

- (void)showHUDWithText:(NSString *)text
{
 
    self.progressHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    self.progressHUD.mode = MBProgressHUDModeText;
    self.progressHUD.offset = CGPointMake(0.f, 0);
    [self.progressHUD hideAnimated:YES afterDelay:1.5f];
    self.progressHUD.detailsLabel.text = NSLocalizedString(text, @"HUD message title");

}

#pragma mark - 分享
- (void)shareWithImageArray:(NSArray*)array
{
    
    if (array && array.count > 0) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"题画"
                                         images:array
                                            url:nil
                                          title:@"梅花瘦"
                                           type:SSDKContentTypeAuto];
        [shareParams SSDKEnableUseClientShare];
        
        
        [ShareSDK showShareActionSheet:nil customItems:nil shareParams:shareParams sheetConfiguration:nil onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
            switch (state) {
                case SSDKResponseStateSuccess:
                {
                    [self showHUDWithText:@"成功"];
                    break;
                }
                case SSDKResponseStateFail:
                {
                    [self showHUDWithText:[NSString stringWithFormat:@"失败：%@",error]];
                    break;
                }
                case SSDKResponseStateCancel:
                {
                    if (platformType != SSDKPlatformTypeUnknown) {
                        [self showHUDWithText:@"取消分享"];
                        
                    }
                    
                }
                    break;
                default:
                    break;
            }
        }];
        
    }
    
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
#pragma mark 导航栏标题

- (UILabel*)naviTitleLabel
{
    if (!_naviTitleLabel) {
        _naviTitleLabel = [[UILabel alloc]init];
        _naviTitleLabel.textColor = [UIColor whiteColor];
        _naviTitleLabel.textAlignment = NSTextAlignmentCenter;
        _naviTitleLabel.font = [UIFont systemFontOfSize:16.f];
        _naviTitleLabel.numberOfLines = 0;
        [self.naviView addSubview:_naviTitleLabel];
        //元素的布局
        [_naviTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.naviView.mas_bottom).offset(-10);
            make.width.mas_equalTo(PhoneScreen_WIDTH-100);
            make.height.mas_equalTo(25);
            make.centerX.equalTo(self.naviView.mas_centerX);
        }];
    }
    return _naviTitleLabel;
}

- (UIView*)naviView
{
    if (!_naviView) {
        
        _naviView = [[UIView alloc]init];
        [self.view addSubview:_naviView];
        
        if (@available(iOS 11.0, *)) {
            //元素的布局
            [_naviView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(0);
                make.top.equalTo(self.view.mas_top).offset(0);
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(44);
                make.right.equalTo(self.view.mas_right).offset(0);
                
            }];
        }else{
            //元素的布局
            [_naviView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(self.view.mas_left).offset(0);
                make.top.equalTo(self.view.mas_top).offset(0);
                make.right.equalTo(self.view.mas_right).offset(0);
                make.height.mas_equalTo(64);
                
            }];
        }
    }
    return _naviView;
}

@end
