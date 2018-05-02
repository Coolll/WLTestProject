//
//  NetworkCenter.m
//  CustomNetwork
//
//  Created by 龙培 on 17/5/11.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import "NetworkCenter.h"
#import "AFNetworking.h"
#import "SBJson4.h"
#import "MBProgressHUD.h"
#import "MyMBProgress.h"

@interface NetworkCenter ()
/**
 *  网络请求的manager
 **/
@property (nonatomic,strong) AFHTTPSessionManager  *manager;

/**
 *  网络状态
 **/
@property (nonatomic,assign) NetworkStates currentState;




@end

@implementation NetworkCenter

#pragma mark - 单例初始化
+ (instancetype)shareCenter
{
    static NetworkCenter *center = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        center = [[NetworkCenter alloc]init];
    });
    
    return center;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _manager = [[AFHTTPSessionManager alloc]initWithBaseURL:nil];
        
        _manager.requestSerializer.timeoutInterval = 15;
        
        //不使用这句话
        //_manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        //这样配置，保持和后台保持一致，上面一句如果打开，则无法进行POST请求。
        [_manager.requestSerializer setStringEncoding:NSUTF8StringEncoding];

        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            
            [self reachabilityChanged:status];
        }];
        
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
    }
    
    return self;
}

#pragma mark  网络状态监控
- (void)reachabilityChanged:(AFNetworkReachabilityStatus)status {
    switch (status) {
        case AFNetworkReachabilityStatusUnknown:
            break;
        case AFNetworkReachabilityStatusNotReachable:
            _currentState = NetworkStatesNotReachable;
            [MyMBProgress showTextMessage:@"您的手机貌似还未连接网络，请检查网络连接"];
            NSLog(@"没有网络");
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            _currentState = NetworkStatesWWAN;
            NSLog(@"正在使用3G网络");
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            _currentState = NetworkStatesWiFi;
            NSLog(@"正在使用wifi网络");
            break;
            
        default:
            break;
    }
}

- (void)configureHeader:(NSString*)content
{
//    [_manager.requestSerializer setValue:kUserToken forHTTPHeaderField:@"token"];

}

#pragma mark - 请求的方法
- (void)requestDataWithURL:(NSString*)urlString
                withParams:(NSDictionary *)params
              withHttpType:(HttpType)type
              withProgress:(void(^)(id progress))progressBlock
                 withResult:(void(^)(id result))resultBlock
                 withError:(void(^)(NSInteger errorCode,NSString *errorMsg))errorBlock
              isSupportHUD:(BOOL)isSupportHUD
{
    
    /*
     if ([result isKindOfClass:[NSDictionary class]]) {
     
     NSString *codeString = [NSString stringWithFormat:@"%@",result[@"code"]];
     
     if ([codeString isEqualToString:@"1000"]) {
     
     
     
     }else{
     [self showHUDWithText:[NSString stringWithFormat:@"%@",result[@"msg"]]];
     }
     }
     */
    
    
    if (isSupportHUD) {
        
        MBProgressHUD *hud = [MBProgressHUD HUDForView:[UIApplication sharedApplication].keyWindow];
        
        if (!hud) {
            hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            
            hud.label.text = @"正在加载中...";
        }
    }
    
    
    switch (type) {
        #pragma mark GET请求
        case GET_HttpType:
        {
            [self httpRequestWithContentURLString:urlString withParameter:params withIsPost:NO withProgressBlock:^(NSProgress *progress) {
                
                if (progressBlock) {
                    progressBlock(progress);
                }
                
            } withResponseBlock:^(NSData *result, NSError *error, NSURLSessionDataTask * _Nullable task) {
                
                if (isSupportHUD) {
                    [self hideTheHUD];
                }
                
                [self handleJsonData:result withError:error withTask:task withResultBlock:resultBlock withErrorBlock:errorBlock isSupportHud:isSupportHUD];
                
            }];
            
        } break;
            
        #pragma mark POST请求
        case POST_HttpType:
        {
        
            [self httpRequestWithContentURLString:urlString withParameter:params withIsPost:YES withProgressBlock:^(NSProgress *progress) {
                
                if (progressBlock) {
                    progressBlock(progress);
                }
                
            } withResponseBlock:^(NSData *result, NSError *error, NSURLSessionDataTask * _Nullable task) {
               
                /*从响应头中拿数据
                NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                NSDictionary *allHeaders = response.allHeaderFields;
                NSLog(@"dic:%@",allHeaders);
                 */
                
                if (isSupportHUD) {
                    [self hideTheHUD];
                }
                
                [self handleJsonData:result withError:error withTask:task withResultBlock:resultBlock withErrorBlock:errorBlock isSupportHud:isSupportHUD];
            }];
        
        } break;
        
        #pragma mark Form表单
        case Form_HttpType:
        {
            NSDictionary *body = params[@"body"];
            NSArray *images = params[@"images"];
            NSArray *imageKeys = params[@"imageKeys"];
            NSArray *imageFileKeys = params[@"imageFileKeys"];
            
            [self httpFormWithContentURLString:urlString withBody:body withProgressBlock:^(NSProgress *progress) {
               
                if (progressBlock) {
                    progressBlock(progress);
                }

                
            } withResponseBlock:^(NSData *result, NSError *error, NSURLSessionDataTask * _Nullable task) {
                
                if (isSupportHUD) {
                    [self hideTheHUD];
                }
                
                [self handleJsonData:result withError:error withTask:task withResultBlock:resultBlock withErrorBlock:errorBlock isSupportHud:isSupportHUD];

            } images:images imageKeys:imageKeys imageFileKeys:imageFileKeys];
            
        } break;
            
        default:
            break;
    }
}

