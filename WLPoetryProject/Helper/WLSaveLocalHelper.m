//
//  WLSaveLocalHelper.m
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/16.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import "WLSaveLocalHelper.h"

@implementation WLSaveLocalHelper

+ (void)saveObject:(id)value forKey:(NSString *)defaultName
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
}

+ (id)loadObjectForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}

#pragma mark - 题画的名称数据增删查
+ (void)saveCustomImageWithName:(NSString*)imageName
{
    id localObject = [self loadObjectForKey:@"WLCustomImageArrayKey"];
    if (localObject && [localObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:localObject];
        [array addObject:imageName];
        
        [self saveObject:[array copy] forKey:@"WLCustomImageArrayKey"];
    }else{
        NSString *name = [NSString stringWithFormat:@"%@",imageName];
        
        [self saveObject:@[name] forKey:@"WLCustomImageArrayKey"];
    }
}
+ (void)deleteCustomImageWithName:(NSString*)imageName
{
    id localObject = [self loadObjectForKey:@"WLCustomImageArrayKey"];
    if (localObject && [localObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:localObject];
        if ([array containsObject:imageName]) {
            [array removeObject:imageName];
        }
        [self saveObject:[array copy] forKey:@"WLCustomImageArrayKey"];
    }
}
+ (NSArray*)loadCustomImageArray
{
    id localObject = [self loadObjectForKey:@"WLCustomImageArrayKey"];
    if (localObject && [localObject isKindOfClass:[NSArray class]]) {
        return localObject;
    }
    return [NSArray array];
}

+ (void)saveUserInfo:(NSDictionary*)userInfo{
    if (userInfo &&[userInfo isKindOfClass:[NSDictionary class]]) {
        
        NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:userInfo];
        
        for (NSString *key in userInfo.allKeys) {
            id object = [userInfo objectForKey:key];
            if (object) {
                NSString *value = [NSString stringWithFormat:@"%@",object];
                if (value.length==0 || [value isEqualToString:@"<null>"]) {
                    [mutDic setObject:@"" forKey:key];
                }
            }else{
                [mutDic setObject:@"" forKey:key];
            }
            
        }
        [self saveObject:mutDic forKey:@"CurrentUserInfo"];
    }else{
        NSLog(@"保存UserID出错");
    }
}

+ (void)deleteUserInfo{
    id localObject = [self loadObjectForKey:@"CurrentUserInfo"];
    if (localObject) {
        [self saveObject:[NSDictionary dictionary] forKey:@"CurrentUserInfo"];
    }
}



+ (NSString*)fetchUserID
{
    id localObject = [self loadObjectForKey:@"CurrentUserInfo"];
    if (localObject && [localObject isKindOfClass:[NSDictionary class]]) {
        
        NSString *finalString = [NSString stringWithFormat:@"%@",[localObject objectForKey:@"user_id"]];
        if (finalString.length > 0 && ![finalString isEqualToString:@"(null)"]) {
            return finalString;
        }
    }
    return @"";
}

+ (NSString*)fetchUserToken
{
    id localObject = [self loadObjectForKey:@"CurrentUserInfo"];
    if (localObject && [localObject isKindOfClass:[NSDictionary class]]) {
        
        NSString *finalString = [NSString stringWithFormat:@"%@",[localObject objectForKey:@"user_token"]];
        if (finalString.length > 0 && ![finalString isEqualToString:@"(null)"]) {
            return finalString;
        }
    }
    return @"";
}
+ (NSString*)fetchUserName
{
    id localObject = [self loadObjectForKey:@"CurrentUserInfo"];
    if (localObject && [localObject isKindOfClass:[NSDictionary class]]) {
        
        NSString *finalString = [NSString stringWithFormat:@"%@",[localObject objectForKey:@"nick_name"]];
        if (finalString.length > 0 && ![finalString isEqualToString:@"(null)"]) {
            return finalString;
        }
    }
    return @"";
}

+ (NSString*)fetchUserPassword
{
    id localObject = [self loadObjectForKey:@"CurrentUserInfo"];
    if (localObject && [localObject isKindOfClass:[NSDictionary class]]) {
        
        NSString *finalString = [NSString stringWithFormat:@"%@",[localObject objectForKey:@"password"]];
        if (finalString.length > 0 && ![finalString isEqualToString:@"(null)"]) {
            return finalString;
        }
    }
    return @"";
}
+ (NSString*)fetchUserHeadImage
{
    id localObject = [self loadObjectForKey:@"CurrentUserInfo"];
    if (localObject && [localObject isKindOfClass:[NSDictionary class]]) {
        
        NSString *finalString = [NSString stringWithFormat:@"%@",[localObject objectForKey:@"head_image"]];
        if (finalString.length > 0 && ![finalString isEqualToString:@"(null)"]) {
            return finalString;
        }
    }
    return @"";
}

+ (void)saveLikeList:(NSArray*)array{
    
    if (array && [array isKindOfClass:[NSArray class]]) {
        
        NSMutableArray *temArray = [NSMutableArray array];
        for (int i =0; i<array.count; i++) {
            NSString *string = [NSString stringWithFormat:@"%@",[array objectAtIndex:i]];
            [temArray addObject:[NSString stringWithFormat:@"%@",string]];
        }
        [self saveObject:[array copy] forKey:@"WLUserLikeList"];
    }else{
        [self saveObject:[NSArray array] forKey:@"WLUserLikeList"];
    }

}
+ (NSArray*)fetchLikeList{
    id localObject = [self loadObjectForKey:@"WLUserLikeList"];
    if (localObject && [localObject isKindOfClass:[NSArray class]]) {
        
        return [NSArray arrayWithArray:localObject];
    }
    return [NSArray array];
}


@end
