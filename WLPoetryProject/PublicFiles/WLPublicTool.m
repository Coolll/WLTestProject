//
//  WLPublicTool.m
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/15.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import "WLPublicTool.h"

@implementation WLPublicTool

+ (WLPublicTool *)shareTool{
    static WLPublicTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[WLPublicTool alloc] init];
    });
    return tool;
}

#pragma mark - 画圆角
- (void)addCornerForView:(UIView*)view withCornerRadius:(CGFloat)cornerR
{
    [self addCornerForView:view withTopLeft:YES withTopRight:YES withBottomLeft:YES withBottomRight:YES withCornerRadius:cornerR];
}

- (void)addCornerForView:(UIView*)view withTopLeft:(BOOL)topLeft withTopRight:(BOOL)topRight withBottomLeft:(BOOL)bottomLeft withBottomRight:(BOOL)bottomRight withCornerRadius:(CGFloat)cornerR
{
    CGFloat viewWidth = view.frame.size.width;
    CGFloat viewHeight = view.frame.size.height;
    
    UIBezierPath *path = [[UIBezierPath alloc]init];
    [path moveToPoint:CGPointMake(0, viewHeight-cornerR)];
    if (topLeft) {
        [path addLineToPoint:CGPointMake(0, cornerR)];
        [path addQuadCurveToPoint:CGPointMake(cornerR, 0) controlPoint:CGPointMake(0, 0)];
    }else{
        [path addLineToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(cornerR, 0)];
    }
    
    [path addLineToPoint:CGPointMake(viewWidth-cornerR, 0)];
    
    if (topRight) {
        [path addQuadCurveToPoint:CGPointMake(viewWidth, cornerR) controlPoint:CGPointMake(viewWidth, 0)];
    }else{
        [path addLineToPoint:CGPointMake(viewWidth, 0)];
        [path addLineToPoint:CGPointMake(viewWidth, cornerR)];
    }
    
    
    [path addLineToPoint:CGPointMake(viewWidth, viewHeight-cornerR)];
    
    if (bottomRight) {
        [path addQuadCurveToPoint:CGPointMake(viewWidth-cornerR, viewHeight) controlPoint:CGPointMake(viewWidth, viewHeight)];
    }else{
        [path addLineToPoint:CGPointMake(viewWidth, viewHeight)];
        [path addLineToPoint:CGPointMake(viewWidth-cornerR, viewHeight)];
    }
    
    [path addLineToPoint:CGPointMake(cornerR, viewHeight)];
    
    if (bottomLeft) {
        [path addQuadCurveToPoint:CGPointMake(0, viewHeight-cornerR) controlPoint:CGPointMake(0, viewHeight)];
    }else{
        [path addLineToPoint:CGPointMake(0, viewHeight)];
        [path addLineToPoint:CGPointMake(0, viewHeight-cornerR)];
    }
    
    
    
    //构建图形
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    //这里的frame要注意
    maskLayer.frame = view.bounds;
    maskLayer.fillColor = [UIColor whiteColor].CGColor;
    view.layer.mask = maskLayer;
    
}

#pragma mark - 计算label的高度方法
+ (CGFloat)heightForTextString:(NSString*)vauleString width:(CGFloat)textWidth fontSize:(CGFloat)textSize
{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:textSize]};
    CGRect rect = [vauleString boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingTruncatesLastVisibleLine attributes:dict context:nil];
    return rect.size.height ;
}

+ (CGFloat) widthForTextString:(NSString *)tStr height:(CGFloat)tHeight fontSize:(CGFloat)tSize{
    
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:tSize]};
    CGRect rect = [tStr boundingRectWithSize:CGSizeMake(MAXFLOAT, tHeight) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.width+5;
    
}

#pragma mark - 文本分割

- (NSArray*)poetrySeperateWithOrigin:(NSString*)originString
{
    if (!originString || originString.length==0) {
        originString = @"";
    }
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
        
    }else{
        
       
        NSArray *arr = [originString componentsSeparatedByString:@"，"];
        for (NSString *content in arr) {
            //如果是诗句末尾的句号，则会拆分多出来一个空的字符，判断处理一下
            if (content.length > 0) {
                
                NSString *fullString = content;
                                
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
                
                NSString *needAdd = @"";
                for (NSString *subString in semicolonArr) {
                    needAdd = subString;
                    //取最后一个字符
                    NSString *contentLastChar = [needAdd substringFromIndex:needAdd.length-1];
                    if ([contentLastChar isEqualToString:@"？"] || [contentLastChar isEqualToString:@"！"] || [contentLastChar isEqualToString:@"："] || [contentLastChar isEqualToString:@"；"]) {
                        //如果是问号或者感叹号结尾，则不处理
                        needAdd = subString;
                    }else{
                        //把逗号补上
                        needAdd = [NSString stringWithFormat:@"%@，",subString];
                    }

                    [dataArray addObject:needAdd];
                }
                
                
                //非空诗句添加到数组中
            }
            
            //循环处理了全部诗词
        }

//        [dataArray addObject:originString];
    }
    
    
    if (!isContainEnd && !isContainColon && !isContainQuestion && !isContainSemicolon && !isContainExclamation) {
        [dataArray addObject:originString];
    }
    
    
    return dataArray;
    
}



