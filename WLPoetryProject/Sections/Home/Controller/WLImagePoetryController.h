//
//  WLImagePoetryController.h
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/6/27.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^ImagePoetryFinishBlock) (NSString*poetryContent);

@interface WLImagePoetryController : BaseViewController

- (void)finishEditContentWithBlock:(ImagePoetryFinishBlock)block;

@end
