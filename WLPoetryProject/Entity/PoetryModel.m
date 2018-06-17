//
//  PoetryModel.m
//  WLPoetryProject
//
//  Created by 龙培 on 2018/4/17.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "PoetryModel.h"

@implementation PoetryModel

- (void)loadFirstLineString
{
    if ([self.content isKindOfClass:[NSString class]] && self.content.length > 0) {
        
        BOOL isContainEnd = [self.content containsString:@"。"];
        
        if (isContainEnd) {
            
            self.firstLineString = [NSString stringWithFormat:@"%@。",[[self.content componentsSeparatedByString:@"。"]firstObject]];
            
        }else{
            self.firstLineString = @"";
        }
    }
}



@end
