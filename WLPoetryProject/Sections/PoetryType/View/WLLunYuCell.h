//
//  WLLunYuCell.h
//  WLPoetryProject
//
//  Created by 龙培 on 2019/4/5.
//  Copyright © 2019年 龙培. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoetryModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WLLunYuCell : UITableViewCell
/**
 *  内容
 **/
@property (nonatomic,copy) NSString *contentString;
/**
 *  来源
 **/
@property (nonatomic,copy) NSString *source;
/**
 *  注解
 **/
@property (nonatomic,copy) NSString *transferString;

/**
 *  诗词model
 **/
@property (nonatomic,strong) PoetryModel *model;

/**
 *  是否展开注解
 **/
@property (nonatomic,assign) BOOL isShowTransfer;
/**
 *  是否最后一行
 **/
@property (nonatomic,assign) BOOL isLast;
/**
 *  是否展示翻译
 **/
@property (nonatomic,assign) BOOL showTransfer;

- (void)loadCellContent;

+ (CGFloat)heightForCellWithModel:(PoetryModel*)model isShow:(BOOL)isShow;

@end

NS_ASSUME_NONNULL_END
