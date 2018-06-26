//
//  WLImageController.m
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/6/25.
//  Copyright © 2018年 龙培. All rights reserved.
//

static const CGFloat itemWidth = 80;
static const CGFloat imageW = 20;

#import "WLImageController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface WLImageController ()
/**
 *  图片
 **/
@property (nonatomic, strong) UIImageView *mainImageView;

/**
 *  文本内容
 **/
@property (nonatomic,strong) UIView *poetryView;



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
    self.poetryView.backgroundColor = [UIColor clearColor];
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

- (void)loadPoetryContentAction:(UIButton*)sender
{
    NSLog(@"push to poetry content");
    [self shareAction];
}

//分享
- (void)shareAction
{
    NSArray* imageArray = @[[UIImage imageNamed:@"classNine.jpg"]];
    
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"题画"
                                         images:imageArray
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

- (UIView*)poetryView
{
    if (!_poetryView) {
        _poetryView = [[UIView alloc]init];
        _poetryView.userInteractionEnabled = YES;
        self.mainImageView.userInteractionEnabled = YES;
        [self.mainImageView addSubview:_poetryView];
        //元素的布局
        [_poetryView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.titleFullLabel.mas_bottom).offset(20);
            make.right.equalTo(self.view.mas_right).offset(-20);
            make.width.mas_equalTo(itemWidth);
            make.height.mas_equalTo(itemWidth);
        }];
        
        UIImageView *poetryImage = [[UIImageView alloc]init];
        poetryImage.image = [UIImage imageNamed:@"poetryContent"];
        [_poetryView addSubview:poetryImage];
        //元素的布局
        [poetryImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_poetryView.mas_left).offset((itemWidth-imageW)/2);
            make.top.equalTo(_poetryView.mas_top).offset(15);
            make.width.mas_equalTo(imageW);
            make.height.mas_equalTo(imageW);
            
        }];
        
        UILabel *tipLabel = [[UILabel alloc]init];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.text = @"诗词内容";
        tipLabel.font = [UIFont systemFontOfSize:14.f];
        [_poetryView addSubview:tipLabel];
        //元素的布局
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_poetryView.mas_left).offset(0);
            make.top.equalTo(poetryImage.mas_bottom).offset(10);
            make.right.equalTo(_poetryView.mas_right).offset(0);
            make.height.mas_equalTo(20);
            
        }];
        
        UIButton *contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [contentBtn addTarget:self action:@selector(loadPoetryContentAction:) forControlEvents:UIControlEventTouchUpInside];
        contentBtn.enabled = YES;
        [_poetryView addSubview:contentBtn];
        //元素的布局
        [contentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_poetryView.mas_left).offset(0);
            make.top.equalTo(_poetryView.mas_top).offset(0);
            make.bottom.equalTo(_poetryView.mas_bottom).offset(0);
            make.right.equalTo(_poetryView.mas_right).offset(0);
            
        }];
    }
    return _poetryView;
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
