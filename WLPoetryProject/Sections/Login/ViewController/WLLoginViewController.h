//
//  WLLoginViewController.h
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/14.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import "BaseViewController.h"

@interface WLLoginViewController : BaseViewController

/**
 *  展示的类型 默认push 如果present，则返回按钮需要dismiss
 **/
@property (nonatomic,copy) NSString *showType;

- (void)loginSuccessWithBlock:(void(^)(UserInformation *user))block;

@end
