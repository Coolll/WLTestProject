//
//  WQLProgressView.m
//  WQLCircleProgress
//
//  Created by WQL on 16/2/16.
//  Copyright © 2016年 WQL. All rights reserved.
//

#import "WQLProgressView.h"
@interface WQLProgressView()
{
    CAShapeLayer *circleLayer;
    
    UIBezierPath *drawPath;
    
    CGFloat R;
    
}
@end
@implementation WQLProgressView





- (void)loadCustomCircle
{
    circleLayer = [CAShapeLayer layer];

    
    if (R <= 0) {
        R = self.frameWidth>self.frameHeight?self.frameHeight/2-self.lineWidth:self.frameWidth/2-self.lineWidth;
    }
    
    
    circleLayer.frame = CGRectMake(0, 0, self.frameWidth,self.frameHeight);
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    //线条两个末端的形状 圆形的
    circleLayer.lineCap = kCALineCapRound;
    circleLayer.strokeColor = [UIColor orangeColor].CGColor;
    circleLayer.lineWidth = self.lineWidth;
    
    drawPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frameWidth/2, self.frameHeight/2) radius:R startAngle:-M_PI_2 endAngle:M_PI*3/2 clockwise:YES];
    circleLayer.path = drawPath.CGPath;
    circleLayer.strokeStart = 0.0;
    circleLayer.strokeEnd = 0.01;
    circleLayer.strokeColor = [UIColor orangeColor].CGColor;
    [self.layer addSublayer:circleLayer];
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    circleLayer.strokeEnd = progress;
    
    if (progress == 1) {
        //duang duang duang 的搞一搞
//        circleLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, frameWidth, frameHeight) cornerRadius:R].CGPath;
//        circleLayer.strokeColor = [UIColor clearColor].CGColor;
//        circleLayer.fillColor = [UIColor greenColor].CGColor;
        circleLayer.strokeStart = 0.0;
        circleLayer.strokeEnd = 1.0;
    }else if(progress < 1){
        //这个else仅测试用，实际中，不会出现下载完成后，再出现进度条了
        circleLayer.path = drawPath.CGPath;
        circleLayer.strokeStart = 0.0;
        circleLayer.strokeEnd = progress;
        circleLayer.strokeColor = [UIColor orangeColor].CGColor;
        circleLayer.fillColor = [UIColor clearColor].CGColor;
    
    }else{
        circleLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frameWidth/2, self.frameHeight/2) radius:R startAngle:-M_PI_2 endAngle:-M_PI_2 clockwise:YES].CGPath;
        circleLayer.strokeStart = 0.0;
        circleLayer.strokeEnd = 0.0;
        circleLayer.strokeColor = [UIColor orangeColor].CGColor;
        circleLayer.fillColor = [UIColor clearColor].CGColor;
    }
    
}

@end