- (NSArray*)dealPartWithOrigin:(NSString*)contentString
{
    NSMutableArray *arr = [NSMutableArray array];
    if (kStringIsEmpty(contentString)) {
        return arr;
    }
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

//计算label的高度方法（带有行间距）
+ (CGFloat)heightSpaceForTextString:(NSString*)vauleString width:(CGFloat)textWidth fontSize:(CGFloat)textSize space:(CGFloat)spaceLine
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:vauleString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:spaceLine];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [vauleString length])];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:textSize]
                             range:NSMakeRange(0, [vauleString length])];
    
    CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingTruncatesLastVisibleLine context:nil];
    
    return rect.size.height ;
}

#pragma mark - 计算label的宽度
+ (CGFloat) widthForTextString:(NSString *)tStr height:(CGFloat)tHeight font:(UIFont*)textFont{
    
    NSDictionary *dict = @{NSFontAttributeName:textFont};
    CGRect rect = [tStr boundingRectWithSize:CGSizeMake(MAXFLOAT, tHeight) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.width+5;
    
}
#pragma mark - 保存图片到沙盒
- (void)saveImageToLocalWithImage:(UIImage*)image
{
    //时间戳作为图片的名称
    NSDate *date = [NSDate date];
    NSString *dateString = [NSString stringWithFormat:@"%.0f",[date timeIntervalSince1970]];
    [WLSaveLocalHelper saveCustomImageWithName:dateString];//把时间戳用作图片名，并把图片名保存起来，后面会查询使用
    NSString *homePath = NSHomeDirectory();
    //设置一个图片的存储路径
    NSString *imageFoldPath = [homePath stringByAppendingString:@"/Documents/CustomImage"];
    
    NSString *imagePath = [imageFoldPath stringByAppendingString:[NSString stringWithFormat:@"/%@.png",dateString]];
    
    NSLog(@"path:%@",imagePath);

    NSFileManager *fileManager = [NSFileManager defaultManager];

    if (![fileManager fileExistsAtPath:imageFoldPath]) {
        //如果没有文件夹，则创建
        [self createDirectoryWithBlock:^(BOOL success) {
            if (success) {
                //成功创建文件夹后，保存图片
                //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];

                });
            }
        }];
        
    }else{
        //有文件夹，直接保存
        //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
        [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
    }
    
    
}

//创建文件夹
- (void)createDirectoryWithBlock:(void(^)(BOOL success))block
{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *string = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSString *imageDirectory = [documentsPath stringByAppendingPathComponent:@"CustomImage"];
    NSLog(@"题画本地路径:%@",string);

    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL res = [fileManager createDirectoryAtPath:imageDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    
    if (res) {
        NSLog(@"创建文件夹成功");
        
    }else{
        NSLog(@"创建文件夹失败");
    }
    if (block) {
        block(res);
    }
}

-(UIImage *)loadDocumentImageWithName:(NSString*)imageName
{   //读取沙盒路径图片
    NSString *imagePath=[NSString stringWithFormat:@"%@/Documents/CustomImage/%@.png",NSHomeDirectory(),imageName];
    
    //拿到沙盒路径图片
    UIImage *img=[[UIImage alloc]initWithContentsOfFile:imagePath];
    if (img) {
        return img;
    }
    NSLog(@"获取沙盒图片失败");
    return nil;
}

- (void)deleteImageWithName:(NSString*)imageName
{
    //读取沙盒路径图片
    NSString *imagePath=[NSString stringWithFormat:@"%@/Documents/CustomImage/%@.png",NSHomeDirectory(),imageName];
    BOOL res = [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
    
    if (res) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
    
    BOOL isExist = [[NSFileManager defaultManager]isExecutableFileAtPath:imagePath];
    if (isExist) {
        NSLog(@"文件存在");
    }else{
        NSLog(@"文件不存在");
    }
}

@end
