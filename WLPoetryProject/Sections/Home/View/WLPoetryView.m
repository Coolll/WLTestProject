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
    switch (_direction) {
            
        case PoetryDirectionHorizon:
            {
                [self loadHorizonView];
            }
            break;
           
        case PoetryDirectionVerticalLeft:
        {
            [self loadVerticalLeftView];
        }
            break;
            
        case PoetryDirectionVerticalRight:
        {
            [self loadVerticalRightView];
        }
            break;
            
        default:
            break;
    }
}


- (void)loadHorizonView
{
    CGFloat topSpace = 0;
    
    for (int i =0; i< self.contentArray.count; i++) {
        
        NSString *content = [NSString stringWithFormat:@"%@",self.contentArray[i]];
        
        UILabel *contentLabel = [[UILabel alloc]init];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = [UIFont systemFontOfSize:14.f];
        contentLabel.text = content;
        [self addSubview:contentLabel];
        
        CGFloat width = [PublicTool widthForTextString:content height:20 font:contentLabel.font];
        CGFloat height = 20;
        CGFloat itemSpace = 8;
        //元素的布局李白
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset((PhoneScreen_WIDTH-width)/2);
            make.top.equalTo(self.mas_top).offset(topSpace);
            make.right.equalTo(self.mas_right).offset(-(PhoneScreen_WIDTH-width)/2);
            make.height.mas_equalTo(height);
            
        }];
        
        topSpace += height+itemSpace;
    }
    
    
}

- (void)loadVerticalLeftView
{
    
}

- (void)loadVerticalRightView
{
    
}

@end
