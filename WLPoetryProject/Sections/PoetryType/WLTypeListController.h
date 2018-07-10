//
//  WLTypeListController.h
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/7/10.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^LastPoetryTypeBlock)(NSDictionary *info);

@interface WLTypeListController : BaseViewController

/**
 *   数据源
 **/
@property (nonatomic, copy) NSArray *typeDataArray;

//上次浏览记录
- (void)loadLastSelectWithBlock:(LastPoetryTypeBlock)block;

@end
