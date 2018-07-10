//
//  WLGradeTypeCell.h
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/7/10.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^GradeClickBlock) (NSInteger index);

@interface WLGradeTypeCell : UITableViewCell

/**
 *  标题
 **/
@property (nonatomic,copy) NSArray *booksArray;


- (void)clickWithBlock:(GradeClickBlock)block;

- (void)loadCustomView;

@end
