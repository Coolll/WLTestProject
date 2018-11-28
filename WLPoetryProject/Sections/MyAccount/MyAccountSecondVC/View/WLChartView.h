//
//  WLChartView.h
//  BLBalance
//
//  Created by 变啦 on 2018/10/17.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLChartView : UIView

/**
 *  数据
 **/
@property (nonatomic,copy) NSArray *dataArray;
/**
 *  标题 与数据源不等
 **/
@property (nonatomic,copy) NSDictionary *titleDic;
/**
 *  标题 与数据源相等
 **/
@property (nonatomic,copy) NSArray *titleArray;


/**
 *  左右间距
 **/
@property (nonatomic,assign) CGFloat leftSpace;

/**
 *  柱状图宽度/空白的比例 默认0.5 宽度=空白；若设置了widthForChart则此属性失效
 **/
@property (nonatomic,assign) CGFloat widthRate;

/**
 *  柱状图宽度
 **/
@property (nonatomic,assign) CGFloat widthForChart;
/**
 *  柱状图空白
 **/
@property (nonatomic,assign) CGFloat widthForSpace;



/**
 *  文本的对齐方式
 **/
@property (nonatomic,assign) NSTextAlignment textAlignment;

/**
 *  是否需要动画
 **/
@property (nonatomic,assign) BOOL needAnimation;
/**
 *  动画时长
 **/
@property (nonatomic,assign) CGFloat animateTime;

/**
 *  视图的宽高
 **/
@property (nonatomic,assign) CGFloat viewW,viewH;
/**
 *  设置的y最大值
 **/
@property (nonatomic,assign) NSInteger maxValue;




- (void)configureView;

- (void)reloadChartView;


@end
