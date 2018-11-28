//
//  WLEvaluateController.h
//  WLPoetryProject
//
//  Created by 变啦 on 2018/11/16.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^FinishTestBlock) (NSDictionary *dataDic);

@interface WLEvaluateController : BaseViewController

/**
 *  结束时的block
 **/
@property (nonatomic,copy) FinishTestBlock finishBlock;


@end
