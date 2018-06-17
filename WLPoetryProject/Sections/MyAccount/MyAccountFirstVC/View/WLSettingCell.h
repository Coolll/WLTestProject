//
//  WLSettingCell.h
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/6/16.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLSettingCell : UITableViewCell

/**
 *  标题
 **/
@property (nonatomic,copy) NSString *titleString;

/**
 *  图片
 **/
@property (nonatomic,copy) NSString *iconImageName;

/**
 *  是否展示
 **/
@property (nonatomic, assign) BOOL showLine;
/**
 *  标题
 **/
@property (nonatomic,strong) UILabel *titleLabel;
/**
 *  右侧的箭头
 **/
@property (nonatomic, strong) UIImageView *rightArrow;

@end
