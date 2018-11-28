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
    CAShapeLayer *bgLayer = [CAShapeLayer layer];
    bgLayer.frame = CGRectMake(0, 0, self.frameWidth,self.frameHeight);
    bgLayer.lineCap = kCALineCapRound;
    bgLayer.lineWidth = self.frameHeight;
    bgLayer.strokeStart = 0;
    bgLayer.strokeEnd = 1;
    bgLayer.strokeColor = RGBCOLOR(223, 223, 223, 1.0).CGColor;
    
    UIBezierPath *bgPath = [UIBezierPath bezierPath];
    [bgPath moveToPoint:CGPointMake(0, self.frameHeight/2)];
    [bgPath addLineToPoint:CGPointMake(self.frameWidth, self.frameHeight/2)];
    bgLayer.path = bgPath.CGPath;
    [self.layer addSublayer:bgLayer];
    
    lineLayer = [CAShapeLayer layer];
    
    lineLayer.frame = CGRectMake(0, 0, self.frameWidth,self.frameHeight);
    //线条两个末端的形状 圆形的
    lineLayer.lineCap = kCALineCapRound;
    
    drawPath = [UIBezierPath bezierPath];
    [drawPath addLineToPoint:CGPointMake(0, self.frameHeight/2)];
    lineLayer.path = drawPath.CGPath;
    lineLayer.strokeStart = 0;
    lineLayer.strokeEnd = 1;
    lineLayer.lineWidth = self.frameHeight;
    lineLayer.strokeColor = RGBCOLOR(110, 215, 42, 1.0).CGColor;
    [self.layer addSublayer:lineLayer];
}
- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
//    lineLayer.path = [[UIBezierPath bezierPath] addLineToPoint:CGPointMake(progress*self.frameWidth, self.frameHeight/2)].CGPath;
//    lineLayer.strokeColor = [UIColor whiteColor].CGColor;
//    lineLayer.fillColor = [UIColor greenColor].CGColor;
//    lineLayer.strokeStart = 0.0;
//    lineLayer.strokeEnd = 1.0;
    [drawPath moveToPoint:CGPointMake(0, self.frameHeight/2)];
    [drawPath addLineToPoint:CGPointMake(progress*self.frameWidth, self.frameHeight/2)];
    lineLayer.path = drawPath.CGPath;

}
@end
