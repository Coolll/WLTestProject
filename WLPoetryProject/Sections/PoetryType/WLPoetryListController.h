//
//  WLPoetryListController.h
//  WLPoetryProject
//
//  Created by 龙培 on 2018/5/7.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger , PoetrySource) {
    PoetrySourceGradeOne,
    PoetrySourceGradeTwo
};

@interface WLPoetryListController : BaseViewController
/**
 *  诗词类型
 **/
@property (nonatomic,assign) PoetrySource source;


@end
