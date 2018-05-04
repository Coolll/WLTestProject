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



- (void)showHUDWithText:(NSString *)text;

- (void)showAlert:(NSString*)content;

- (void)backAction:(UIButton*)sender;

//全屏状态下，移除navi，添加返回按钮，需要最后调用，保证返回按钮不被遮挡
- (void)addBackButtonForFullScreen;


@end
