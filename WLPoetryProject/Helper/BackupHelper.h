//
//  BackupHelper.h
//  WLPoetryProject
//
//  Created by 变啦 on 2019/10/29.
//  Copyright © 2019 龙培. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 
 {
"name" : "<##>",
"author" : "<##>·<##>",
"content" : "<##>",
"transferInfo" : "<##>",
"addtionInfo" : "<##>",
"analysesInfo" : "<##>",
"backgroundInfo" : "<##>",
"classInfo" : "<##>",
"poetryID" : "<##>",
"source" : "<##>",
"backImageName" : "",
"bgImageURL" : "",
"placeHolder" : "",
"likes":"<##>"
},

 {
"name" : "<##>",
"author" : "<##>·<##>",
"content" : "<##>",
"transferInfo" : "<##>",
"addtionInfo" : "<##>",
"analysesInfo" : "<##>",
"backgroundInfo" : "<##>",
"classInfo" : "<##>",
"poetryID" : "<##>",
"source" : "<##>",
"likes":"<##>"
},
 */

@interface BackupHelper : NSObject
+ (BackupHelper *)shareInstance;
- (void)uploadAllImages;
- (void)updateAllPoetry;
- (void)uploadAllPoetry;

- (void)updateRecommendPoetry;


@end