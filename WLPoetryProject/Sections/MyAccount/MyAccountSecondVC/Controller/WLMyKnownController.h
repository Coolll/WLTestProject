//
//  WLMyKnownController.h
//  WLPoetryProject
//
//  Created by 变啦 on 2018/11/8.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "BaseViewController.h"

@interface WLMyKnownController : BaseViewController
/**
 *  用户名
 **/
@property (nonatomic,copy) NSString *userName;
/**
 *  头像
 **/
@property (nonatomic,copy) NSString *headImageURL;



- (void)loadCustomView;

@end