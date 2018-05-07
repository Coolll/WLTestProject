//
//  Poetry+CoreDataProperties.m
//  WLPoetryProject
//
//  Created by 龙培 on 2018/5/7.
//  Copyright © 2018年 龙培. All rights reserved.
//
//

#import "Poetry+CoreDataProperties.h"

@implementation Poetry (CoreDataProperties)

+ (NSFetchRequest<Poetry *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Poetry"];
}

@dynamic addtionInfo;
@dynamic analysesInfo;
@dynamic author;
@dynamic backgroundInfo;
@dynamic backImageName;
@dynamic classInfo;
@dynamic content;
@dynamic firstLineString;
@dynamic isLike;
@dynamic isRecited;
@dynamic isShowed;
@dynamic name;
@dynamic poetryID;
@dynamic source;
@dynamic transferInfo;
@dynamic mainClass;

@end
