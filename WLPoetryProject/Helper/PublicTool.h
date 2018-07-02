//
//  PublicTool.h
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/6/29.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicTool : NSObject
+ (PublicTool *)tool;

//将诗词按照，。！？分割
- (NSArray*)poetrySeperateWithOrigin:(NSString*)originString;


+ (CGFloat)heightForTextString:(NSString*)vauleString width:(CGFloat)textWidth font:(UIFont*)textFont;

+ (CGFloat) widthForTextString:(NSString *)tStr height:(CGFloat)tHeight font:(UIFont*)textFont;

@end
