//
//  WLClassInfoController.h
//  WLPoetryProject
//
//  Created by 变啦 on 2018/11/28.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "BaseViewController.h"

@interface WLClassInfoController : BaseViewController
/**
 *  勋章图片数组
 **/
@property (nonatomic,copy) NSArray *imageArray;
/**
 *  等级数组
 **/
@property (nonatomic,copy) NSArray *titleArray;

- (void)loadCustomView;

@end
