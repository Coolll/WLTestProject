//
//  WLReadImagePreviewController.h
//  WLPoetryProject
//
//  Created by 龙培 on 2020/10/13.
//  Copyright © 2020 龙培. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SureSelectImageBlock)(void);
typedef NS_ENUM(NSInteger,PreviewType) {
    PreviewTypeImage,
    PreviewTypeColor
};
@interface WLReadImagePreviewController : BaseViewController
/**
 *  背景图片名
 **/
@property (nonatomic, copy) NSString *imageName;
/**
 *  视图类型
 **/
@property (nonatomic,assign) PreviewType type;
/**
 *  背景色string
 **/
@property (nonatomic,copy) NSString *imageColorString;
/**
 *  背景色
 **/
@property (nonatomic,strong) UIColor *imageColor;
- (void)configureUI;

- (void)saveImageWithBlock:(SureSelectImageBlock)block;

@end

NS_ASSUME_NONNULL_END
