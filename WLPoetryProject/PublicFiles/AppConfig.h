//
//  AppConfig.h
//  WLPoetryProject
//
//  Created by 龙培 on 2018/5/6.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppConfig : NSObject

+ (AppConfig *)config;

/**
 *  诗词的标题字体
 **/
@property (nonatomic,strong) UIFont *titleFont;

/**
 *  诗词的内容字体
 **/
@property (nonatomic,strong) UIFont *contentFont;
/**
 *  列表项的字体
 **/
@property (nonatomic,strong) UIFont *itemFont;




@end
