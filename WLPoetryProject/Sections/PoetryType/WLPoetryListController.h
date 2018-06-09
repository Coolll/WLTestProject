//
//  WLPoetryListController.h
//  WLPoetryProject
//
//  Created by 龙培 on 2018/5/7.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "BaseViewController.h"

@interface WLPoetryListController : BaseViewController

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
