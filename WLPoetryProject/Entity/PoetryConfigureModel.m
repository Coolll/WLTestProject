//
//  PoetryConfigureModel.m
//  WLPoetryProject
//
//  Created by 变啦 on 2019/11/15.
//  Copyright © 2019 龙培. All rights reserved.
//

#import "PoetryConfigureModel.h"

@implementation PoetryConfigureModel
- (instancetype)initModelWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        self.mainClass  = [self notNillValueWithKey:@"main_class" withDic:dic];
        self.mainTitle = [self notNillValueWithKey:@"main_title" withDic:dic];
        self.subTitle  = [self notNillValueWithKey:@"sub_title" withDic:dic];
        self.configureTag = [self intValueWithKey:@"configure_tag" withDic:dic];
        self.tableSection = [self intValueWithKey:@"table_section" withDic:dic];
        self.tableIndex = [self intValueWithKey:@"table_index" withDic:dic];
        self.sectionTitle  = [self notNillValueWithKey:@"section_title" withDic:dic];

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
