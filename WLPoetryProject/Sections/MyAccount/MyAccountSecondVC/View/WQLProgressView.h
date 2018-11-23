//
//  WQLProgressView.h
//  WQLCircleProgress
//
//  Created by WQL on 16/2/16.
//  Copyright © 2016年 WQL. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ProgressFinishBlock) (void);

@interface WQLProgressView : UIView
/**
 *  进度 0-1 
 */
@property (nonatomic,assign) CGFloat progress;
/**
 *  圆环的宽度
 **/
@property (nonatomic,assign) CGFloat frameWidth;;
/**
 *  圆环的高度
 **/
@property (nonatomic,assign) CGFloat frameHeight;
/**
 *  圆环宽度
 **/
@property (nonatomic,assign) CGFloat lineWidth;




- (void)loadCustomCircle;
- (void)finishWithBlock:(ProgressFinishBlock)block;
- (void)restartCircle;
@end
