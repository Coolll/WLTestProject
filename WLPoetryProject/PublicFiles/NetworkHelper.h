//
//  NetworkHelper.h
//  WLPoetryProject
//
//  Created by 变啦 on 2019/10/24.
//  Copyright © 2019 龙培. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RequestResultBlock) (BOOL success,NSDictionary *dic,NSError *error);

NS_ASSUME_NONNULL_BEGIN

@interface NetworkHelper : NSObject

+ (NetworkHelper *)shareHelper;

- (void)loginWithUserName:(NSString*)userName password:(NSString*)pwd withCompletion:(RequestResultBlock)block;

- (void)uploadImage:(NSDictionary*)param;

- (void)uploadPoetry:(NSDictionary*)param;

@end

NS_ASSUME_NONNULL_END
