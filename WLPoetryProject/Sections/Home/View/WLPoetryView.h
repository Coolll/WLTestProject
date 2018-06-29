//
//  WLPoetryView.h
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/6/29.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,PoetryDirection) {
    PoetryDirectionHorizon,//水平排版
    PoetryDirectionVerticalLeft,//垂直 从左侧开始第一句
    PoetryDirectionVerticalRight//垂直 从右侧开始第一句
};

@interface WLPoetryView : UIView

- (instancetype)initWithContent:(NSString*)content;

/**
 *  排版
 **/
@property (nonatomic, assign) PoetryDirection direction;

@end
