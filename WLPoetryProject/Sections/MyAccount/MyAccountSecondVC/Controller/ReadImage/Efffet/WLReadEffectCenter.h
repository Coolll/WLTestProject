//
//  WLReadEffectCenter.h
//  WLPoetryProject
//
//  Created by 龙培 on 2020/10/29.
//  Copyright © 2020 龙培. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WLReadEffectCenter : NSObject

+ (WLReadEffectCenter *)shareCenter;

- (void)loadSnowEffectWithSuperView:(UIView*)superView;

- (void)loadFlowerEffectWithSuperView:(UIView*)superView;


@end

NS_ASSUME_NONNULL_END
