//
//  AppConfig.m
//  WLPoetryProject
//
//  Created by 龙培 on 2018/5/6.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "AppConfig.h"
#import "NetworkHelper.h"

@interface AppConfig()
/**
 *  背景图的回调
 **/
@property (nonatomic,copy) BgImageBlock bgImageBlock;

/**
 *  头像的回调
 **/
@property (nonatomic,copy) HeadImageRequestBlock headImageBlock;


@end

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
    
    [self loadAllBgImageWithBlock:nil];
}

//网络请求全部的题画背景图片
- (void)loadAllBgImageWithBlock:(BgImageBlock)block
{
    if (block) {
        self.bgImageBlock = block;
    }
    
    __weak __typeof(self)weakSelf = self;
    
    [[NetworkHelper shareHelper] requestAllBgImagesWithCompletion:^(BOOL success, NSDictionary *dic, NSError *error) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;

        if (success) {
            NSString *code = [NSString stringWithFormat:@"%@",[dic objectForKey:@"retCode"]];
            if (![code isEqualToString:@"1000"]) {
                NSString *tipMessage = [dic objectForKey:@"message"];
                if (strongSelf.bgImageBlock) {
                    strongSelf.bgImageBlock(nil,nil,[NSError errorWithDomain:NSURLErrorDomain code:[code integerValue] userInfo:@{NSLocalizedDescriptionKey:tipMessage}]);
                }
                return ;
            }
            
            NSArray *array = [dic objectForKey:@"data"];
            if (array.count > 0) {
                
                //如果请求到数据 则移除全部的key
                [strongSelf.bgImageInfo removeAllObjects];
                for (int i = 0 ; i<array.count ; i++) {
                    NSDictionary *imgDic = array[i];
                    
                    //图片url作为value，class类别作为key，存储起来
                    NSString *baseUrl = [NSString stringWithFormat:@"%@",[imgDic objectForKey:@"image_base_url"]];
                    NSString *imagePath = [NSString stringWithFormat:@"%@",[imgDic objectForKey:@"thumb_url"]];
                    NSString *originPath = [NSString stringWithFormat:@"%@",[imgDic objectForKey:@"origin_url"]];

                    NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,imagePath];
                    NSString *originUrl = [NSString stringWithFormat:@"%@%@",baseUrl,originPath];

                    NSString *className = [NSString stringWithFormat:@"%@",[imgDic objectForKey:@"class_info"]];
                    [strongSelf.bgImageInfo setObject:url forKey:className];
                    [strongSelf.bgOriginImageInfo setObject:originUrl forKey:className];

                }
                
                if (strongSelf.bgImageBlock) {
                    strongSelf.bgImageBlock(strongSelf.bgImageInfo,strongSelf.bgOriginImageInfo,nil);
                }
            }
            
        }else{
            
            if (strongSelf.bgImageBlock) {
                strongSelf.bgImageBlock(nil,nil,[NSError errorWithDomain:NSURLErrorDomain code:500 userInfo:@{NSLocalizedDescriptionKey:@"请求失败，请重试"}]);
            }
            
        }
        
    }];
    
}

//网络请求全部的头像
- (void)loadAllHeadImageWithBlock:(HeadImageRequestBlock)block
{
    if (block) {
        self.headImageBlock = block;
    }
    
    __weak __typeof(self)weakSelf = self;
    [[NetworkHelper shareHelper] requestAllHeadImagesWithCompletion:^(BOOL success, NSDictionary *dic, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if (success) {
            NSString *code = [NSString stringWithFormat:@"%@",[dic objectForKey:@"retCode"]];
            if (![code isEqualToString:@"1000"]) {
                NSString *tipMessage = [dic objectForKey:@"message"];
                if (strongSelf.headImageBlock) {
                    strongSelf.headImageBlock(nil,nil,[NSError errorWithDomain:NSURLErrorDomain code:[code integerValue] userInfo:@{NSLocalizedDescriptionKey:tipMessage}]);
                }
                return ;
            }
            
            
            NSArray *array = [dic objectForKey:@"data"];
            if (array.count > 0) {
                //如果请求到数据 则移除全部的key
                NSMutableArray *originArr = [NSMutableArray array];
                NSMutableArray *thumbArr = [NSMutableArray array];
                
                for (int i = 0 ; i<array.count ; i++) {
                    NSDictionary *imgDic = array[i];
                    
                    //图片url作为value，class类别作为key，存储起来
                    NSString *baseUrl = [NSString stringWithFormat:@"%@",[imgDic objectForKey:@"head_image_base_url"]];
                    NSString *thumbPath = [NSString stringWithFormat:@"%@",[imgDic objectForKey:@"thumb_url"]];
                    NSString *originPath = [NSString stringWithFormat:@"%@",[imgDic objectForKey:@"origin_url"]];
                    
                    NSString *thumbUrl = [NSString stringWithFormat:@"%@%@",baseUrl,thumbPath];
                    NSString *originUrl = [NSString stringWithFormat:@"%@%@",baseUrl,originPath];
                    
                    [originArr addObject:originUrl];
                    [thumbArr addObject:thumbUrl];
                    
                    
                    
                }
                
                if (strongSelf.headImageBlock) {
                    strongSelf.headImageBlock(originArr,thumbArr,nil);
                }
            }
            
        }else{
            
            if (strongSelf.headImageBlock) {
                strongSelf.headImageBlock(nil,nil,[NSError errorWithDomain:NSURLErrorDomain code:500 userInfo:@{NSLocalizedDescriptionKey:@"请求失败，请重试"}]);
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
- (NSMutableDictionary*)bgOriginImageInfo
{
    if (!_bgOriginImageInfo) {
        _bgOriginImageInfo = [NSMutableDictionary dictionary];
    }
    return _bgOriginImageInfo;
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
        [poetryListArray addObject:@"recommendPoetryTwo"];

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
