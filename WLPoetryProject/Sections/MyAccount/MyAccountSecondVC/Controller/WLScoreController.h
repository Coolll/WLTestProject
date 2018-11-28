//
//  WLScoreController.h
//  WLPoetryProject
//
//  Created by 变啦 on 2018/11/23.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^FinishScoreBlock) (NSDictionary *dataDic);

@interface WLScoreController : BaseViewController
/**
 *  用户得分
 **/
@property (nonatomic,assign) CGFloat score;
/**
 *  结束的block
 **/
@property (nonatomic,copy) FinishScoreBlock block;


@end
