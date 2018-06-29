//
//  WLImageSearchController.h
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/6/29.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "BaseViewController.h"
#import "PoetryModel.h"

typedef void(^WLImageSelBlock) (PoetryModel*model);

@interface WLImageSearchController : BaseViewController

- (void)selectPoetryWithBlock:(WLImageSelBlock)block;

@end
