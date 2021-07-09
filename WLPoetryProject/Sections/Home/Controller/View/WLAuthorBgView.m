//
//  WLAuthorBgView.m
//  WLPoetryProject
//
//  Created by 龙培 on 2021/7/8.
//  Copyright © 2021 龙培. All rights reserved.
//

#import "WLAuthorBgView.h"

@implementation WLAuthorBgView

- (void)configureColorView{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat singleW = 2;
    
    CGFloat radius = 0;
    if (width < height) {
        radius = width/2;
    }else{
        radius = height/2;
    }
    
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(0, 0)];
//    [path addLineToPoint:CGPointMake(singleW, 0)];
//    [path addLineToPoint:CGPointMake(singleW, singleW*3)];
//    [path addLineToPoint:CGPointMake(singleW*2, singleW*3)];
//    [path addLineToPoint:CGPointMake(singleW*2, 0)];
//    [path addLineToPoint:CGPointMake(width-singleW*2, 0)];
//    [path addLineToPoint:CGPointMake(width-singleW*2, singleW*3)];
//    [path addLineToPoint:CGPointMake(width-singleW, singleW*3)];
//    [path addLineToPoint:CGPointMake(width-singleW, 0)];
//    [path addLineToPoint:CGPointMake(width, 0)];
//    [path addLineToPoint:CGPointMake(width, singleW)];
//    [path addLineToPoint:CGPointMake(width-singleW*3, singleW)];
//    [path addLineToPoint:CGPointMake(width-singleW*3, singleW*2)];
//    [path addLineToPoint:CGPointMake(width, singleW*2)];
//    [path addLineToPoint:CGPointMake(width, height-singleW*2)];
//    [path addLineToPoint:CGPointMake(width-singleW*3, height-singleW*2)];
//    [path addLineToPoint:CGPointMake(width-singleW*3, height-singleW)];
//    [path addLineToPoint:CGPointMake(width, height-singleW)];
//    [path addLineToPoint:CGPointMake(width, height)];
//    [path addLineToPoint:CGPointMake(width-singleW, height)];
//    [path addLineToPoint:CGPointMake(width-singleW, height-singleW*3)];
//    [path addLineToPoint:CGPointMake(width-singleW*2, height-singleW*3)];
//    [path addLineToPoint:CGPointMake(width-singleW*2, height)];
//    [path addLineToPoint:CGPointMake(singleW*2, height)];
//    [path addLineToPoint:CGPointMake(singleW*2, height-singleW*3)];
//    [path addLineToPoint:CGPointMake(singleW, height-singleW*3)];
//    [path addLineToPoint:CGPointMake(singleW, height)];
//    [path addLineToPoint:CGPointMake(0, height)];
//    [path addLineToPoint:CGPointMake(0, height-singleW)];
//    [path addLineToPoint:CGPointMake(singleW*3, height-singleW)];
//    [path addLineToPoint:CGPointMake(singleW*3, height-singleW*2)];
//    [path addLineToPoint:CGPointMake(0, height-singleW*2)];
//    [path addLineToPoint:CGPointMake(0, singleW*2)];
//    [path addLineToPoint:CGPointMake(singleW*3, singleW*2)];
//    [path addLineToPoint:CGPointMake(singleW*3, singleW)];
//    [path addLineToPoint:CGPointMake(0, singleW)];
//    [path addLineToPoint:CGPointMake(0, 0)];
//
//    CAShapeLayer *layer = [CAShapeLayer layer];
//    layer.path = path.CGPath;
//    layer.lineWidth = 1;
//    layer.fillColor = [UIColor clearColor].CGColor;
//    layer.strokeColor = [UIColor redColor].CGColor;
//    [self.layer addSublayer:layer];
    
    
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    [circlePath addArcWithCenter:CGPointMake(radius, radius) radius:(radius-3) startAngle:0 endAngle:M_PI*2 clockwise:YES];

    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.path = circlePath.CGPath;
    circleLayer.lineWidth = 1;
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    circleLayer.strokeColor = self.mainColor.CGColor;
    [self.layer addSublayer:circleLayer];

        
}


@end
