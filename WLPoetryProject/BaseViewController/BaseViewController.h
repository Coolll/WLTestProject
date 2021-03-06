//
//  BaseViewController.h
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/1.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
/**
   导航栏
 **/
@property (nonatomic,strong) UIView *naviView;
/**
 *  导航栏标题
 **/
@property (nonatomic,copy) NSString *titleForNavi;

/**
 *  是否展示返回按钮，默认yes
 **/
@property (nonatomic,assign) BOOL isShowBack;

/**
 *  全屏状态下，标题label
 **/
@property (nonatomic,strong) UILabel *titleFullLabel;

/**
 *  导航栏的颜色
 **/
@property (nonatomic,strong) UIColor *naviColor;




- (void)hideHUD;//隐藏loading

- (void)showLoadingHUDWithText:(NSString*)text;//loading框



- (void)showHUDWithText:(NSString *)text;

- (void)showAlert:(NSString*)content;

//需要复写该方法
- (void)backAction:(UIButton*)sender;

//移除掉所有导航栏的元素，当自定义导航栏时使用
- (void)removeAllNaviItems;

//全屏状态下，移除navi，添加返回按钮，需要最后调用，保证返回按钮不被遮挡
- (void)addBackButtonForFullScreen;


//全屏状态下，移除navi，添加标题，需要在设置titleForNavi后调用
- (void)addFullTitleLabel;


@end
