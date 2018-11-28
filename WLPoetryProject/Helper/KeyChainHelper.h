//
//  KeyChainHelper.h
//  TestKeyChain
//
//  Created by 龙培 on 17/3/29.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainHelper : NSObject

//存储
+ (void)saveKey:(NSString*)service withValue:(id)data;

//读取
+ (id)loadDataWithKey:(NSString*)service;

//删除
+ (void)deleteDataWithKey:(NSString*)service;

@end
