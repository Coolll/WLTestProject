//
//  WLReadImageCell.h
//  WLPoetryProject
//
//  Created by 龙培 on 2020/10/13.
//  Copyright © 2020 龙培. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ReadImageEffectBlock)(BOOL on);
@interface WLReadImageCell : UITableViewCell

/**
 *  标题
 **/
@property (nonatomic,copy) NSString *titleString;
/**
 *  是否展示线条
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

/**
 *  是否需要开关
 **/
@property (nonatomic,assign) BOOL needSwitch;
/**
 *  开关状态
 **/
@property (nonatomic,assign) BOOL switchOpen;


- (void)loadCustomView;

- (void)updateWithSwitchBlock:(ReadImageEffectBlock)block;
@end

NS_ASSUME_NONNULL_END