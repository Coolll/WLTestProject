//
//  BackupHelper.h
//  WLPoetryProject
//
//  Created by 变啦 on 2019/10/29.
//  Copyright © 2019 龙培. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackupHelper : NSObject
+ (BackupHelper *)shareInstance;
- (void)uploadAllImages;
- (void)updateAllPoetry;
- (void)uploadAllPoetry;

@end
