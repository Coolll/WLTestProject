//
//  UserInfo+CoreDataProperties.m
//  WLPoetryProject
//
//  Created by 变啦 on 2018/11/12.
//  Copyright © 2018年 龙培. All rights reserved.
//
//

#import "UserInfo+CoreDataProperties.h"

@implementation UserInfo (CoreDataProperties)

+ (NSFetchRequest<UserInfo *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"UserInfo"];
}

@dynamic userName;
@dynamic userPassword;
@dynamic phoneNumber;
@dynamic userPoetryClass;
@dynamic userPoetryStorage;
@dynamic likePoetryList;
@dynamic userSessionToken;
@dynamic userHeadImageURL;
@dynamic userID;

@end
