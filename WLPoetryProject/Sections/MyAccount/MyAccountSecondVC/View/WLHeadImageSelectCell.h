//
//  WLHeadImageSelectCell.h
//  WLPoetryProject
//
//  Created by 龙培 on 2020/6/11.
//  Copyright © 2020年 龙培. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WLHeadImageSelectCell : UITableViewCell
/**
 *   第一张图
 **/
@property (nonatomic,copy) NSString *oneImageUrlString;
/**
 *   第二张图
 **/
@property (nonatomic,copy) NSString *twoImageUrlString;
/**
 *   第三张图
 **/
@property (nonatomic,copy) NSString *threeImageUrlString;

/**
 *  是否本地图片
 **/
@property (nonatomic,assign) BOOL isLocalImage;


- (void)loadCustomCell;

@end

NS_ASSUME_NONNULL_END
