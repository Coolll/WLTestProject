//
//  WLHeaderImageController.h
//  WLPoetryProject
//
//  Created by 龙培 on 2020/6/8.
//  Copyright © 2020年 龙培. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^HeaderImageBlock) (BOOL isFinished);

NS_ASSUME_NONNULL_BEGIN

@interface WLHeaderImageController : BaseViewController

- (void)finishSettingWithBlock:(HeaderImageBlock)block;


@end

NS_ASSUME_NONNULL_END
