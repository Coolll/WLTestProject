//
//  WLPoetryView.m
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/6/29.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLPoetryView.h"

@interface WLPoetryView()
/**
 *  数据源
 **/
@property (nonatomic, copy) NSArray *contentArray;
@end

@implementation WLPoetryView

- (instancetype)initWithContent:(NSString*)content
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentArray = [[PublicTool tool]poetrySeperateWithOrigin:content];
        
    }
    return self;
}

- (void)setDirection:(PoetryDirection)direction
{
    _direction = direction;
    
    [self loadCustomView];
}

- (void)loadCustomView
{
    
}



@end
