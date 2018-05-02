//
//  WLTextField.m
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/14.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import "WLTextField.h"

@implementation WLTextField

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    
    CGRect originalRect = [super caretRectForPosition:position];
    originalRect.size.height = self.frame.size.height*3/5;
    originalRect.size.width = 2;
    originalRect.origin.y = self.frame.size.height/5;
    return originalRect;
}


@end
