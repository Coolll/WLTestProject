//
//  Poetry+CoreDataProperties.m
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/7/6.
//  Copyright © 2018年 龙培. All rights reserved.
//
//

#import "Poetry+CoreDataProperties.h"

@implementation Poetry (CoreDataProperties)

+ (NSFetchRequest<Poetry *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Poetry"];
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
@dynamic mainClass;
@dynamic name;
@dynamic poetryID;
@dynamic source;
@dynamic transferInfo;
@dynamic myPropertyForOne;

@end
