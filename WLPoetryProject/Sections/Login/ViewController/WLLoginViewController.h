//
//  WLLoginViewController.h
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/14.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import "BaseViewController.h"

@interface WLLoginViewController : BaseViewController

- (void)loginSuccessWithBlock:(void(^)(UserInformation *user))block;

@end
