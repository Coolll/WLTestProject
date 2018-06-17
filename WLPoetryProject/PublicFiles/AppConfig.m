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

- (NSMutableDictionary*)bgImageInfo
{
    if (!_bgImageInfo) {
        _bgImageInfo = [NSMutableDictionary dictionary];
        [_bgImageInfo setObject:@"classOne.jpg" forKey:@"1"];
        [_bgImageInfo setObject:@"classTwo.jpg" forKey:@"2"];
        [_bgImageInfo setObject:@"classThree.jpg" forKey:@"3"];
        [_bgImageInfo setObject:@"classFour.jpg" forKey:@"4"];
        [_bgImageInfo setObject:@"classFive.jpg" forKey:@"5"];
        [_bgImageInfo setObject:@"classSix.jpg" forKey:@"6"];
        [_bgImageInfo setObject:@"classSeven.jpg" forKey:@"7"];
        [_bgImageInfo setObject:@"" forKey:@"8"];
        [_bgImageInfo setObject:@"classNine.jpg" forKey:@"9"];
        [_bgImageInfo setObject:@"classTen.jpg" forKey:@"10"];
        [_bgImageInfo setObject:@"classEleven.jpg" forKey:@"11"];
        [_bgImageInfo setObject:@"classTwelve.jpg" forKey:@"12"];
        [_bgImageInfo setObject:@"" forKey:@"13"];
        [_bgImageInfo setObject:@"classFourteen" forKey:@"14"];
        [_bgImageInfo setObject:@"" forKey:@"15"];
        [_bgImageInfo setObject:@"classSixteen" forKey:@"16"];
        [_bgImageInfo setObject:@"" forKey:@"17"];
        [_bgImageInfo setObject:@"" forKey:@"18"];
        [_bgImageInfo setObject:@"" forKey:@"19"];
        [_bgImageInfo setObject:@"" forKey:@"20"];
        [_bgImageInfo setObject:@"" forKey:@"21"];
        [_bgImageInfo setObject:@"" forKey:@"22"];
        [_bgImageInfo setObject:@"" forKey:@"23"];
        [_bgImageInfo setObject:@"" forKey:@"24"];
        [_bgImageInfo setObject:@"" forKey:@"25"];
        [_bgImageInfo setObject:@"" forKey:@"26"];
        [_bgImageInfo setObject:@"" forKey:@"27"];
        [_bgImageInfo setObject:@"" forKey:@"28"];
        [_bgImageInfo setObject:@"" forKey:@"29"];
        [_bgImageInfo setObject:@"" forKey:@"30"];
        [_bgImageInfo setObject:@"classThirtyOne.jpg" forKey:@"31"];
        [_bgImageInfo setObject:@"classThirtyTwo.jpg" forKey:@"32"];
        [_bgImageInfo setObject:@"" forKey:@"33"];
        [_bgImageInfo setObject:@"" forKey:@"34"];
        [_bgImageInfo setObject:@"" forKey:@"35"];
        [_bgImageInfo setObject:@"" forKey:@"36"];
        [_bgImageInfo setObject:@"classThirtySeven.jpg" forKey:@"37"];
        [_bgImageInfo setObject:@"" forKey:@"38"];
        [_bgImageInfo setObject:@"" forKey:@"39"];
        [_bgImageInfo setObject:@"" forKey:@"40"];
        [_bgImageInfo setObject:@"" forKey:@"41"];
        [_bgImageInfo setObject:@"" forKey:@"42"];
        [_bgImageInfo setObject:@"" forKey:@"43"];
        [_bgImageInfo setObject:@"" forKey:@"44"];
        [_bgImageInfo setObject:@"" forKey:@"45"];
        [_bgImageInfo setObject:@"" forKey:@"46"];
        [_bgImageInfo setObject:@"" forKey:@"47"];
        [_bgImageInfo setObject:@"" forKey:@"48"];
        [_bgImageInfo setObject:@"" forKey:@"49"];
        [_bgImageInfo setObject:@"" forKey:@"50"];
        [_bgImageInfo setObject:@"" forKey:@"51"];
        [_bgImageInfo setObject:@"" forKey:@"52"];
        [_bgImageInfo setObject:@"" forKey:@"53"];
        [_bgImageInfo setObject:@"" forKey:@"54"];
        [_bgImageInfo setObject:@"" forKey:@"55"];
        [_bgImageInfo setObject:@"" forKey:@"56"];
        [_bgImageInfo setObject:@"" forKey:@"57"];
        [_bgImageInfo setObject:@"" forKey:@"58"];
        [_bgImageInfo setObject:@"" forKey:@"59"];
        [_bgImageInfo setObject:@"" forKey:@"60"];
        [_bgImageInfo setObject:@"" forKey:@"61"];
        [_bgImageInfo setObject:@"" forKey:@"62"];
        [_bgImageInfo setObject:@"" forKey:@"63"];
        [_bgImageInfo setObject:@"" forKey:@"64"];
        [_bgImageInfo setObject:@"" forKey:@"65"];
        [_bgImageInfo setObject:@"" forKey:@"66"];
        [_bgImageInfo setObject:@"" forKey:@"67"];
        [_bgImageInfo setObject:@"" forKey:@"68"];
        [_bgImageInfo setObject:@"" forKey:@"69"];
        [_bgImageInfo setObject:@"" forKey:@"70"];
        [_bgImageInfo setObject:@"" forKey:@"71"];
        [_bgImageInfo setObject:@"" forKey:@"72"];
        [_bgImageInfo setObject:@"" forKey:@"73"];
        [_bgImageInfo setObject:@"" forKey:@"74"];
        [_bgImageInfo setObject:@"" forKey:@"75"];
        [_bgImageInfo setObject:@"" forKey:@"76"];
        [_bgImageInfo setObject:@"" forKey:@"77"];
        [_bgImageInfo setObject:@"" forKey:@"78"];
        [_bgImageInfo setObject:@"" forKey:@"79"];
        [_bgImageInfo setObject:@"" forKey:@"80"];
        [_bgImageInfo setObject:@"" forKey:@"81"];
        [_bgImageInfo setObject:@"" forKey:@"82"];
        [_bgImageInfo setObject:@"" forKey:@"83"];
        [_bgImageInfo setObject:@"" forKey:@"84"];
        [_bgImageInfo setObject:@"" forKey:@"85"];
        [_bgImageInfo setObject:@"" forKey:@"86"];
        [_bgImageInfo setObject:@"" forKey:@"87"];
        [_bgImageInfo setObject:@"" forKey:@"88"];
        [_bgImageInfo setObject:@"" forKey:@"89"];
        [_bgImageInfo setObject:@"" forKey:@"90"];
        [_bgImageInfo setObject:@"" forKey:@"91"];
        [_bgImageInfo setObject:@"" forKey:@"92"];
        [_bgImageInfo setObject:@"" forKey:@"93"];
        [_bgImageInfo setObject:@"" forKey:@"94"];
        [_bgImageInfo setObject:@"" forKey:@"95"];
        [_bgImageInfo setObject:@"" forKey:@"96"];
        [_bgImageInfo setObject:@"" forKey:@"97"];
        [_bgImageInfo setObject:@"" forKey:@"98"];
        [_bgImageInfo setObject:@"" forKey:@"99"];
        [_bgImageInfo setObject:@"" forKey:@"100"];
        [_bgImageInfo setObject:@"" forKey:@"101"];
        [_bgImageInfo setObject:@"" forKey:@"102"];
        [_bgImageInfo setObject:@"" forKey:@"103"];
        [_bgImageInfo setObject:@"" forKey:@"104"];
        [_bgImageInfo setObject:@"" forKey:@"105"];
        [_bgImageInfo setObject:@"" forKey:@"106"];
        [_bgImageInfo setObject:@"" forKey:@"107"];
        [_bgImageInfo setObject:@"" forKey:@"108"];
        [_bgImageInfo setObject:@"" forKey:@"109"];
        [_bgImageInfo setObject:@"classOHTen.jpg" forKey:@"110"];
 }
    return _bgImageInfo;
}
@end
