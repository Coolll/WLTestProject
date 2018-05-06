//
//  AppConfig.m
//  WLPoetryProject
//
//  Created by 龙培 on 2018/5/6.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "AppConfig.h"

@implementation AppConfig
+ (AppConfig *)config
{
    static AppConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[AppConfig alloc] init];
    });
    return config;
}

- (UIFont*)titleFont
{
    UIFont *font = [UIFont systemFontOfSize:19];
    return font;
}

- (UIFont*)contentFont
{
    UIFont *font = [UIFont systemFontOfSize:16];
    return font;
}

- (UIFont*)itemFont
{
    UIFont *font = [UIFont systemFontOfSize:14];
    return font;
}
@end
