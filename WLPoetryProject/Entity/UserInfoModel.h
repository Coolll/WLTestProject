//
//  UserInfoModel.h
//  WLPoetryProject
//
//  Created by 变啦 on 2018/11/12.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLBaseModel.h"

@interface UserInfoModel : WLBaseModel

@property (nullable, nonatomic, copy) NSString *userName;//用户名
@property (nullable, nonatomic, copy) NSString *userPassword;//密码
@property (nullable, nonatomic, copy) NSString *phoneNumber;//手机号
@property (nullable, nonatomic, copy) NSString *userPoetryClass;//用户的词汇量等级，0表示基本，7为状元
@property (nullable, nonatomic, copy) NSString *userPoetryStorage;//用户的诗词储量
@property (nullable, nonatomic, copy) NSArray *likePoetryList;//收藏的诗词列表
/**
 *  历史的诗词量
 **/
@property (nonatomic,copy) NSArray *poetryStorageList;


@property (nullable, nonatomic, copy) NSString *userSessionToken;//用户的token
@property (nullable, nonatomic, copy) NSString *userHeadImageURL;//用户的头像URL
@property (nullable, nonatomic, copy) NSString *userID;//用户的ID
/**
 *  是否登陆
 **/
@property (nonatomic,assign) BOOL isLogin;



- (NSString*)fetchName;
- (NSString*)fetchPassword;
- (NSString*)fetchToken;
- (NSString*)fetchImageURL;
- (NSString*)fetchUserID;
- (BOOL)fetchLoginStatus;

@end