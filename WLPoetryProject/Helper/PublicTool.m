//
//  PublicTool.m
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/6/29.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "PublicTool.h"

@implementation PublicTool

+ (PublicTool *)tool{
    static PublicTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[PublicTool alloc] init];
    });
    return tool;
}


#pragma mark - 文本分割

- (NSArray*)poetrySeperateWithOrigin:(NSString*)originString
{
    NSMutableArray *dataArray = [NSMutableArray array];
    
    
    //是否含有句号
    BOOL isContainEnd = [originString containsString:@"。"];
    //是否含有感叹号
    BOOL isContainExclamation = [originString containsString:@"！"];
    //是否含有问号
    BOOL isContainQuestion = [originString containsString:@"？"];
    //是否含有冒号
    BOOL isContainColon = [originString containsString:@"："];
    //是否含有分号
    BOOL isContainSemicolon = [originString containsString:@"；"];
    
    //有的话，按句号划分
    if (isContainEnd) {
        //拆分成数组
        NSArray *arr = [originString componentsSeparatedByString:@"。"];
        for (NSString *content in arr) {
            //如果是诗句末尾的句号，则会拆分多出来一个空的字符，判断处理一下
            if (content.length > 0) {
                
                NSString *fullString;
                //取最后一个字符
                NSString *contentLastChar = [content substringFromIndex:content.length-1];
                if ([contentLastChar isEqualToString:@"？"] || [contentLastChar isEqualToString:@"！"]) {
                    //如果是问号或者感叹号结尾，则不处理
                    fullString = content;
                }else{
                    //把句号补上
                    fullString = [NSString stringWithFormat:@"%@。",content];
                }
                
                
                NSArray *partArr = [self dealPartWithOrigin:fullString];
                
                //上一步的数据源
                NSMutableArray *exclamationArr = [NSMutableArray arrayWithArray:partArr];
                //如果包含符号
                if (isContainExclamation) {
                    //把数据移除
                    [exclamationArr removeAllObjects];
                    //遍历原数据
                    for (NSString *subString in partArr) {
                        //按符号分割
                        NSArray *exclamationArray = [self dealExclamationWithOrigin:subString];
                        for (NSString *separateString in exclamationArray) {
                            //分割后的添加到目标数组中
                            [exclamationArr addObject:separateString];
                        }
                    }
                }
                
                //上一步的数据源
                NSMutableArray *questionArr = [NSMutableArray arrayWithArray:exclamationArr];
                //如果包含符号
                if (isContainQuestion) {
                    //把数据移除
                    [questionArr removeAllObjects];
                    //遍历原数据
                    for (NSString *subString in exclamationArr) {
                        //按符号分割
                        NSArray *questionArray = [self dealQuestionWithOrigin:subString];
                        for (NSString *separateString in questionArray) {
                            //分割后的添加到目标数组中
                            [questionArr addObject:separateString];
                        }
                    }
                }
                
                //上一步的数据源
                NSMutableArray *colonArr = [NSMutableArray arrayWithArray:questionArr];
                //如果包含符号
                if (isContainColon) {
                    //把数据移除
                    [colonArr removeAllObjects];
                    //遍历原数据
                    for (NSString *subString in questionArr) {
                        //按符号分割
                        NSArray *colonArray = [self dealColonWithOrigin:subString];
                        for (NSString *separateString in colonArray) {
                            //分割后的添加到目标数组中
                            [colonArr addObject:separateString];
                        }
                    }
                }
                
                //上一步的数据源
                NSMutableArray *semicolonArr = [NSMutableArray arrayWithArray:colonArr];
                //如果包含符号
                if (isContainSemicolon) {
                    //把数据移除
                    [semicolonArr removeAllObjects];
                    //遍历原数据
                    for (NSString *subString in colonArr) {
                        //按符号分割
                        NSArray *semicolonArray = [self dealSemicolonWithOrigin:subString];
                        for (NSString *separateString in semicolonArray) {
                            //分割后的添加到目标数组中
                            [semicolonArr addObject:separateString];
                        }
                    }
                }
                
                for (NSString *subString in semicolonArr) {
                    [dataArray addObject:subString];
                }
                
                
                //非空诗句添加到数组中
            }
            
            //循环处理了全部诗词
        }
        
    }
    
    
    if (!isContainEnd && !isContainColon && !isContainQuestion && !isContainSemicolon && !isContainExclamation) {
        [dataArray addObject:originString];
    }
    
    
    return dataArray;
    
}



