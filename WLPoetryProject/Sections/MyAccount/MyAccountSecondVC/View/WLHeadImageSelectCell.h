//
//  WLHeadImageSelectCell.h
//  WLPoetryProject
//
//  Created by 龙培 on 2020/6/11.
//  Copyright © 2020年 龙培. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^headImageSelectBlock)(NSInteger rowIndex,NSInteger imageIndex,NSString *imageUrl);
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
 *  第几行
 **/
@property (nonatomic,assign) NSInteger rowIndex;
/**
 *  第几个
 **/
@property (nonatomic,assign) NSInteger imageIndex;

/**
 *  当前行是否选中
 **/
@property (nonatomic,assign) BOOL containSelected;
/**
 *  当前行选中的index
 **/
@property (nonatomic,assign) NSInteger currentSelectIndex;

- (void)loadCustomCellWithCompletion:(headImageSelectBlock)block;

@end

NS_ASSUME_NONNULL_END
