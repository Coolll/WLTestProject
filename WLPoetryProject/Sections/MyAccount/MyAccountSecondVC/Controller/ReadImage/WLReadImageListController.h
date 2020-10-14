//
//  WLReadImageListController.h
//  WLPoetryProject
//
//  Created by 龙培 on 2020/10/13.
//  Copyright © 2020 龙培. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^SelectReadImageBlock) (void);


@interface WLReadImageListController : BaseViewController

- (void)selectImageWithBlock:(SelectReadImageBlock)block;

@end

NS_ASSUME_NONNULL_END
