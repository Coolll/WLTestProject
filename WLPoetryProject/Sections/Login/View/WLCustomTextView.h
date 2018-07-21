//
//  WLCustomTextView.h
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/14.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLTextField.h"

@interface WLCustomTextView : UIView

/**
 *  文本
 **/
@property (nonatomic,copy) NSString *placeHolderString;

/**
 *  左侧间距
 **/
@property (nonatomic,assign) CGFloat leftSpace;


/**
 *  文本内容
 **/
@property (nonatomic,copy) NSString *contentString;

/**
 *  键盘类型
 **/
@property (nonatomic,assign) UIKeyboardType keyboardType;

/**
 *  用户设置的文本
 **/
@property (nonatomic,copy) NSString *textForUser;

/**
 *  placeLabel的位置
 **/
@property (nonatomic,assign) CGRect placeLabelFrame;

/**
 *  输入框
 **/
@property (nonatomic,strong) WLTextField *mainTextField;

/**
 *  限制输入的长度
 **/
@property (nonatomic,assign) NSInteger canInputLength;



- (void)loadEndEditingText:(void(^)(NSString *contentString))block;

@end
