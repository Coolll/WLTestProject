//
//  WLReadImagePreviewController.h
//  WLPoetryProject
//
//  Created by 龙培 on 2020/10/13.
//  Copyright © 2020 龙培. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SureSelectEffectBlock)(void);

@interface WLReadEffectPreviewController : BaseViewController

/**
 *  特效 类型
 **/
@property (nonatomic,copy) NSString *effectType;

- (void)configureUI;

- (void)saveEffectWithBlock:(SureSelectEffectBlock)block;

@end

NS_ASSUME_NONNULL_END

