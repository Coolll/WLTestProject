//
//  UserInfoModel.m
//  WLPoetryProject
//
//  Created by 变啦 on 2018/11/12.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel
- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"likePoetryList"] && [value isKindOfClass:[NSArray class]]) {
        self.likePoetryList = [NSArray arrayWithArray:value];
    }

    
    [super setValue:value forKey:key];
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
