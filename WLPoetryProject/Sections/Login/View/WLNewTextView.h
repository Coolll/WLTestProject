//
//  WLNewTextView.h
//  WLPoetryProject
//
//  Created by 变啦 on 2018/8/23.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTextView.h"
typedef void(^ReturnKeyBlock) (void);

@interface WLNewTextView : UIView
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
 *  回车类型
 **/
@property (nonatomic,assign) UIReturnKeyType returnType;


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
@property (nonatomic,strong) MyTextView *mainTextView;

/**
 *  限制输入的长度
 **/
@property (nonatomic,assign) NSInteger canInputLength;



- (void)loadEndEditingText:(void(^)(NSString *contentString))block;

- (void)loadReturnKeyAction:(ReturnKeyBlock)block;

@end
