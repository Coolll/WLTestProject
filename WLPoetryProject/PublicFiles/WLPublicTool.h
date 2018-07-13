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
//添加圆角
- (void)addCornerForView:(UIView*)view withTopLeft:(BOOL)topLeft withTopRight:(BOOL)topRight withBottomLeft:(BOOL)bottomLeft withBottomRight:(BOOL)bottomRight withCornerRadius:(CGFloat)cornerR;

//计算label的高度方法，传入字号
+ (CGFloat)heightForTextString:(NSString*)vauleString width:(CGFloat)textWidth fontSize:(CGFloat)textSize;
//计算label的宽度方法，传入字号
+ (CGFloat)widthForTextString:(NSString *)tStr height:(CGFloat)tHeight fontSize:(CGFloat)tSize;


//将诗词按照，。！？分割
- (NSArray*)poetrySeperateWithOrigin:(NSString*)originString;
//高度计算，传入字体
+ (CGFloat)heightForTextString:(NSString*)vauleString width:(CGFloat)textWidth font:(UIFont*)textFont;
//宽度计算，传入字体
+ (CGFloat) widthForTextString:(NSString *)tStr height:(CGFloat)tHeight font:(UIFont*)textFont;

//将图片保存到沙盒
- (void)saveImageToLocalWithImage:(UIImage*)image;
-(UIImage *)loadDocumentImageWithName:(NSString*)imageName;

@end

