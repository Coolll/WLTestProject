//
//  WLLaunchView.m
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/7/5.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLLaunchView.h"
@interface WLLaunchView()
/**
 *  跳过按钮
 **/
@property (nonatomic, strong) UIButton *skipBtn;
/**
 *  定时器
 **/
@property (nonatomic, strong) NSTimer *timer;
/**
 *  倒计时总计
 **/
@property (nonatomic, assign) NSInteger totalTime;

@end
@implementation WLLaunchView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadCustomData];
        
        [self loadCustomImage];
        [self loadTimer];
    }
    return self;
}

- (void)loadCustomData
{
    self.totalTime = 4;
}


- (void)loadCustomImage{
    
    //    CGSize viewSize = [UIApplication sharedApplication].keyWindow.bounds.size;
    //    NSString*viewOrientation =@"Portrait";//横屏请设置成 @"Landscape"
    //    NSString*launchImage =nil;
    //    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    //    for(NSDictionary* dict in imagesDict) {
    //        CGSize imageSize =CGSizeFromString(dict[@"UILaunchImageSize"]);
    //        if(CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
    //            launchImage = dict[@"UILaunchImageName"];
    //        }
    //    }
    
    self.launchView = [[UIImageView alloc] init];
    [self addSubview:self.launchView];
    
    //设置UI布局约束
    [self.launchView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(0);//元素顶部约束
        make.leading.equalTo(self.mas_leading).offset(0);//元素左侧约束
        make.trailing.equalTo(self.mas_trailing).offset(0);//元素右侧约束
        make.bottom.equalTo(self.mas_bottom).offset(0);//元素底部约束
        
    }];
    
    
    self.skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.skipBtn.layer.cornerRadius = 6;
    self.skipBtn.backgroundColor = RGBCOLOR(200, 200, 200, 1.0);
    [self.skipBtn setTitle:[NSString stringWithFormat:@"跳过 %ld",(long)self.totalTime] forState:UIControlStateNormal];
    [self.skipBtn addTarget:self action:@selector(skipAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.skipBtn];
    
    
    CGFloat btnWidth = 80;
    if (@available(iOS 11.0, *)) {
        //元素的布局
        [self.skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(40);
            make.trailing.equalTo(self.mas_trailing).offset(-40);
            make.width.mas_equalTo(btnWidth);
            make.height.mas_equalTo(40);
        }];
    }else{
        //元素的布局
        [self.skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.mas_top).offset(40);
            make.trailing.equalTo(self.mas_trailing).offset(-40);
            make.width.mas_equalTo(btnWidth);
            make.height.mas_equalTo(40);
            
        }];
    }
    
}


- (void)loadTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)timerAction
{
    NSString *title = [NSString stringWithFormat:@"跳过 %ld",(long)self.totalTime];
    [self.skipBtn setTitle:title forState:UIControlStateNormal];
    
    if (self.totalTime == 0) {
        
        [self.skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
        [self skipAction:nil];
        
    }else{
        self.totalTime  -= 1;
    }
    
}

- (void)setBgImage:(UIImage *)bgImage
{
    _bgImage = bgImage;
    
    if (bgImage) {
        self.launchView.image = bgImage;
    }
    
}

- (void)skipAction:(UIButton*)sender
{
    NSLog(@"跳过=====");
    [self.timer invalidate];
    self.timer = nil;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)dealloc
{
    NSLog(@"销毁launch");
}

@end
