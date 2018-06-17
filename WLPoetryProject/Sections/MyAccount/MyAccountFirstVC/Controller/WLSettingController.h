//
//  WLSettingController.h
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/6/16.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^SettingBlock)(BOOL isLogin);

@interface WLSettingController : BaseViewController

- (void)refreshLoginState:(SettingBlock)block;

@end
