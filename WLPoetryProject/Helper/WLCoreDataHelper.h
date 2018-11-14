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
#import "CreationModel.h"
#import "Poetry+CoreDataClass.h"
#import "Poetry+CoreDataProperties.h"
#import "UserCreation+CoreDataClass.h"
#import "UserCreation+CoreDataProperties.h"
#import "UserInfoModel.h"
#import "UserInfo+CoreDataClass.h"
#import "UserInfo+CoreDataProperties.h"

typedef void(^CoreDataResultBlock)(BOOL isSuccessful,NSError *error);
typedef void(^CoreDataInnerBlock)(BOOL isSuccessful);

@interface WLCoreDataHelper : NSObject
//新生成的实体类会编译报错，说文件重复，去Build Phase中移除该类即可

@property (nonatomic,strong) AppDelegate *appDelegate;
//单例初始化
+ (instancetype)shareHelper;

#pragma mark - 诗词

#pragma mark 增加诗词
//保存诗词信息
- (void)saveInBackgroundWithPeotryModelArray:(NSArray*)array withResult:(CoreDataResultBlock)block;
#pragma mark 删除诗词
//删除全部诗词
- (void)deleteAllPoetry;

//根据ID 删除诗词的信息
- (void)deletePoetryWithID:(NSString*)poetryID withResult:(CoreDataResultBlock)block;
#pragma mark 修改诗词
//根据ID 更改诗词的信息
//- (void)updatePoetryWithID:(NSString*)poetryID withNewPoetry:(PoetryModel*)newPoetry withResult:(CoreDataResultBlock)block;

#pragma mark 查询诗词
//查询全部的诗词信息
-(NSArray*)fetchAllPoetry;

//查询某个大类的诗词，比如小学一年级的诗词，传1即可
-(NSArray*)fetchPoetryWithMainClass:(NSString*)mainClass;

//根据id来查询诗词
- (PoetryModel*)fetchPoetryModelWithID:(NSString*)idString;

//- (PoetryModel*)fetchPoetryWithID:(NSString*)idString;

//根据关键词搜索诗
- (NSArray*)searchPoetryListWithKeyWord:(NSString*)keyWord;

#pragma mark - 创作

#pragma mark 增加创作
//保存创作信息
- (void)saveInBackgroundWithCreationModel:(CreationModel*)model withResult:(CoreDataResultBlock)block;

#pragma mark 删除创作
//删除全部创作
- (void)deleteAllCreation;

//根据ID 删除创作
- (void)deleteCreationWithID:(NSString*)creationID withResult:(CoreDataResultBlock)block;

#pragma mark 修改创作
//根据ID 更改创作的信息
- (void)updateCreationWithID:(NSString*)poetryID withNewCreation:(CreationModel*)newCreation withResult:(CoreDataResultBlock)block;

#pragma mark 查询创作
//查询全部的创作信息
-(NSArray*)fetchAllCreation;

//根据id来查询创作
- (CreationModel*)fetchCreationModelWithID:(NSString*)idString;


#pragma mark - 个人信息

#pragma mark 增加信息
- (void)saveInBackgroundWithUserInfoModel:(UserInfoModel*)model withResult:(CoreDataResultBlock)block;

#pragma mark 修改个人信息
//更改个人信息
- (void)updateUserInfoWithNewModel:(UserInfoModel*)model withResult:(CoreDataResultBlock)block;

//- (void)loginOutWithUserID:(NSString*)userID;

#pragma mark 查询个人信息
//查询个人信息
- (UserInfoModel*)fetchCurrentUserModel;




@end
