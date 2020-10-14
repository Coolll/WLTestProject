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
@property (nullable, nonatomic, copy) NSString *backImageURL;//背景图片URL
@property (nullable, nonatomic, copy) NSString *isLike;//是否收藏
@property (nullable, nonatomic, copy) NSString *isRecited;//是否背诵
@property (nullable, nonatomic, copy) NSString *isShowed;//是否随机展示了
@property (nullable, nonatomic, copy) NSString *addtionInfo;//标注信息
@property (nullable, nonatomic, copy) NSString *classInfo;//诗词内容分类
@property (nullable, nonatomic, copy) NSString *classInfoExplain;//诗词内容分类
@property (nullable, nonatomic, copy) NSString *poetryID;//诗词ID
@property (nullable, nonatomic, copy) NSString *source;//来源
@property (nullable, nonatomic, copy) NSString *sourceExplain;//来源
@property (nullable, nonatomic, copy) NSString *transferInfo;//翻译信息
@property (nullable, nonatomic, copy) NSString *analysesInfo;//赏析信息
@property (nullable, nonatomic, copy) NSString *backgroundInfo;//创作背景信息
@property (nullable, nonatomic, copy) NSString *mainClass;//主分类，1为小学一年级
@property (nullable, nonatomic, copy) NSString *mainClassExplain;//主分类，1为小学一年级
@property (nullable, nonatomic, copy) NSString *myPropertyForOne;//新增的一个属性
/**
 *  喜欢数
 **/
@property (nonatomic,assign) NSInteger likes;
/**
 *  是文本颜色
 **/
@property (nonatomic,copy) NSString * _Nullable textColor;
/**
 *  文本的高度
 **/
@property (nonatomic,assign) CGFloat heightForCell;


- (instancetype )initPoetryWithDictionary:(NSDictionary*_Nullable)dic;
- (void)loadFirstLineString;

@end
