//
//  WLPercentView.m
//  WLPoetryProject
//
//  Created by 变啦 on 2018/11/23.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLPercentView.h"
@interface WLPercentView()
{
    CAShapeLayer *lineLayer;
    
    UIBezierPath *drawPath;
    
}
@end
@implementation WLPercentView



- (void)loadCustomLayer
{
    lineLayer = [CAShapeLayer layer];
    
    lineLayer.frame = CGRectMake(0, 0, self.frameWidth,self.frameHeight);
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    //线条两个末端的形状 圆形的
    lineLayer.lineCap = kCALineCapRound;
    lineLayer.strokeColor = [UIColor orangeColor].CGColor;
    
    drawPath = [UIBezierPath bezierPath];
    [drawPath addLineToPoint:CGPointMake(0, self.frameHeight/2)];
    lineLayer.path = drawPath.CGPath;
    lineLayer.strokeStart = 0;
    lineLayer.strokeEnd = 1;
    lineLayer.strokeColor = NavigationColor.CGColor;
    [self.layer addSublayer:lineLayer];
}
- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
//    lineLayer.path = [[UIBezierPath bezierPath] addLineToPoint:CGPointMake(progress*self.frameWidth, self.frameHeight/2)].CGPath;
    lineLayer.strokeColor = [UIColor clearColor].CGColor;
    lineLayer.fillColor = [UIColor greenColor].CGColor;
    lineLayer.strokeStart = 0.0;
    lineLayer.strokeEnd = 1.0;
    [drawPath moveToPoint:CGPointMake(0, self.frameHeight/2)];
    [drawPath addLineToPoint:CGPointMake(progress*self.frameWidth, self.frameHeight/2)];
    lineLayer.path = drawPath.CGPath;

}
@end
