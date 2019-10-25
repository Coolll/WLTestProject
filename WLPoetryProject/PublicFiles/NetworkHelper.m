//
//  NetworkHelper.m
//  WLPoetryProject
//
//  Created by 变啦 on 2019/10/24.
//  Copyright © 2019 龙培. All rights reserved.
//

#import "NetworkHelper.h"
#import "BaseNetwork.h"
@interface NetworkHelper()
/**
 *  base
 **/
@property (nonatomic,strong) BaseNetwork *baseNetwork;


@end
@implementation NetworkHelper

+ (NetworkHelper *)shareHelper{
    static NetworkHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[NetworkHelper alloc] init];
        helper.baseNetwork = [BaseNetwork shareInstance];
    });
    return helper;
}


#pragma mark - 网络请求

- (void)uploadImage:(NSDictionary*)param
{
    [self.baseNetwork requestPostWithBody:param withUrlString:@"http://192.168.2.123:8080/api/image/insert" withCompletion:NULL];
}


- (void)uploadPoetry:(NSDictionary*)param
{
    [self.baseNetwork requestPostWithBody:param withUrlString:@"http://192.168.2.123:8080/api/poetry/insert" withCompletion:NULL];

}

- (void)loginWithUserName:(NSString*)userName password:(NSString*)pwd withCompletion:(RequestResultBlock)block
{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:userName forKey:@"nickName"];
    [param setObject:pwd forKey:@"password"];
    
    [self.baseNetwork requestPostWithBody:param withUrlString:@"http://192.168.0.123:8080/api/user/loginAndRegister" withCompletion:block];
}


@end
