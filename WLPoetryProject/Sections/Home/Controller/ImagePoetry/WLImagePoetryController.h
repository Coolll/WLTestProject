//
//  WLImagePoetryController.h
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/6/27.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^ImagePoetryFinishBlock) (NSString*poetryContent,BOOL isVertical);

@interface WLImagePoetryController : BaseViewController
/**
 *  原始诗词
 **/
@property (nonatomic,copy) NSString *poetryString;
/**
 *  是否为垂直排版
 **/
@property (nonatomic,assign) BOOL isVertical;



- (void)finishEditContentWithBlock:(ImagePoetryFinishBlock)block;

@end
