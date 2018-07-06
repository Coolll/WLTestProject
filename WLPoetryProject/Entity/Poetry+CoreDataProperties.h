//
//  Poetry+CoreDataProperties.h
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/7/6.
//  Copyright © 2018年 龙培. All rights reserved.
//
//

#import "Poetry+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Poetry (CoreDataProperties)

+ (NSFetchRequest<Poetry *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *addtionInfo;
@property (nullable, nonatomic, copy) NSString *analysesInfo;
@property (nullable, nonatomic, copy) NSString *author;
@property (nullable, nonatomic, copy) NSString *backgroundInfo;
@property (nullable, nonatomic, copy) NSString *backImageName;
@property (nullable, nonatomic, copy) NSString *classInfo;
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSString *firstLineString;
@property (nullable, nonatomic, copy) NSString *isLike;
@property (nullable, nonatomic, copy) NSString *isRecited;
@property (nullable, nonatomic, copy) NSString *isShowed;
@property (nullable, nonatomic, copy) NSString *mainClass;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *poetryID;
@property (nullable, nonatomic, copy) NSString *source;
@property (nullable, nonatomic, copy) NSString *transferInfo;
@property (nullable, nonatomic, copy) NSString *myPropertyForOne;

@end

NS_ASSUME_NONNULL_END
