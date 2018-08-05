//
//  WLPoetryContentCell.h
//  WLPoetryProject
//
//  Created by 龙培 on 2018/5/5.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLPoetryContentCell : UITableViewCell

/**
 *  诗句内容
 **/
@property (nonatomic,copy) NSString *contentString;



+ (CGFloat)heightForContent:(NSString*)content withWidth:(CGFloat)width;

@end
