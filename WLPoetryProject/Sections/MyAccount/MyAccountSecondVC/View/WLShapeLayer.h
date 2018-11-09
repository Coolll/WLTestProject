//
//  WLShapeLayer.h
//  BLBalance
//
//  Created by 变啦 on 2018/10/19.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface WLShapeLayer : CAShapeLayer
/**
 *  柱状图的中心x 柱状图顶部y
 **/
@property (nonatomic,assign) CGFloat chartTopY,chartCenterX;

/**
 *  父视图
 **/
@property (nonatomic,strong) UIView *supView;
/**
 *  文本
 **/
@property (nonatomic,copy) NSString *text;



/**
 *  是否为选中
 **/
@property (nonatomic,assign) BOOL isSelected;


@end
