//
//  WLImageController.h
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/6/25.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger,PoetryDirection) {
    PoetryDirectionHorizon,//水平排版
    PoetryDirectionVerticalLeft,//垂直 从左侧开始第一句
    PoetryDirectionVerticalRight//垂直 从右侧开始第一句
};
typedef void(^SaveImageBlock)(void);

@interface WLImageController : BaseViewController
/**
 *  排版
 **/
@property (nonatomic, assign) PoetryDirection direction;

/**
 *  背景图片名
 **/
@property (nonatomic, copy) NSString *imageName;

- (void)configureUI;

- (void)saveImageWithBlock:(SaveImageBlock)block;

@end