- (NSArray*)dealPartWithOrigin:(NSString*)contentString
{
    NSMutableArray *arr = [NSMutableArray array];
    
    if (contentString.length < 8) {
        //如果诗句少于8个字，则直接添加该诗句，不处理逗号
        [arr addObject:contentString];
        return arr;
    }else{
        //诗句大于8个字，能否拆出来一部分
        //是否包含逗号
        BOOL isContainPart = [contentString containsString:@"，"];
        
        if (isContainPart) {
            //按照逗号分割一次
            NSArray *partArray = [contentString componentsSeparatedByString:@"，"];
            
            for (int i = 0; i< partArray.count; i++) {
                
                NSString *partStr =  partArray[i];
                //最后一项不需要补充逗号
                if (i == partArray.count -1) {
                    [arr addObject:partStr];
                }else{
                    [arr addObject:[NSString stringWithFormat:@"%@，",partStr]];
                }
            }
            
        }else{
            //如果没有逗号，则直接添加该诗句
            [arr addObject:contentString];
        }
        
        
    }
    return arr;
}
- (NSArray*)dealExclamationWithOrigin:(NSString*)contentString
{
    NSMutableArray *arr = [NSMutableArray array];
    
    //当前句子是否包含感叹号
    BOOL isContainExclamation = [contentString containsString:@"！"];
    
    
    if (isContainExclamation) {
        //按照感叹号 分割一次
        NSArray *partArray = [contentString componentsSeparatedByString:@"！"];
        
        for (int i = 0; i< partArray.count; i++) {
            
            NSString *partStr =  partArray[i];
            //拆分后不是空的字符串
            if (partStr.length > 0) {
                
                //最后一项不需要补充感叹号
                if (i == partArray.count -1) {
                    [arr addObject:partStr];
                }else{
                    [arr addObject:[NSString stringWithFormat:@"%@！",partStr]];
                }
            }
            
        }
        
    }else{
        //如果没有感叹号，则直接添加该诗句
        [arr addObject:contentString];
    }
    
    return arr;
}
- (NSArray*)dealQuestionWithOrigin:(NSString*)contentString
{
    NSMutableArray *arr = [NSMutableArray array];
    
    //当前句子是否包含问号
    BOOL isContainExclamation = [contentString containsString:@"？"];
    
    
    if (isContainExclamation) {
        //按照问号 分割一次
        NSArray *partArray = [contentString componentsSeparatedByString:@"？"];
        
        for (int i = 0; i< partArray.count; i++) {
            
            NSString *partStr =  partArray[i];
            //如果不是空的字符串
            if (partStr.length > 0) {
                //最后一项不需要补充问号
                if (i == partArray.count -1) {
                    [arr addObject:partStr];
                }else{
                    [arr addObject:[NSString stringWithFormat:@"%@？",partStr]];
                }
            }
            
        }
        
    }else{
        //如果没有问号，则直接添加该诗句
        [arr addObject:contentString];
    }
    
    return arr;
}
- (NSArray*)dealColonWithOrigin:(NSString*)contentString
{
    NSMutableArray *arr = [NSMutableArray array];
    
    //当前句子是否包含冒号号
    BOOL isContainExclamation = [contentString containsString:@"："];
    
    
    if (isContainExclamation) {
        //按照冒号 分割一次
        NSArray *partArray = [contentString componentsSeparatedByString:@"："];
        
        for (int i = 0; i< partArray.count; i++) {
            
            NSString *partStr =  partArray[i];
            //拆分后不是空的字符串
            if (partStr.length > 0) {
                
                //最后一项不需要补充冒号
                if (i == partArray.count -1) {
                    [arr addObject:partStr];
                }else{
                    [arr addObject:[NSString stringWithFormat:@"%@：",partStr]];
                }
            }
            
        }
        
    }else{
        //如果没有冒号，则直接添加该诗句
        [arr addObject:contentString];
    }
    
    return arr;
}

- (NSArray*)dealSemicolonWithOrigin:(NSString*)contentString
{
    NSMutableArray *arr = [NSMutableArray array];
    
    //当前句子是否包含分号
    BOOL isContainExclamation = [contentString containsString:@"；"];
    
    
    if (isContainExclamation) {
        //按照分号 分割一次
        NSArray *partArray = [contentString componentsSeparatedByString:@"；"];
        
        for (int i = 0; i< partArray.count; i++) {
            
            NSString *partStr =  partArray[i];
            //拆分后不是空的字符串
            if (partStr.length > 0) {
                
                //最后一项不需要补充分号
                if (i == partArray.count -1) {
                    [arr addObject:partStr];
                }else{
                    [arr addObject:[NSString stringWithFormat:@"%@；",partStr]];
                }
            }
            
        }
        
    }else{
        //如果没有分号，则直接添加该诗句
        [arr addObject:contentString];
    }
    
    return arr;
}

#pragma mark - 计算label高度
+ (CGFloat)heightForTextString:(NSString*)vauleString width:(CGFloat)textWidth font:(UIFont*)textFont
{
    NSDictionary *dict = @{NSFontAttributeName:textFont};
    CGRect rect = [vauleString boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingTruncatesLastVisibleLine attributes:dict context:nil];
    return rect.size.height+1;
}

+ (CGFloat) widthForTextString:(NSString *)tStr height:(CGFloat)tHeight font:(UIFont*)textFont{
    
    NSDictionary *dict = @{NSFontAttributeName:textFont};
    CGRect rect = [tStr boundingRectWithSize:CGSizeMake(MAXFLOAT, tHeight) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.width+5;
    
}
@end
