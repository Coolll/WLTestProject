//
//  WLTypeListCell.h
//  WLPoetryProject
//
//  Created by 龙培 on 2018/6/9.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLTypeListCell : UITableViewCell
/**
 *  类型文本
 **/
@property (nonatomic,copy) NSString *typeString;

/**
 *  是否需要分割线，默认需要
 **/
@property (nonatomic, assign) BOOL needLine;

/**
 *  左侧的图标，默认是书，可以自己传入图片名
 **/
@property (nonatomic, copy) NSString *imageName;
@end
