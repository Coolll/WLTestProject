//
//  WLCoreDataHelper.h
//  WLPoetryProject
//
//  Created by 龙培 on 2018/4/17.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "PoetryModel.h"
#import "Poetry+CoreDataClass.h"
#import "Poetry+CoreDataProperties.h"

typedef void(^CoreDataResultBlock)(BOOL isSuccessful,NSError *error);

@interface WLCoreDataHelper : NSObject
//新生成的实体类会编译报错，说文件重复，去Build Phase中移除该类即可

@property (nonatomic,strong) AppDelegate *appDelegate;
//单例初始化
+ (instancetype)shareHelper;

//保存诗词信息
- (void)saveInBackgroundWithPeotryModelArray:(NSArray*)array withResult:(CoreDataResultBlock)block;

//查询全部的诗词信息
-(NSArray*)fetchAllPoetry;

//根据来源查询诗词的信息
- (Poetry*)fetchPoetryWithSource:(NSString*)source;

//根据ID 更改诗词的信息
- (void)updatePoetryWithID:(NSString*)poetryID withNewPoetry:(PoetryModel*)newPoetry withResult:(CoreDataResultBlock)block;

//删除全部诗词
- (void)deleteAllPoetry;

//根据ID 删除诗词的信息
- (void)deletePoetryWithID:(NSString*)poetryID withResult:(CoreDataResultBlock)block;

@end
