//
//  WLPoetryListCell.h
//  WLPoetryProject
//
//  Created by 龙培 on 2018/4/21.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoetryModel.h"

@interface WLPoetryListCell : UITableViewCell
/**
 *  数据model
 **/
@property (nonatomic,strong) PoetryModel *dataModel;

/**
 *  线条颜色
 **/
@property (nonatomic,strong) UIColor *lineColor;

+ (CGFloat)heightForFirstLine:(PoetryModel*)model;

@end
