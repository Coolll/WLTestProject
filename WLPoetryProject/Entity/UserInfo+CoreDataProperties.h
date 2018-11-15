//
//  UserInfo+CoreDataProperties.h
//  WLPoetryProject
//
//  Created by 变啦 on 2018/11/15.
//  Copyright © 2018年 龙培. All rights reserved.
//
//

#import "UserInfo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface UserInfo (CoreDataProperties)

+ (NSFetchRequest<UserInfo *> *)fetchRequest;

@property (nonatomic) BOOL isLogin;
@property (nullable, nonatomic, copy) NSString *likePoetryList;
@property (nullable, nonatomic, copy) NSString *phoneNumber;
@property (nullable, nonatomic, copy) NSString *userHeadImageURL;
@property (nullable, nonatomic, copy) NSString *userID;
@property (nullable, nonatomic, copy) NSString *userName;
@property (nullable, nonatomic, copy) NSString *userPassword;
@property (nullable, nonatomic, copy) NSString *userPoetryClass;
@property (nullable, nonatomic, copy) NSString *userPoetryStorage;
@property (nullable, nonatomic, copy) NSString *userSessionToken;
@property (nullable, nonatomic, copy) NSString *poetryStorageList;

@end

NS_ASSUME_NONNULL_END
