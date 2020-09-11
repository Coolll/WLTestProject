//
//  AppConfig.h
//  WLPoetryProject
//
//  Created by 龙培 on 2018/5/6.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^BgImageBlock)(NSDictionary*thumbDic, NSDictionary*originDic,NSError *error);

typedef void(^HeadImageRequestBlock)(NSArray *originArray,NSArray *thumbArray,NSError *error);

@interface AppConfig : NSObject

+ (AppConfig *)config;

/**
 *  诗词的标题字体
 **/
@property (nonatomic,strong) UIFont *titleFont;
/**
 *  诗词的标题字体
 **/
@property (nonatomic,strong) UIFont *authorFont;
/**
 *  诗词的内容字体
 **/
@property (nonatomic,strong) UIFont *contentFont;
/**
 *  列表项的字体
 **/
@property (nonatomic,strong) UIFont *itemFont;

/**
 *  诗词类别与诗词背景图片的对应info
 **/
@property (nonatomic,strong) NSMutableDictionary *bgImageInfo;
/**
 *  诗词类别与诗词背景图片的对应info
 **/
@property (nonatomic,strong) NSMutableDictionary *bgOriginImageInfo;

/**
 *  全部的诗词数据
 **/
@property (nonatomic,strong) NSArray *allPoetryList;

//- (void)loadClassImageWithBlock:(void(^)(NSDictionary*dic))block;

- (void)loadAllBgImageWithBlock:(BgImageBlock)block;

- (void)loadAllHeadImageWithBlock:(HeadImageRequestBlock)block;

- (void)loadAllClassImageInfo;


@end
