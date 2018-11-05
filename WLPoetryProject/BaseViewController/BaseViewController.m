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
#import <Photos/Photos.h>
static const CGFloat backFullWidth = 24;//返回箭头的宽度 全屏下
static const CGFloat leftFullSpace = 20;//箭头左侧间距 全屏下
static const CGFloat bottomFullSpace = 10;//箭头底部间距 全屏下
static const CGFloat touchFullOffset = 15;//箭头触摸区域超出的offset 全屏下

@interface BaseViewController ()

@property (nonatomic,strong)MBProgressHUD *progressHUD;

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
        
        make.leading.equalTo(self.naviView.mas_leading).offset(0);
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
        
        make.leading.equalTo(self.naviView.mas_leading).offset(15);
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
    self.backView = [[UIView alloc]init];
    self.backView.backgroundColor = NavigationColor;
    self.backView.layer.cornerRadius = backFullWidth/2;
    [self.view addSubview:self.backView];
    //元素的布局
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.view.mas_leading).offset(leftFullSpace);
        make.width.mas_equalTo(backFullWidth);
        make.height.mas_equalTo(backFullWidth);
    }];
    
    CGFloat backW = 7;
    CGFloat backH = 14;
    //返回图片
    UIImageView *backImageView = [[UIImageView alloc]init];
    backImageView.backgroundColor = NavigationColor;
    backImageView.image = [UIImage imageNamed:@"nav_back"];
    [self.backView addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.backView.mas_leading).offset((backFullWidth-backW)/2);
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
        
        make.leading.equalTo(self.view.mas_leading).offset(leftFullSpace-touchFullOffset);
        make.width.mas_equalTo(backFullWidth+touchFullOffset*2);
        make.height.mas_equalTo(backFullWidth+touchFullOffset*2);
    }];
    
    
    if (self.titleFullLabel) {
        [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleFullLabel.mas_centerY);
        }];
        
        [backImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleFullLabel.mas_centerY);
        }];
        [clearBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleFullLabel.mas_centerY);
        }];
        
    }else{
        [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.naviView.mas_bottom).offset(-bottomFullSpace);
        }];
        
        [backImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backView.mas_top).offset((backFullWidth-backH)/2);
        }];
        
        [clearBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.naviView.mas_bottom).offset(-bottomFullSpace+touchFullOffset);
        }];
    }

   
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
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        
        self.progressHUD.mode = MBProgressHUDModeText;
        self.progressHUD.offset = CGPointMake(0.f, 0);
        [self.progressHUD hideAnimated:YES afterDelay:1.5f];
        self.progressHUD.detailsLabel.text = NSLocalizedString(text, @"HUD message title");

    });
 
    
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
                    [self showHUDWithText:[NSString stringWithFormat:@"分享失败"]];
                    NSLog(@"error:%@",error);

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

#pragma mark - 保存图片到本地
#pragma mark 授权判断
- (void)saveImage:(UIImage*)image withCollectionName:(NSString*)name withCompletion:(SaveImageCompletionBlock)block
{
    //获取当前App的相册授权状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    if (status == PHAuthorizationStatusAuthorized) {
        //已授权 则执行保存图片操作
        [self saveAction:image toCollectionName:name withBlock:block];
    }else if (status == PHAuthorizationStatusNotDetermined){
        //未决定过，则弹出授权框
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            //用户点击了授权，则保存图片
            if (status == PHAuthorizationStatusAuthorized) {
                [self saveAction:image toCollectionName:name withBlock:block];
            }
            
        }];
    }else{
        //未授权，则需要前往设置界面保存
        [self showHUDWithText:@"请在设置界面授权访问相册～"];
        if (block) {
            block(NO,nil);
        }
    }
}

#pragma mark 保存图片
- (void)saveAction:(UIImage*)image toCollectionName:(NSString*)name withBlock:(SaveImageCompletionBlock)block
{
    //获取相片库对象
    PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
    
    //调用perform方法
    [library performChanges:^{
        //创建一个相册变动请求
        PHAssetCollectionChangeRequest *collectionRequest;
        
        //取出指定名称的相册
        PHAssetCollection *assetCollection = [self getCurrentPhotoCollectionWithTitle:name];
        
        //判断相册是否存在
        if (assetCollection) {
            //存在，则使用当前的相册创建相册请求
            collectionRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
            
        }else{
            //不存在，则创建一个新的相册请求
            collectionRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:name];
        }
        
        //根据传入的相片，创建相片变动请求
        PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        
        //创建一个占位对象
        PHObjectPlaceholder *placeholder = [assetRequest placeholderForCreatedAsset];
        
        //将占位对象添加到相册请求中
        [collectionRequest addAssets:@[placeholder]];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        if (success) {
//            [self showHUDWithText:@"保存成功"];
        }else{
            [self showHUDWithText:@"保存失败"];
        }
        
        if (block) {
            block(success,error);
        }
    }];
}

- (PHAssetCollection*)getCurrentPhotoCollectionWithTitle:(NSString*)name
{
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *assetCollection in result) {
        if ([assetCollection.localizedTitle containsString:name]) {
            return assetCollection;
        }
    }
    return nil;
}
#pragma mark - alerController
- (void)showAlert:(NSString*)content
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:content preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"确定");
        }];
        
        [alertController addAction:action];
        
        [self presentViewController:alertController animated:NO completion:nil];
    });
    
}

- (void)showAlert:(NSString*)content withBlock:(AlertBlock)sureBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:content preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
            if (sureBlock) {
                sureBlock(NO);
            }
            
        }];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"确定");
            if (sureBlock) {
                sureBlock(YES);
            }
            
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:sureAction];
        [self presentViewController:alertController animated:NO completion:nil];
    });
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
                
                make.leading.equalTo(self.view.mas_safeAreaLayoutGuideLeading).offset(0);
                make.top.equalTo(self.view.mas_top).offset(0);
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(44);
                make.trailing.equalTo(self.view.mas_trailing).offset(0);
                
            }];
        }else{
            //元素的布局
            [_naviView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.leading.equalTo(self.view.mas_leading).offset(0);
                make.top.equalTo(self.view.mas_top).offset(0);
                make.trailing.equalTo(self.view.mas_trailing).offset(0);
                make.height.mas_equalTo(64);
                
            }];
        }
    }
    return _naviView;
}

@end
