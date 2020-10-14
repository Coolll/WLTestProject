//
//  BaseNetwork.h
//  WLPoetryProject
//
//  Created by 变啦 on 2019/10/24.
//  Copyright © 2019 龙培. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^BaseResultBlock) (BOOL success,NSDictionary * _Nullable dic,NSError *error);

NS_ASSUME_NONNULL_BEGIN

@interface BaseNetwork : NSObject
+ (BaseNetwork *)shareInstance;

- (void)requestWithParam:(NSDictionary*)param withUrlString:(NSString*)urlString withCompletion:(nullable BaseResultBlock)block;

- (void)requestPostWithBody:(NSDictionary*)body withUrlString:(NSString*)urlString withCompletion:(nullable BaseResultBlock)block;
@end

NS_ASSUME_NONNULL_END
