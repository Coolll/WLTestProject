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
 "author" : "<##>",
 "content" : "<##>",
 "addtionInfo" : "<##>",
 "classInfo" : "<##>",
 "poetryID" : "<##>",
 "source" : "<##>",
 "analysesInfo" : "<##>",
 "transferInfo" : "<##>",
 "backgroundInfo" : "<##>",
 "backImageName" : "",
 "bgImageURL" : "",
 "placeHolder" : "",
 "likes":"<##>"
 },
 */

@interface BackupHelper : NSObject
+ (BackupHelper *)shareInstance;
- (void)uploadAllImages;
- (void)updateAllPoetry;
- (void)uploadAllPoetry;

- (void)updateRecommendPoetryThree;


@end
