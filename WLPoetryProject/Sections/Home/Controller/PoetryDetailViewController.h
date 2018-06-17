//
//  PoetryDetailViewController.h
//  WLPoetryProject
//
//  Created by 龙培 on 2018/4/23.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "BaseViewController.h"
#import "PoetryModel.h"

typedef void(^LikeBlock) (BOOL isLike);

@interface PoetryDetailViewController : BaseViewController
/**
 *  数据
 **/
@property (nonatomic,strong) PoetryModel *dataModel;

- (void)clickLikeWithBlock:(LikeBlock)block;

@end
