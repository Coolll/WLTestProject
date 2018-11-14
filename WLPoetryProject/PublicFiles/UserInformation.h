//
//  UserInformation.h
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/16.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <BmobSDK/Bmob.h>
@interface UserInformation : NSObject

/**
 *  标识
 **/
@property (nonatomic,copy) NSString *token;

/**
 *  用户余额
 **/
@property (nonatomic,copy) NSString *ubalance;

/**
 *  用户ID
 **/
@property (nonatomic,copy) NSString *uid;

/**
 *  用户手机号
 **/
@property (nonatomic,copy) NSString *uphone;

/**
 *  创建时间
 **/
@property (nonatomic,copy) NSString *userCreateTime;
/**
 *  用户头像
 **/
@property (nonatomic,copy) NSString *userImgurl;
/**
 *  用户的诗词量
 **/
@property (nonatomic,copy) NSString *userPoetryStorage;
/**
 *  用户的等级
 **/
@property (nonatomic,copy) NSString *userPoetryClass;

/**
 *  属性
 **/
@property (nonatomic,copy) NSString *userIntegral;

/**
 *  用户名
 **/
@property (nonatomic,copy) NSString *userName;
/**
 *  密码
 **/
@property (nonatomic,copy) NSString *password;

/**
 *  状态
 **/
@property (nonatomic,copy) NSString *userState;

/**
 *  更新时间
 **/
@property (nonatomic,copy) NSString *userUpdateTime;

/**
 *  收藏诗词的列表
 **/
@property (nonatomic, strong) NSMutableArray *likePoetryList;


+ (instancetype)shareUser;

- (void)refreshUserTokenWithDictionary:(NSDictionary*)dic;

- (void)refreshUserWithDictionary:(NSDictionary*)dic;

- (void)refreshUserInfoWithUser:(BmobUser*)user;


@end
