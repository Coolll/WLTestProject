//
//  WLUserAgreementView.h
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/15.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLUserAgreementView : UIView


- (void)clickButtonWithBlock:(void(^)(BOOL isAgree))block;

- (void)showAgreementView;

@end
