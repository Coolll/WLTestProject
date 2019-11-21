//
//  UserInfoModel.m
//  WLPoetryProject
//
//  Created by 变啦 on 2018/11/12.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

- (instancetype)initUserWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        self.userName = [self notNillValueWithKey:@"nick_name" withDic:dic];
        self.userPassword = [self notNillValueWithKey:@"password" withDic:dic];
        self.userPoetryClass = [self notNillValueWithKey:@"user_poetry_class" withDic:dic];
        self.userPoetryStorage = [self notNillValueWithKey:@"poetry_storage" withDic:dic];
        self.userSessionToken = [self notNillValueWithKey:@"user_token" withDic:dic];
        self.userID = [self notNillValueWithKey:@"user_id" withDic:dic];
        self.email = [self notNillValueWithKey:@"email" withDic:dic];
        self.userHeadImageURL = [self notNillValueWithKey:@"head_image" withDic:dic];
    }
    return self;
}

- (NSString*)notNillValueWithKey:(NSString*)key withDic:(NSDictionary*)dic
{
    id object = [dic objectForKey:key];
    
    if (object) {
        
        NSString *string = [NSString stringWithFormat:@"%@",object];
        return string;
    }
    
    return @"";
    
}


- (void)setValue:(id)value forKey:(NSString *)key
{
    //先调用Super，否则array会被转为字符串
    [super setValue:value forKey:key];

    if ([key isEqualToString:@"likePoetryList"] && [value isKindOfClass:[NSArray class]]) {
        self.likePoetryList = [NSArray arrayWithArray:value];
    }

    if ([key isEqualToString:@"poetryStorageList"] && [value isKindOfClass:[NSArray class]]) {
        self.poetryStorageList = [NSArray arrayWithArray:value];
    }
    
    
}
- (NSString *)fetchName
{
    return self.userName;
}
- (NSString*)fetchPassword
{
    return self.userPassword;
}
- (NSString*)fetchToken
{
    return self.userSessionToken;
}
- (NSString*)fetchImageURL
{
    return self.userHeadImageURL;
}
- (NSString *)fetchUserID
{
    return self.userID;
}
- (BOOL)fetchLoginStatus
{
    return self.isLogin;
}
@end
