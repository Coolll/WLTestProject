//
//  UserInfo+CoreDataProperties.m
//  WLPoetryProject
//
//  Created by 变啦 on 2018/11/27.
//  Copyright © 2018年 龙培. All rights reserved.
//
//

#import "UserInfo+CoreDataProperties.h"

@implementation UserInfo (CoreDataProperties)

+ (NSFetchRequest<UserInfo *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"UserInfo"];
}

@dynamic isLogin;
@dynamic likePoetryList;
@dynamic phoneNumber;
@dynamic poetryStorageList;
@dynamic userHeadImageURL;
@dynamic userID;
@dynamic userName;
@dynamic userPassword;
@dynamic userPoetryClass;
@dynamic userPoetryStorage;
@dynamic userSessionToken;
@dynamic imageURL;

@end