#pragma mark - 隐藏HUD
- (void)hideTheHUD
{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    
}


#pragma mark - GET与POST请求实现
- (void)httpRequestWithContentURLString:(NSString *)contentUrl
                          withParameter:(NSDictionary *)parameter
                             withIsPost:(BOOL)isPost
                      withProgressBlock:(void (^)(NSProgress *progress))progressBlock
                      withResponseBlock:(void (^)(NSData *result, NSError *error, NSURLSessionDataTask * _Nullable task))block
{
    if (isPost) {
        
        [_manager POST:contentUrl parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
            
            if (progressBlock) {
                progressBlock(uploadProgress);
            }
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (block) {
                block(responseObject,nil,task);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (block) {
                block(nil,error,task);
            }
            
        }];
        
    }else{
        
        
        [_manager GET:contentUrl parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progressBlock) {
                progressBlock(downloadProgress);
            }
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (block) {
                block(responseObject,nil,task);
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            
            if (block) {
                block(nil,error,task);
            }
        }];
        
    }
}

#pragma mark - Form表单实现
- (void)httpFormWithContentURLString:(NSString *)contentUrl
                            withBody:(NSDictionary *)body
                   withProgressBlock:(void (^)(NSProgress *progress))progressBlock
                   withResponseBlock:(void (^)(NSData *result, NSError *error, NSURLSessionDataTask * _Nullable task))block
                              images:(NSArray *)images
                           imageKeys:(NSArray *)imagekeys
                       imageFileKeys:(NSArray *)fileKeys
{
    [_manager POST:contentUrl parameters:body constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i < images.count; i++) {
            NSData *imageData = UIImageJPEGRepresentation(images[i], 0.5);
            
            [formData appendPartWithFileData:imageData name:[fileKeys objectAtIndex:i] fileName:[imagekeys objectAtIndex:i] mimeType:@"image/jpg"];
            
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progressBlock) {
            progressBlock(uploadProgress);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject && block) {
            block(responseObject,nil,task);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (block) {
            block(nil,error,task);
        }
    }];
}

#pragma mark - 数据解析

