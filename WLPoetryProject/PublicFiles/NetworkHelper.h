//
//  NetworkHelper.h
//  WLPoetryProject
//
//  Created by 变啦 on 2019/10/24.
//  Copyright © 2019 龙培. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RequestResultBlock) (BOOL success,NSDictionary * _Nullable dic,NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface NetworkHelper : NSObject

+ (NetworkHelper *)shareHelper;

//注册与登录
- (void)loginWithUserName:(NSString*)userName password:(NSString*)pwd withCompletion:(RequestResultBlock)block;

//退出登录
- (void)logoutWithUserID:(NSString*)userID withCompletion:(RequestResultBlock)block;

//上传背景图片info
- (void)uploadImage:(NSDictionary*)param;

//更新诗词info
- (void)updatePoetry:(NSDictionary*)param;
//存在时更新，不存在时新增诗词
- (void)updateOrInsertPoetry:(NSDictionary*)param;

//上传诗词info
- (void)uploadPoetry:(NSDictionary*)param;

//获取热门诗词
- (void)requestHotPoetry:(NSInteger)from count:(NSInteger)count withCompletion:(RequestResultBlock)block;

//获取全部的收藏信息(仅仅id)
- (void)requestUserAllLikes:(NSString*)userId withCompletion:(RequestResultBlock)block;

//获取全部的收藏信息(包含内容)
- (void)requestUserAllCollections:(NSString*)userId from:(NSInteger)from count:(NSInteger)count withCompletion:(RequestResultBlock)block;

//喜欢诗词
- (void)likePoetry:(NSString*)userIdString poetryId:(NSString*)poetryIDString withCompletion:(RequestResultBlock)block;

//取消喜欢诗词
- (void)dislikePoetry:(NSString*)userIdString poetryId:(NSString*)poetryIDString withCompletion:(RequestResultBlock)block;

//获取全部的背景图片
- (void)requestAllBgImagesWithCompletion:(RequestResultBlock)block;

//获取全部的头像图片
- (void)requestAllHeadImagesWithCompletion:(RequestResultBlock)block;

//获取首页的题画图片
- (void)requestHomeTopImageWithCompletion:(RequestResultBlock)block;

//获取全部的诗词配置
- (void)requestPoetryConfigureWithCompletion:(RequestResultBlock)block;

//根据mainClass来获取对应的全部诗词
- (void)requestPoetryWithMainClass:(NSString*)mainClass withCompletion:(RequestResultBlock)block;

//根据关键词来获取对应的全部诗词
- (void)requestPoetryWithKeyword:(NSString*)keyword withPage:(NSInteger)page withCompletion:(RequestResultBlock)block;

//新增一条挑战记录
- (void)addUserChallengeRecord:(NSString*)userId storage:(NSInteger)storage withCompletion:(RequestResultBlock)block;

//获取近期的挑战记录，仅展示10条
- (void)requestUserChallengeInfo:(NSString*)userId withCompletion:(RequestResultBlock)block;

//获取评测的诗词
- (void)requestEvaluatePoetryWithCompletion:(RequestResultBlock)block;

//新增一条反馈
- (void)addOneFeedbackWithUserID:(NSString*)userId content:(NSString*)content contact:(NSString*)contact withCompletion:(RequestResultBlock)block;

//获取诗词的鉴赏信息
- (void)loadAnalysesWithPoetryId:(NSString*)poetryIDString withCompletion:(RequestResultBlock)block;

//用户更新头像
- (void)updateUserHeadImage:(NSString*)headImageUrl withCompletion:(RequestResultBlock)block;

//用户打开app记录
- (void)updateUserOpenAppWithCompletion:(RequestResultBlock)block;

@end

NS_ASSUME_NONNULL_END
