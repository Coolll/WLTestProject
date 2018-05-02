//
//  WLPublicTool.h
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/15.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLPublicTool : NSObject

+ (WLPublicTool *)shareTool;

- (void)addCornerForView:(UIView*)view withTopLeft:(BOOL)topLeft withTopRight:(BOOL)topRight withBottomLeft:(BOOL)bottomLeft withBottomRight:(BOOL)bottomRight withCornerRadius:(CGFloat)cornerR;

//计算label的高度方法
+ (CGFloat)heightForTextString:(NSString*)vauleString width:(CGFloat)textWidth fontSize:(CGFloat)textSize;

+ (CGFloat) widthForTextString:(NSString *)tStr height:(CGFloat)tHeight fontSize:(CGFloat)tSize;

@end

