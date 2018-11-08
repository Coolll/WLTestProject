//
//  WLRecitePoetryCell.h
//  WLPoetryProject
//
//  Created by 变啦 on 2018/11/7.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLRecitePoetryCell : UITableViewCell

/**
 *  诗句内容
 **/
@property (nonatomic,copy) NSString *contentString;
/**
 *  是否需要隐藏
 **/
@property (nonatomic,assign) BOOL needHide;

/**
 *  高度
 **/
@property (nonatomic,assign) CGFloat cellHeight;




+ (CGFloat)heightForContent:(NSString*)content withWidth:(CGFloat)width;

@end
