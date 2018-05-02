//
//  WLPublicTool.m
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/15.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import "WLPublicTool.h"

@implementation WLPublicTool

+ (WLPublicTool *)shareTool{
    static WLPublicTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[WLPublicTool alloc] init];
    });
    return tool;
}

//画圆角
- (void)addCornerForView:(UIView*)view withTopLeft:(BOOL)topLeft withTopRight:(BOOL)topRight withBottomLeft:(BOOL)bottomLeft withBottomRight:(BOOL)bottomRight withCornerRadius:(CGFloat)cornerR
{
    CGFloat viewWidth = view.frame.size.width;
    CGFloat viewHeight = view.frame.size.height;
    
    UIBezierPath *path = [[UIBezierPath alloc]init];
    [path moveToPoint:CGPointMake(0, viewHeight-cornerR)];
    if (topLeft) {
        [path addLineToPoint:CGPointMake(0, cornerR)];
        [path addQuadCurveToPoint:CGPointMake(cornerR, 0) controlPoint:CGPointMake(0, 0)];
    }else{
        [path addLineToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(cornerR, 0)];
    }
    
    [path addLineToPoint:CGPointMake(viewWidth-cornerR, 0)];
    
    if (topRight) {
        [path addQuadCurveToPoint:CGPointMake(viewWidth, cornerR) controlPoint:CGPointMake(viewWidth, 0)];
    }else{
        [path addLineToPoint:CGPointMake(viewWidth, 0)];
        [path addLineToPoint:CGPointMake(viewWidth, cornerR)];
    }
    
    
    [path addLineToPoint:CGPointMake(viewWidth, viewHeight-cornerR)];
    
    if (bottomRight) {
        [path addQuadCurveToPoint:CGPointMake(viewWidth-cornerR, viewHeight) controlPoint:CGPointMake(viewWidth, viewHeight)];
    }else{
        [path addLineToPoint:CGPointMake(viewWidth, viewHeight)];
        [path addLineToPoint:CGPointMake(viewWidth-cornerR, viewHeight)];
    }
    
    [path addLineToPoint:CGPointMake(cornerR, viewHeight)];
    
    if (bottomLeft) {
        [path addQuadCurveToPoint:CGPointMake(0, viewHeight-cornerR) controlPoint:CGPointMake(0, viewHeight)];
    }else{
        [path addLineToPoint:CGPointMake(0, viewHeight)];
        [path addLineToPoint:CGPointMake(0, viewHeight-cornerR)];
    }
    
    
    
    //构建图形
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    //这里的frame要注意
    maskLayer.frame = view.bounds;
    maskLayer.fillColor = [UIColor whiteColor].CGColor;
    view.layer.mask = maskLayer;
    
}

//计算label的高度方法
+ (CGFloat)heightForTextString:(NSString*)vauleString width:(CGFloat)textWidth fontSize:(CGFloat)textSize
{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:textSize]};
    CGRect rect = [vauleString boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingTruncatesLastVisibleLine attributes:dict context:nil];
    return rect.size.height ;
}

+ (CGFloat) widthForTextString:(NSString *)tStr height:(CGFloat)tHeight fontSize:(CGFloat)tSize{
    
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:tSize]};
    CGRect rect = [tStr boundingRectWithSize:CGSizeMake(MAXFLOAT, tHeight) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.width+5;
    
}

@end
