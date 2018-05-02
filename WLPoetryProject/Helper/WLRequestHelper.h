//
//  WLRequestHelper.h
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/11.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLRequestHelper : NSObject

+ (WLRequestHelper *)defaultHelper;


- (id)dealWithOriginData:(NSDictionary*)dataDic;

@end
