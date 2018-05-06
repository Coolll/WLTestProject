//
//  PoetryModel.h
//  WLPoetryProject
//
//  Created by 龙培 on 2018/4/17.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLBaseModel.h"

@interface PoetryModel : WLBaseModel

@property (nullable, nonatomic, copy) NSString *name;//诗名
@property (nullable, nonatomic, copy) NSString *author;//作者
@property (nullable, nonatomic, copy) NSString *content;//内容
@property (nullable, nonatomic, copy) NSString *firstLineString;//第一行的内容
@property (nullable, nonatomic, copy) NSString *backImageName;//背景图片名
@property (nullable, nonatomic, copy) NSString *isLike;//是否收藏
@property (nullable, nonatomic, copy) NSString *isRecited;//是否背诵
@property (nullable, nonatomic, copy) NSString *isShowed;//是否随机展示了
@property (nullable, nonatomic, copy) NSString *addtionInfo;//标注信息
@property (nullable, nonatomic, copy) NSString *classInfo;//分类信息
@property (nullable, nonatomic, copy) NSString *poetryID;//诗词ID
@property (nullable, nonatomic, copy) NSString *source;//来源
@property (nullable, nonatomic, copy) NSString *transferInfo;//翻译信息
@property (nullable, nonatomic, copy) NSString *analysesInfo;//赏析信息
@property (nullable, nonatomic, copy) NSString *backgroundInfo;//创作背景信息

@end