- (void)handleJsonData:(NSData *)data
             withError:(NSError *)error
              withTask:(id)task
       withResultBlock:(void (^)(id data))resultBlock
        withErrorBlock:(void (^)(NSInteger errorCode,NSString *errorMsg))errorBlock
          isSupportHud:(BOOL)isSupportHud{
    if (error == nil) {
        
        //返回的数据如果是
        if ([data isKindOfClass:[NSDictionary class]]) {
            
            if (resultBlock) {
                resultBlock(data);
            }
            
            return;
        }
        
        [self doVerfiyJson:data withResultBlock:^(id data) {

            if (resultBlock) {
                resultBlock(data);
            }
            
        } withErrorBlock:^(NSInteger errorCode, NSString *errorMsg) {
           
            if (errorBlock) {
                errorBlock(errorCode, errorMsg);

            }
            
        } isSupportHud:isSupportHud];
        
    } else {
        
        [self doErrorMsg:error withErrorBlock:errorBlock withTask:task isSupportHud:isSupportHud];
    }
}

- (void)doJsonSerialization:(NSData *)jsonData withParserCallback:(void(^)(NSDictionary *result, NSError *error))parseCallback {
    
        
    SBJson4Parser *parser = [SBJson4Parser parserWithBlock:^(id item, BOOL *stop) {
        if ([item isKindOfClass:[NSDictionary class]]) {
            
            if (parseCallback) {
                parseCallback(item, nil);
            }
            
        } else {
            NSError *error = [NSError errorWithDomain:@"CustomHttpSerializationError" code:0 userInfo:@{@"error":item}];
           
            if (parseCallback) {
                parseCallback(nil, error);

            }
            
        }
    } allowMultiRoot:NO unwrapRootArray:NO errorHandler:^(NSError *error) {
        
        if (parseCallback) {
            parseCallback(nil ,error);

        }
        
    }];
    
    [parser parse:jsonData];
}


- (void)doVerfiyJson:(NSData *)jsonData
     withResultBlock:(void (^)(id data))resultBlock
      withErrorBlock:(void (^)(NSInteger errorCode,NSString *errorMsg))errorBlock
        isSupportHud:(BOOL)isSupportHud{
    [self doJsonSerialization:jsonData withParserCallback:^(NSDictionary *result, NSError *error)
     {
         
         if (!error) {
             resultBlock(result);
         } else {
             errorBlock(error.code,error.domain);
             if ([error.domain isEqualToString:@"CustomHttpSerializationError"]) {
                 //解析的不是NSDictionary类型
                 [MyMBProgress showTextMessage:@"解析的不是字典类型"];
             } else {
                 //解析错误
                 [MyMBProgress showTextMessage:@"解析错误"];
             }
         }
     }];
}

#pragma mark 网络错误
- (void)doErrorMsg:(NSError *)error
    withErrorBlock:(void (^)(NSInteger errorCode,NSString *errorMsg))errorBlock
          withTask:(id)task
      isSupportHud:(BOOL)isSupportHud{
    errorBlock(error.code, error.localizedDescription);
    NSLog(@"error = %@",error);
    
    if ([task isKindOfClass:[NSURLSessionDataTask class]]) {
        if (((NSHTTPURLResponse *)((NSURLSessionDataTask *)task).response).statusCode   == 404) {
//            [MyMBProgress showTextMessage:@"页面被外星人劫走了，我们已经派出最强程序猿找回"];
        } else if (((NSHTTPURLResponse *)((NSURLSessionDataTask *)task).response).statusCode == 500) {
//            [MyMBProgress showTextMessage:@"服务器已经被挤得水泄不通，麻烦稍后再试"];
            
        } else {
//            [MyMBProgress showTextMessage:@"网络开了个小差，请稍后重试"];
            
        }
    } else if ([task isKindOfClass:[NSHTTPURLResponse class]]) {
        if (((NSHTTPURLResponse *)task).statusCode == 404) {
//            [MyMBProgress showTextMessage:@"页面被外星人劫走了，我们已经派出最强程序猿找回"];
            
        } else if (((NSHTTPURLResponse *)task).statusCode == 500) {
//            [MyMBProgress showTextMessage:@"服务器已经被挤得水泄不通，麻烦稍后再试"];
            
        } else {
//            [MyMBProgress showTextMessage:@"网络开了个小差，请稍后重试"];
            
        }
    }
}


@end
