//
//  UIButton+WLExtension.h
//  WLPoetryProject
//
//  Created by 变啦 on 2018/8/24.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WLButtonBlock)(UIButton *sender);
@interface UIButton (WLExtension)

- (void)addTouchEvent:(UIControlEvents)event withAction:(WLButtonBlock)block;

@end
