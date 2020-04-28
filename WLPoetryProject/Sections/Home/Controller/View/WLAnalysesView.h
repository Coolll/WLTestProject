//
//  WLAnalysesView.h
//  WLPoetryProject
//
//  Created by 变啦 on 2020/4/28.
//  Copyright © 2020 龙培. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WLAnalysesView : UIView

/**
 *  翻译
 **/
@property (nonatomic,copy) NSString *transferInfo;

/**
 *  注释
 **/
@property (nonatomic,copy) NSString *additionInfo;
/**
 *  赏析
 **/
@property (nonatomic,copy) NSString *analysesInfo;
/**
 *  背景
 **/
@property (nonatomic,copy) NSString *backgroundInfo;

- (void)configureView;

@end

NS_ASSUME_NONNULL_END
