//
//  WLColorPickerView.h
//  WLPoetryProject
//
//  Created by 龙培 on 2020/10/14.
//  Copyright © 2020 龙培. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ColorPickerCompletionBlock)(UIColor *color,NSString *colorString);

@interface WLColorPickerView : UIView

- (void)finishSelectWithCompletion:(ColorPickerCompletionBlock)block;

- (void)showColorPicker;

- (void)hideColorPicker;

@end

NS_ASSUME_NONNULL_END
