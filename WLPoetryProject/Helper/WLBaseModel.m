//
//  WLBaseModel.m
//  TestFastModel
//
//  Created by WQL on 16/6/30.
//  Copyright © 2016年 WQL. All rights reserved.
//

#import "WLBaseModel.h"

@implementation WLBaseModel


- (instancetype)initModelWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    
    if (self) {
        
        if ([dic isKindOfClass:[NSDictionary class]]) {
          
            [self setValuesForKeysWithDictionary:dic];

        }
        
    }
    
    [self loadFirstLineString];

    return self;
}

- (void)loadFirstLineString
{
    
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    //防止value是空
    if ([value isKindOfClass:[NSNull class]] || value == nil ) {
        
        value = @"";
    }
    
    //防止value是@"<null>"
    if ([value isKindOfClass:[NSString class]]) {
        
        if ([value isEqualToString:@"<null>"]) {
            value = @"";
            
        }
    }
    
    //将值转为string再存储
    value = [NSString stringWithFormat:@"%@",value];
    
    [super setValue:value forKey:key];
    

}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}


@end
