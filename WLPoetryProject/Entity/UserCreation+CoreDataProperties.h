//
//  UserCreation+CoreDataProperties.h
//  WLPoetryProject
//
//  Created by 变啦 on 2018/8/24.
//  Copyright © 2018年 龙培. All rights reserved.
//
//

#import "UserCreation+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface UserCreation (CoreDataProperties)

+ (NSFetchRequest<UserCreation *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *creationAuthor;//作者
@property (nullable, nonatomic, copy) NSString *isPost;//是否发布
@property (nullable, nonatomic, copy) NSString *creationTitle;//标题
@property (nullable, nonatomic, copy) NSString *creationContent;//内容
@property (nullable, nonatomic, copy) NSString *isLike;//是否点赞了
@property (nullable, nonatomic, copy) NSString *authorID;//作者的ID
@property (nullable, nonatomic, copy) NSString *creationID;//作品的ID

@end

NS_ASSUME_NONNULL_END
