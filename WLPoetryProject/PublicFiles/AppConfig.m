//
//  AppConfig.m
//  WLPoetryProject
//
//  Created by 龙培 on 2018/5/6.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "AppConfig.h"

@implementation AppConfig
+ (AppConfig *)config
{
    static AppConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[AppConfig alloc] init];
    });
    return config;
}

- (UIFont*)titleFont
{
    
    NSDictionary *configure = kUserConfigure;
    NSInteger fontSize = 19;
    if ([configure objectForKey:@"poetryTitleFont"]) {
        NSString *fontString = [configure objectForKey:@"poetryTitleFont"];
        fontSize = [fontString integerValue];
    }
    
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    return font;
}

- (UIFont*)authorFont
{
    NSDictionary *configure = kUserConfigure;
    NSInteger fontSize = 16;
    if ([configure objectForKey:@"poetryAuthorFont"]) {
        NSString *fontString = [configure objectForKey:@"poetryAuthorFont"];
        fontSize = [fontString integerValue];
    }

    UIFont *font = [UIFont systemFontOfSize:fontSize];
    return font;
}

- (UIFont*)contentFont
{
    NSDictionary *configure = kUserConfigure;
    NSInteger fontSize = 16;
    if ([configure objectForKey:@"poetryContentFont"]) {
        NSString *fontString = [configure objectForKey:@"poetryContentFont"];
        fontSize = [fontString integerValue];
    }

    UIFont *font = [UIFont systemFontOfSize:fontSize];
    return font;
}

- (UIFont*)itemFont
{
    UIFont *font = [UIFont systemFontOfSize:14];
    return font;
}

- (void)loadAllClassImageInfo
{
    
    [self loadClassImageWithBlock:nil];
}

- (void)loadClassImageWithBlock:(void(^)(NSDictionary*dic))block
{
    BmobQuery *query = [BmobQuery queryWithClassName:@"ImageList"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (array.count > 0) {
            
            //如果请求到数据 则移除全部的key
            [self.bgImageInfo removeAllObjects];
            for (int i = 0;i<array.count;i++) {
                BmobObject *obc = array[i];

                //图片url作为value，class类别作为key，存储起来
                NSString *url = [NSString stringWithFormat:@"%@",[obc objectForKey:@"imageURL"]];
                NSString *className = [NSString stringWithFormat:@"%@",[obc objectForKey:@"className"]];
                [self.bgImageInfo setObject:url forKey:className];
                NSLog(@"index为:%d className为：%@ 个数：%d",i,className,self.bgImageInfo.allKeys.count);

            }
            
            if (block) {
                block(self.bgImageInfo);
            }
        }
    }];
}

- (NSMutableDictionary*)bgImageInfo
{
    if (!_bgImageInfo) {
        _bgImageInfo = [NSMutableDictionary dictionary];
    }
    return _bgImageInfo;
}

- (NSArray*)allPoetryList
{
    if (!_allPoetryList) {
        NSMutableArray *poetryListArray = [NSMutableArray array];
        
        NSArray *configureArray = [self readConfigureWithFileName:@"allPoetryListConfigure"];
        if (configureArray.count > 0) {
            for (int i =0 ; i < configureArray.count; i++) {
                NSString *fileName = [NSString stringWithFormat:@"%@",configureArray[i]];
                NSArray *listArray = [self readConfigureWithFileName:fileName];
                
                for (NSDictionary *dic in listArray) {
                    NSString *jsonName = [dic objectForKey:@"jsonName"];
                    [poetryListArray addObject:jsonName];
                }
                
            }
        }
        
        [poetryListArray addObject:@"recommendPoetry"];
        _allPoetryList = [poetryListArray copy];
    }
    return _allPoetryList;
}
- (NSArray*)readConfigureWithFileName:(NSString*)fileName
{
    //从本地读取文件
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"json"]];
    //转为dic
    NSDictionary *configureData = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    
    //获取到年级的配置列表
    NSArray *array = [configureData objectForKey:@"dataList"];
    return array;
}



@end
