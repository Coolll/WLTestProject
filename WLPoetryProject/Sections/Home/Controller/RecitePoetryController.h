//
//  RecitePoetryController.h
//  WLPoetryProject
//
//  Created by 变啦 on 2018/11/5.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "BaseViewController.h"
#import "PoetryModel.h"
@interface RecitePoetryController : BaseViewController
/**
 *  诗词内容数组
 **/
@property (nonatomic,copy) NSArray *dataArray;
/**
 *  数据
 **/
@property (nonatomic,strong) PoetryModel *dataModel;
- (void)loadCustomView;

@end
