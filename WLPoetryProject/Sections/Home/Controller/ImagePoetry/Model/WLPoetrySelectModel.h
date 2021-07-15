//
//  WLPoetrySelectModel.h
//  WLPoetryProject
//
//  Created by 龙培 on 2021/7/15.
//  Copyright © 2021 龙培. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WLPoetrySelectModel : NSObject
/**
 *  内容
 **/
@property (nonatomic,copy) NSString *contentString;
/**
 *  是否选中
 **/
@property (nonatomic,assign) BOOL isSelect;

@end

NS_ASSUME_NONNULL_END
