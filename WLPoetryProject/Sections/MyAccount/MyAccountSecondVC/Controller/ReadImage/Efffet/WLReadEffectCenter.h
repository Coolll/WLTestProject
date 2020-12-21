//
//  WLReadEffectCenter.h
//  WLPoetryProject
//
//  Created by 龙培 on 2020/10/29.
//  Copyright © 2020 龙培. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,WLEffectType) {
    WLEffectTypePlum,//梅花
    WLEffectTypeRain,//细雨
    WLEffectTypeMeteor//流星雨
};
NS_ASSUME_NONNULL_BEGIN

@interface WLReadEffectCenter : NSObject

+ (WLReadEffectCenter *)shareCenter;
//雪花特效
- (void)loadSnowEffectWithSuperView:(UIView*)superView;
//花瓣特效
- (void)loadFlowerEffectWithSuperView:(UIView*)superView;
//枫叶特效
- (void)loadMapleLeafEffectWithSuperView:(UIView*)superView;
//梅花特效
- (void)loadEffectWithSuperView:(UIView*)superView withType:(WLEffectType)type;

@end

NS_ASSUME_NONNULL_END
