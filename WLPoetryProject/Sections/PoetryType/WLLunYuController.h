//
//  WLLunYuController.h
//  WLPoetryProject
//
//  Created by 龙培 on 2019/4/5.
//  Copyright © 2019年 龙培. All rights reserved.
//

#import "BaseViewController.h"

@interface WLLunYuController : BaseViewController

/**
 *   数据源
 **/
@property (nonatomic, copy) NSArray *typeDataArray;

/**
 *  当前类型 本地json文件名
 **/
@property (nonatomic,copy) NSString *jsonName;
/**
 *  当前类型 的mainClass
 **/
@property (nonatomic,copy) NSString *mainClass;

- (void)loadCustomData;

@end


