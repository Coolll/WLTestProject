//
//  UIButton+WLExtension.m
//  WLPoetryProject
//
//  Created by 变啦 on 2018/8/24.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "UIButton+WLExtension.h"

@implementation UIButton (WLExtension)
static const NSString *identifier = @"UIButton_WLExtension";

- (void)addEventWithAction:(WLButtonBlock)block
{
    if (block) {
        [self addTouchEvent:UIControlEventTouchUpInside withAction:block];
    }else{
        [self addTouchEvent:UIControlEventTouchUpInside withAction:nil];
    }
}

- (void)addTouchEvent:(UIControlEvents)event withAction:(WLButtonBlock)block
{
    if (block) {
        objc_setAssociatedObject(self, &identifier, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
    [self addTarget:self action:@selector(btnAction:) forControlEvents:event];
    
}

- (void)btnAction:(UIButton*)sender
{
    WLButtonBlock block = objc_getAssociatedObject(self, &identifier);
    if (block) {
        block(sender);
    }
}
@end
