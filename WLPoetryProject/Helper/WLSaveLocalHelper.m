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


@end
