//
//  WLPoetryView.m
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/6/29.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLPoetryLabel.h"

@interface WLPoetryLabel()
/**
 *  数据源
 **/
@property (nonatomic, copy) NSArray *contentArray;
@end

@implementation WLPoetryLabel

- (instancetype)initWithContent:(NSString*)content
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.text = [NSString stringWithFormat:@"%@",content];
    }
    return self;
}


@end
