//
//  WLAuthorBgView.h
//  WLPoetryProject
//
//  Created by 龙培 on 2021/7/8.
//  Copyright © 2021 龙培. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WLAuthorBgView : UIView
/**
 *  颜色
 **/
@property (nonatomic,strong) UIColor *mainColor;

- (void)configureColorView;

@end

NS_ASSUME_NONNULL_END
