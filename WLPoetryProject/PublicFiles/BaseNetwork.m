//
//  BaseNetwork.m
//  WLPoetryProject
//
//  Created by 变啦 on 2019/10/24.
//  Copyright © 2019 龙培. All rights reserved.
//

#import "BaseNetwork.h"


@interface BaseNetwork()

@end

@implementation BaseNetwork
+ (BaseNetwork *)shareInstance{
    static BaseNetwork *base = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        base = [[BaseNetwork alloc] init];
    });
    return base;
}


#pragma mark - 网络请求

- (void)requestWithParam:(NSDictionary*)param withUrlString:(NSString*)urlString withCompletion:(nullable BaseResultBlock)block
{
    
    //1 获取URL
    NSURL *url = [NSURL URLWithString:urlString];
    //构建请求参数
    
    //2 初始化manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // manager的响应类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //3 使用AFNetWorking的GET方法进行网络请求
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [manager GET:url.absoluteString parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary*)responseObject;
                NSLog(@"dic:%@",dic);
                if (block) {
                    block(YES, dic, nil);
                }

            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (block) {
                block(NO, nil, error);
            }
        }];
        
        
    });
    
}



- (void)requestPostWithBody:(NSDictionary*)body withUrlString:(NSString*)path withCompletion:(nullable BaseResultBlock)block
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,path];

    //1 获取URL
    NSURL *url = [NSURL URLWithString:urlString];
    //构建请求参数
    
    //2 初始化manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // manager的响应类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //manager的请求类型，等同于设置了content-type为application/json，后端使用RequestBody来接收前端post的参数时有效
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //这一句和上一句不兼容，这里设置content-type为application/x-www-form-urlencoded，后端使用RequestParam来接收前端post的参数时有效。
//    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    //3 使用AFNetWorking的POST方法进行网络请求
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [manager POST:url.absoluteString parameters:body progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary*)responseObject;
                NSLog(@"dic内容:%@",dic);

                if (block) {
                    block(YES, dic, nil);
                }
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (block) {
                block(NO, nil, error);
            }
            
        }];
        
        
        
    });
    
}

@end
