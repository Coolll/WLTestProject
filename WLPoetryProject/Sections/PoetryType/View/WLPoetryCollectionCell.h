//
//  WLPoetryCollectionCell.h
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/7/10.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CollectionClickBlock) (NSInteger index);

@interface WLPoetryCollectionCell : UITableViewCell
/**
 *  标题
 **/
@property (nonatomic,copy) NSArray *booksArray;


- (void)clickWithBlock:(CollectionClickBlock)block;

- (void)loadCustomView;

@end
