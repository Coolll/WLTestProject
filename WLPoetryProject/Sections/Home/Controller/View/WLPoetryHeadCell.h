//
//  WLPoetryHeadCell.h
//  WLPoetryProject
//
//  Created by 变啦 on 2018/11/8.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLPoetryHeadCell : UITableViewCell
/**
 *  诗词
 **/
@property (nonatomic,copy) NSString *name;
/**
 *  作者
 **/
@property (nonatomic,copy) NSString *author;

- (void)loadCustomView;


@end
