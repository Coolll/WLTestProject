//
//  NetworkCenter.h
//  CustomNetwork
//
//  Created by 龙培 on 17/5/11.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, HttpType) {

    GET_HttpType,//GET请求
    POST_HttpType,//POST请求
    Form_HttpType//Form表单
};

typedef NS_ENUM(NSInteger,NetworkStates) {
    NetworkStatesNotReachable,//网络不可用
    NetworkStatesWWAN,//  3G／4G流量
    NetworkStatesWiFi//无线局域网
};

@interface NetworkCenter : NSObject

+ (instancetype)shareCenter;

- (void)configureHeader:(NSString*)content;

- (void)requestDataWithURL:(NSString*)urlString
                withParams:(NSDictionary *)params
              withHttpType:(HttpType)type
              withProgress:(void(^)(id progress))progressBlock
                withResult:(void(^)(id result))resultBlock
                 withError:(void(^)(NSInteger errorCode,NSString *errorMsg))errorBlock
              isSupportHUD:(BOOL)isSupportHUD;
@end
