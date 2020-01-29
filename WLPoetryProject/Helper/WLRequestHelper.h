//
//  WLRequestHelper.h
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/11.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLRequestHelper : NSObject
/**
 *  是否有网络
 **/
@property (nonatomic,assign) BOOL canReachNetwork;

/**
 *  当前网络是否为WIFI
 **/
@property (nonatomic,assign) BOOL isWIFI;


+ (WLRequestHelper *)defaultHelper;

- (void)checkNetwork;


@end
