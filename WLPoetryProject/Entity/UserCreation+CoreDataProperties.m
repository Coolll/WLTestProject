//
//  UserCreation+CoreDataProperties.m
//  WLPoetryProject
//
//  Created by 变啦 on 2018/8/24.
//  Copyright © 2018年 龙培. All rights reserved.
//
//

#import "UserCreation+CoreDataProperties.h"

@implementation UserCreation (CoreDataProperties)

+ (NSFetchRequest<UserCreation *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"UserCreation"];
}

@dynamic creationAuthor;
@dynamic isPost;
@dynamic creationTitle;
@dynamic creationContent;
@dynamic isLike;
@dynamic authorID;
@dynamic creationID;
@end
