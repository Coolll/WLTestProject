//
//  WLImageListController.h
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/7/5.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^ListSaveImageBlock) (void);

@interface WLImageListController : BaseViewController
- (void)saveImageWithBlock:(ListSaveImageBlock)block;

@end
