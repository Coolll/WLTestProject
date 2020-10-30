//
//  WLSaveLocalHelper.h
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/16.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLSaveLocalHelper : NSObject

+ (void)saveObject:(id)value forKey:(NSString *)defaultName;
+ (id)loadObjectForKey:(NSString *)defaultName;


+ (void)saveCustomImageWithName:(NSString*)imageName;
+ (void)deleteCustomImageWithName:(NSString*)imageName;

+ (NSArray*)loadCustomImageArray;


+ (void)saveUserInfo:(NSDictionary*)userInfo;
+ (void)deleteUserInfo;
+ (NSString*)fetchUserID;
+ (NSString*)fetchUserToken;
+ (NSString*)fetchUserName;
+ (NSString*)fetchUserPassword;
+ (NSString*)fetchUserHeadImage;

+ (void)saveLikeList:(NSArray*)array;
+ (NSArray*)fetchLikeList;

//保存阅读背景色
+ (void)saveReadImageURLOrBackgroundRGB:(NSString*)imageURL;
+ (NSString*)fetchReadImageURLOrRGB;

//保存阅读文本颜色
+ (void)saveReadTextRGB:(NSString*)rgb;
+ (NSString*)fetchReadTextRGB;

//阅读特效
+ (void)saveReadEffectOpen:(BOOL)needEffect;
+ (BOOL)fetchReadEffectOpen;
//保存阅读特效类型
+ (void)saveReadEffectType:(NSString*)type;
+ (NSString*)fetchReadEffectType;


@end
