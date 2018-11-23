//
//  WLPercentView.h
//  WLPoetryProject
//
//  Created by 变啦 on 2018/11/23.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLPercentView : UIView
/**
 *  进度 0-1
 */
@property (nonatomic,assign) CGFloat progress;
/**
 *  圆环的宽度
 **/
@property (nonatomic,assign) CGFloat frameWidth;;
/**
 *  圆环的高度
 **/
@property (nonatomic,assign) CGFloat frameHeight;

- (void)loadCustomLayer;

@end
