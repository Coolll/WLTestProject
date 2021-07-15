//
//  WLImagePoetrySelectController.h
//  WLPoetryProject
//
//  Created by 龙培 on 2021/7/15.
//  Copyright © 2021 龙培. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^PoetrySelectBlock) (NSString*finialString);
NS_ASSUME_NONNULL_BEGIN

@interface WLImagePoetrySelectController : BaseViewController
/**
 *  内容
 **/
@property (nonatomic,copy) NSString *contentString;
/**
 *  初始内容
 **/
@property (nonatomic,strong) NSString *originString;

- (void)loadPoetrySelectBlock:(PoetrySelectBlock)block;

@end

NS_ASSUME_NONNULL_END
