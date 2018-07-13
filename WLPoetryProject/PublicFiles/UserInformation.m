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

- (void)refreshUserInfoWithUser:(BmobUser*)user
{
    self.userName = [NSString stringWithFormat:@"%@",[user objectForKey:@"username"]];
    self.uid = [NSString stringWithFormat:@"%@",user.objectId];
    self.token = [NSString stringWithFormat:@"%@",[user objectForKey:@"sessionToken"]];
    self.password = [NSString stringWithFormat:@"%@",user.password];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[user objectForKey:@"likePoetryIDList"]];
    self.likePoetryList = [NSMutableArray arrayWithArray:array];
    
    
    
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
    self.ubalance = [self notNillValueWithKey:@"ubalance" withDic:dic];
    self.uid = [self notNillValueWithKey:@"uid" withDic:dic];
    self.uphone = [self notNillValueWithKey:@"uphone" withDic:dic];
    self.userCreateTime = [self notNillValueWithKey:@"userCreateTime" withDic:dic];
//    self.userImgurl = [self notNillValueWithKey:@"userImgurl" withDic:dic];
    NSString *imagePath = [self notNillValueWithKey:@"userImgurl" withDic:dic];
    NSString *fullPath = [NSString stringWithFormat:@"%@%@",UserHeadImageBase,imagePath];
    self.userImgurl = fullPath;
    self.userIntegral = [self notNillValueWithKey:@"userIntegral" withDic:dic];
    self.userName = [self notNillValueWithKey:@"userName" withDic:dic];
    self.userState = [self notNillValueWithKey:@"userState" withDic:dic];
    self.userUpdateTime = [self notNillValueWithKey:@"userUpdateTime" withDic:dic];

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
