//
//  WLHomePoetryCell.h
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/7/12.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoetryModel.h"

@interface WLHomePoetryCell : UITableViewCell
/**
 *  数据model
 **/
@property (nonatomic,strong) PoetryModel *dataModel;

/**
 *  线条颜色
 **/
@property (nonatomic,strong) UIColor *lineColor;
/**
 *  是否为最后一行，需要调整间距
 **/
@property (nonatomic,assign) BOOL isLast;
/**
 *  是否为第一行，需要调整间距
 **/
@property (nonatomic,assign) BOOL isFirst;

+ (CGFloat)heightForFirstLine:(PoetryModel*)model;
+ (CGFloat)heightForLastCell:(PoetryModel*)model;

@end
