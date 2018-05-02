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

- (id)dealWithOriginData:(NSDictionary*)dataDic
{
    /*
     {
     code = 1000;
     data =     {
     obj =         (
     {
     bid = 2;
     createTime = 1502422764000;
     imageUrl = "/1/1/1.img";
     modelSource = 2;
     redirtType = 2;
     redirtUrl = 1;
     state = 0;
     title = 12346;
     updateTime = 1502422765000;
     }
     );
     };
     msg = success;
     }

     */
    
    if ([dataDic isKindOfClass:[NSDictionary class]]) {
        
        
        NSString *codeString = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"code"]];
        
        if ([codeString isEqualToString:@"1000"]) {
            
            NSDictionary *data = dataDic[@"data"];
            
            NSArray *imageArray = [NSArray arrayWithArray:data[@"obj"]];
            
            return imageArray;
            
        }else{
            
            NSString *errorString = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"msg"]];

            return errorString;
        }
        
       
        
       
    }

    
    return nil;
}


@end
