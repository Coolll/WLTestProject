//
//  WLRequestHelper.m
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/11.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import "WLRequestHelper.h"

@implementation WLRequestHelper

+ (WLRequestHelper *)defaultHelper{
    static WLRequestHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[WLRequestHelper alloc] init];
    });
    return helper;
}

- (void)checkNetwork{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];

    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            NSLog(@"网络不可用");

            self.canReachNetwork = NO;
        }else if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi){
            self.canReachNetwork = YES;
            if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
                NSLog(@"WIFI网络");

                self.isWIFI = YES;
            }else{
                NSLog(@"4G网络");
                self.isWIFI = NO;
            }
        }
    }];
}



@end
