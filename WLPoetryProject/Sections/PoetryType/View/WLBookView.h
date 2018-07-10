//
//  WLBookView.h
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/7/10.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BookViewClickBlock) (NSInteger index);

@interface WLBookView : UIView
/**
 *  book的index
 **/
@property (nonatomic,assign) NSInteger index;
/**
 *  标题
 **/
@property (nonatomic,copy) NSString *bookName;


- (void)clickBookWithBlock:(BookViewClickBlock)block;

- (void)loadCustomView;

@end
