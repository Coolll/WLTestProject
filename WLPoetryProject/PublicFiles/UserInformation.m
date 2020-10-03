//
//  UserInformation.m
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/16.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import "UserInformation.h"

@implementation UserInformation

+ (instancetype)shareUser
{
    static UserInformation *user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[UserInformation alloc] init];
    });
    return user;

}




- (void)refreshUserTokenWithDictionary:(NSDictionary*)dic
{
    self.token = [self notNillValueWithKey:@"token" withDic:dic];
    self.userName = [self notNillValueWithKey:@"userName" withDic:dic];
    self.password = [self notNillValueWithKey:@"password" withDic:dic];
    self.uid = [self notNillValueWithKey:@"userId" withDic:dic];

    self.ubalance = [self notNillValueWithKey:@"ubalance" withDic:dic];
    self.uphone = [self notNillValueWithKey:@"uphone" withDic:dic];
    self.userCreateTime = [self notNillValueWithKey:@"userCreateTime" withDic:dic];
    self.userImgurl = [self notNillValueWithKey:@"userImgurl" withDic:dic];
    self.userIntegral = [self notNillValueWithKey:@"userIntegral" withDic:dic];
    
    self.userState = [self notNillValueWithKey:@"userState" withDic:dic];
    self.userUpdateTime = [self notNillValueWithKey:@"userUpdateTime" withDic:dic];
    
}

- (void)refreshUserWithDictionary:(NSDictionary*)dic
{
    self.userName = [self notNillValueWithKey:@"nick_name" withDic:dic];
    self.uid = [self notNillValueWithKey:@"user_id" withDic:dic];
    self.password = [self notNillValueWithKey:@"password" withDic:dic];
    self.userPoetryClass = [self notNillValueWithKey:@"user_poetry_class" withDic:dic];
    self.userPoetryStorage = [self notNillValueWithKey:@"poetry_storage" withDic:dic];
    self.userImgurl = [self notNillValueWithKey:@"head_image" withDic:dic];
    self.likePoetryList = [NSMutableArray array];

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


@end
