//
//  PoetryModel.m
//  WLPoetryProject
//
//  Created by 龙培 on 2018/4/17.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "PoetryModel.h"

@implementation PoetryModel

- (void)loadFirstLineString
{
    if ([self.content isKindOfClass:[NSString class]] && self.content.length > 0) {
        
        BOOL isContainEnd = [self.content containsString:@"。"];
        BOOL isContainExclamation = [self.content containsString:@"！"];
        BOOL isContainQuery = [self.content containsString:@"？"];
        if (isContainEnd) {
            
            self.firstLineString = [NSString stringWithFormat:@"%@。",[[self.content componentsSeparatedByString:@"。"]firstObject]];
            
        }else if (isContainQuery){
            self.firstLineString = [NSString stringWithFormat:@"%@？",[[self.content componentsSeparatedByString:@"？"]firstObject]];
        }else if (isContainExclamation){
            self.firstLineString = [NSString stringWithFormat:@"%@！",[[self.content componentsSeparatedByString:@"！"]firstObject]];
        } else{
            self.firstLineString = @"";
        }
    }
}

- (instancetype)initPoetryWithDictionary:(NSDictionary*)dic
{

    self = [super init];
    if (self) {
        self.poetryID = [self notNillValueWithKey:@"poetry_id" withDic:dic];
        self.name = [self notNillValueWithKey:@"name" withDic:dic];
        self.author = [self notNillValueWithKey:@"author" withDic:dic];
        self.content = [self notNillValueWithKey:@"content" withDic:dic];
        self.addtionInfo = [self notNillValueWithKey:@"addtion_info" withDic:dic];
        self.classInfo = [self notNillValueWithKey:@"class_info" withDic:dic];
        self.classInfoExplain = [self notNillValueWithKey:@"class_info_explain" withDic:dic];
        self.mainClass = [self notNillValueWithKey:@"main_class" withDic:dic];
        self.mainClassExplain = [self notNillValueWithKey:@"main_class_explain" withDic:dic];
        self.source = [self notNillValueWithKey:@"source" withDic:dic];
        self.sourceExplain = [self notNillValueWithKey:@"source_explain" withDic:dic];
        self.transferInfo = [self notNillValueWithKey:@"transfer_info" withDic:dic];
        self.likes = [self intValueWithKey:@"likes" withDic:dic];
        self.textColor = [self intValueWithKey:@"text_color" withDic:dic];
        self.backImageURL = [self notNillValueWithKey:@"image_url" withDic:dic];
        [self loadFirstLineString];

    }
    return self;
    
    
}

- (NSString*)notNillValueWithKey:(NSString*)key withDic:(NSDictionary*)dic
{
    id object = [dic objectForKey:key];
    
    if (object) {
        
        NSString *string = [NSString stringWithFormat:@"%@",object];
        return string;
    }
    
    return @"";
    
}

- (NSInteger)intValueWithKey:(NSString*)key withDic:(NSDictionary*)dic
{
    id object = [dic objectForKey:key];
    
    if (object) {
        
        NSString *string = [NSString stringWithFormat:@"%@",object];
        NSInteger final = 0;
        if (string.length > 0 && ![string isEqualToString:@"<null>"]) {
            final = [string integerValue];
        }
        return final;
    }
    
    return 0;
    
}


@end
