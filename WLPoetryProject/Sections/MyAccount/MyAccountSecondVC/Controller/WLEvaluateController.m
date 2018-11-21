//
//  WLEvaluateController.m
//  WLPoetryProject
//
//  Created by 变啦 on 2018/11/16.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLEvaluateController.h"
#import "WQLProgressView.h"
#import "PoetryModel.h"
#import "WLCoreDataHelper.h"
#import "WLPublicTool.h"
typedef NS_ENUM(NSInteger , PoetryClass) {
    PoetryClassEasy,
    PoetryClassGeneral,
    PoetryClassDifficult
};

@interface WLEvaluateController ()
/**
 *  ID与count数据
 **/
@property (nonatomic,copy) NSDictionary *IDInfo;
/**
 *  简单诗词ID数组
 **/
@property (nonatomic,strong) NSMutableArray *easyArray;
/**
 *  一般诗词ID数组
 **/
@property (nonatomic,strong) NSMutableArray *generalArray;
/**
 *  困难诗词ID数组
 **/
@property (nonatomic,strong) NSMutableArray *difficultArray;

/**
 *  简单诗词题目数组
 **/
@property (nonatomic,strong) NSMutableArray *easyModelArray;
/**
 *  一般诗词题目数组
 **/
@property (nonatomic,strong) NSMutableArray *generalModelArray;
/**
 *  困难诗词题目数组
 **/
@property (nonatomic,strong) NSMutableArray *difficultModelArray;
/**
 *  用来暂存数据的数组
 **/
@property (nonatomic,strong) NSMutableArray *tmpArray;

/**
 *  选项 数组,是二维数组，每个元素为数组，数组内容为对应index的可选项
 **/
@property (nonatomic,strong) NSMutableArray *optionEasyArray;

@property (nonatomic,strong) NSMutableArray *optionGeneralArray;
@property (nonatomic,strong) NSMutableArray *optionDifficultArray;

//各个长度的诗词 不同长度的诗词 3,4,5,7其他
@property (nonatomic,strong) NSMutableArray *threeCharArray;
@property (nonatomic,strong) NSMutableArray *fourCharArray;
@property (nonatomic,strong) NSMutableArray *fiveCharArray;
@property (nonatomic,strong) NSMutableArray *sevenCharArray;
@property (nonatomic,strong) NSMutableArray *otherCharArray;


/**
 *  主scrollView
 **/
@property (nonatomic,strong) UIScrollView *mainScrollView;
/**
 *  倒计时的视图
 **/
@property (nonatomic,strong) WQLProgressView *progressView;

/**
 *  定时器
 **/
@property (nonatomic,strong) NSTimer *timer;

/**
 *  题目的label
 **/
@property (nonatomic,strong) UILabel *questionLabel;

/**
 *  当前第几题
 **/
@property (nonatomic,assign) NSInteger indexForQuestion;

/**
 *  第一选项
 **/
@property (nonatomic,strong) UILabel *oneLabel;
/**
 *  第二选项
 **/
@property (nonatomic,strong) UILabel *twoLabel;

/**
 *  第三选项
 **/
@property (nonatomic,strong) UILabel *threeLabel;

/**
 *  无正确选项
 **/
@property (nonatomic,strong) UILabel *noRightLabel;

/**
 *  不认识选项
 **/
@property (nonatomic,strong) UILabel *unknownLabel;






@end

@implementation WLEvaluateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleForNavi = @"诗词测评";
    self.view.backgroundColor = ViewBackgroundColor;
    [self loadCustomData];
}
#pragma mark - 数据处理

- (void)loadCustomData
{
    //原始的ID数组
    self.easyArray = [NSMutableArray array];
    self.generalArray = [NSMutableArray array];
    self.difficultArray = [NSMutableArray array];
    
    //获取到的展示数组 “____，低头思故乡。”
    self.easyModelArray = [NSMutableArray array];
    self.generalModelArray = [NSMutableArray array];
    self.difficultModelArray = [NSMutableArray array];
    
    //展示数组的答案 “举头望明月”
    self.tmpArray = [NSMutableArray array];
    self.optionEasyArray = [NSMutableArray array];
    self.optionGeneralArray = [NSMutableArray array];
    self.optionDifficultArray = [NSMutableArray array];

    //不同长度的诗词 3,4,5,7其他
    self.threeCharArray = [NSMutableArray array];
    self.fourCharArray = [NSMutableArray array];
    self.fiveCharArray = [NSMutableArray array];
    self.sevenCharArray = [NSMutableArray array];
    self.otherCharArray = [NSMutableArray array];
    
    //从0开始
    self.indexForQuestion = 0;
    
    self.IDInfo = @{@"1000":@"8",
                    @"2000":@"9",
                    @"3000":@"10",
                    @"4000":@"11",
                    @"5000":@"8",
                    @"6000":@"15",
                    @"7000":@"13",
                    @"7500":@"11",
                    @"8000":@"17",
                    @"8500":@"18",
                    @"9000":@"11",
                    @"9500":@"11",
                    @"10000":@"26",
                    @"10500":@"42",
                    @"11000":@"70",
                    @"11500":@"46",
                    @"12000":@"31",
                    @"12500":@"23",
                    @"13000":@"40",
                    @"14000":@"27",
                    @"15000":@"23",
                    @"16000":@"27",
                    @"17000":@"31",
                    @"18000":@"32",
                    @"19000":@"36",
                    @"20000":@"25",
                    @"21000":@"26",
                    @"22000":@"26",
                    @"23000":@"20",
                    @"24000":@"12",
                    @"25000":@"4",
                    @"26000":@"4"
                    };
    
    
    for (NSString *baseID in self.IDInfo.allKeys) {
        NSString *count = [self.IDInfo objectForKey:baseID];
        NSInteger baseIDValue = [baseID integerValue];
        //分类
        if (baseIDValue < 6000) {
            [self updateDataInfoWithBaseID:baseID withCount:count withType:PoetryClassEasy];
        }else if (baseIDValue > 6000 && baseIDValue <10000){
            [self updateDataInfoWithBaseID:baseID withCount:count withType:PoetryClassGeneral];
        }else if (baseIDValue > 10000 && baseIDValue <26000){
            [self updateDataInfoWithBaseID:baseID withCount:count withType:PoetryClassDifficult];
        }
    }
    
    //先获取简单 随机的ID，然后查询到诗词，然后随机挑选诗词中的两句。
    for (int i = 0;i< self.easyArray.count;i++) {
        NSMutableArray *array = [NSMutableArray array];//创建一个数组
        [self.optionEasyArray addObject:array];//将该数组添加到选项数组中
        
        NSString *idString = [self.easyArray objectAtIndex:i];//获取当前随机的诗词ID
        PoetryModel *model = [[WLCoreDataHelper shareHelper] fetchPoetryModelWithID:idString];//根据ID获取到诗词Model
        NSArray *contentArray = [[WLPublicTool shareTool] poetrySeperateWithOrigin:model.content];//将诗词内容分割为数组
        [self updateOneLineArrayWithOriginArray:contentArray];//将内容进行分类，不同长度的划分到不同长度中。

        NSString *showTextString = [self loadNextOrBeforeLineWithContentArray:contentArray withPoetryIndex:i withType:PoetryClassEasy];//获取该诗词的若干句，并做空白处理
        [self.easyModelArray addObject:showTextString];//将展示的诗词添加到数组中
    }
    
    //先获取一般 随机的ID，然后查询到诗词，然后随机挑选诗词中的两句。
    for (int i = 0;i< self.generalArray.count;i++) {
        NSMutableArray *array = [NSMutableArray array];//创建一个数组
        [self.optionGeneralArray addObject:array];//将该数组添加到选项数组中
        NSString *idString = [self.generalArray objectAtIndex:i];//获取当前随机的诗词ID
        PoetryModel *model = [[WLCoreDataHelper shareHelper] fetchPoetryModelWithID:idString];//根据ID获取到诗词Model
        NSArray *contentArray = [[WLPublicTool shareTool] poetrySeperateWithOrigin:model.content];//将诗词内容分割为数组
        [self updateOneLineArrayWithOriginArray:contentArray];//将内容进行分类，不同长度的划分到不同长度中。

        NSString *showTextString = [self loadNextOrBeforeLineWithContentArray:contentArray withPoetryIndex:i withType:PoetryClassGeneral];//获取该诗词的若干句，并做空白处理
        [self.generalModelArray addObject:showTextString];//将展示的诗词添加到数组中
    }
    
    //先获取困难 随机的ID，然后查询到诗词，然后随机挑选诗词中的两句。
    for (int i = 0;i< self.difficultArray.count;i++) {
        NSMutableArray *array = [NSMutableArray array];//创建一个数组
        [self.optionDifficultArray addObject:array];//将该数组添加到选项数组中
        
        NSString *idString = [self.difficultArray objectAtIndex:i];//获取当前随机的诗词ID
        PoetryModel *model = [[WLCoreDataHelper shareHelper] fetchPoetryModelWithID:idString];//根据ID获取到诗词Model
    
        NSArray *contentArray = [[WLPublicTool shareTool] poetrySeperateWithOrigin:model.content];//将诗词内容分割为数组
        [self updateOneLineArrayWithOriginArray:contentArray];//将内容进行分类，不同长度的划分到不同长度中。

        NSString *showTextString = [self loadNextOrBeforeLineWithContentArray:contentArray withPoetryIndex:i withType:PoetryClassDifficult];//获取该诗词的若干句，并做空白处理
        [self.difficultModelArray addObject:showTextString];//将展示的诗词添加到数组中
    }
    
    [self updateOptionArray];
    
    [self loadCustomView];
    
}
//把option更新一下
- (void)updateOptionArray
{
    for (NSArray *optionsArray in self.optionEasyArray) {
        NSString *correctAnswer = [optionsArray objectAtIndex:0];
        NSString *noSignAnswer = [self loadNoSignContentWithOrigin:correctAnswer];
    }
}
//根据诗词中不同行的长度进行分类
- (void)updateOneLineArrayWithOriginArray:(NSArray*)contentArray
{
    for (NSString *content in contentArray) {
        NSString *contentForNoSign = [self loadNoSignContentWithOrigin:content];
        if (contentForNoSign.length == 3) {
            [self.threeCharArray addObject:contentForNoSign];
        }else if (contentForNoSign.length == 4){
            [self.fourCharArray addObject:contentForNoSign];
        }else if (contentForNoSign.length == 5){
            [self.fiveCharArray addObject:contentForNoSign];
        }else if (contentForNoSign.length == 7){
            [self.sevenCharArray addObject:contentForNoSign];
        }else{
            [self.otherCharArray addObject:contentForNoSign];
        }
    }
}
//随机挑选诗词中的两句，并把诗词处理为空白
- (NSString*)loadNextOrBeforeLineWithContentArray:(NSArray*)contentArray withPoetryIndex:(NSInteger)index withType:(PoetryClass)type
{
    NSInteger contentLines = contentArray.count;//获取全部的诗词行数
    NSInteger selIndex = arc4random()%contentLines;//随机获取一行数
    NSString *currentContent = [contentArray objectAtIndex:selIndex];//得到随机的内容
    
    NSMutableArray *mutArray;
    //处理了符号的
    NSString *noSignCurrent = [self loadNoSignContentWithOrigin:currentContent];
    if (type == PoetryClassEasy) {
        mutArray = [self.optionEasyArray objectAtIndex:index];
    }else if (type == PoetryClassGeneral){
        mutArray = [self.optionGeneralArray objectAtIndex:index];
    }else if (type == PoetryClassDifficult){
        mutArray = [self.optionDifficultArray objectAtIndex:index];
    }
    [mutArray addObject:noSignCurrent];
    //防止出现重复的项（题目：白日依山尽，______。选项中出现“白日依山尽”）
    [self removeFromArrayWithContent:noSignCurrent];
    
    if ([currentContent containsString:@"。"] || [currentContent containsString:@"！"] || [currentContent containsString:@"？"]||[currentContent containsString:@"；"]){
        if (selIndex-1 >= 0) {
            //空白的内容
            NSMutableString *emptyString = [NSMutableString stringWithString:currentContent];
            //将当前行的所有文本替换掉（最后一个是符号，不替换）
            for (int i =0 ; i < currentContent.length-1; i++) {
                [emptyString replaceCharactersInRange:NSMakeRange(i, 1) withString:@"_"];
            }
            //获取下一句
            NSString *beforeString = [contentArray objectAtIndex:selIndex-1];
            
            NSString *noSignBefore = [self loadNoSignContentWithOrigin:beforeString];
            //防止出现重复的答案（题目：白日依山尽，______。选项中出现2次“黄河入海流”）
            [self removeFromArrayWithContent:noSignBefore];
            //把空白内容和下一句拼起来
            NSString *finalString = [NSString stringWithFormat:@"%@\n%@",beforeString,emptyString];
            return finalString;
        }
    }else {
        //如果含有逗号，则补充下一行
        if (selIndex+1 < contentLines) {
            //空白的内容
            NSMutableString *emptyString = [NSMutableString stringWithString:currentContent];
            //将当前行的所有文本替换掉（最后一个是符号，不替换）
            for (int i =0 ; i < currentContent.length-1; i++) {
                [emptyString replaceCharactersInRange:NSMakeRange(i, 1) withString:@"_"];
            }
            //获取下一句
            NSString *nextString = [contentArray objectAtIndex:selIndex+1];
            
            NSString *noSignNext = [self loadNoSignContentWithOrigin:nextString];
            //防止出现重复的答案（题目：白日依山尽，______。选项中出现2次“黄河入海流”）
            [self removeFromArrayWithContent:noSignNext];
            //把空白内容和下一句拼起来
            NSString *finalString = [NSString stringWithFormat:@"%@\n%@",emptyString,nextString];
            return finalString;
        }
    }
    return @"";
}

//从数组中删除掉某个内容，防止出现重复的项（题目：白日依山尽，______。选项中出现“白日依山尽”）
- (void)removeFromArrayWithContent:(NSString*)content
{
    if (content.length == 3) {
        [self.threeCharArray removeObject:content];
    }else if (content.length == 4){
        [self.fourCharArray removeObject:content];
    }else if (content.length == 5){
        [self.fiveCharArray removeObject:content];
    }else if (content.length == 7){
        [self.sevenCharArray removeObject:content];
    }else{
        [self.otherCharArray removeObject:content];
    }
}
//去除诗句中的符号
- (NSString*)loadNoSignContentWithOrigin:(NSString*)origin
{
    if (origin.length > 0) {
        NSString *lastString = [origin substringWithRange:NSMakeRange(origin.length-1, 1)];
        if ([lastString isEqualToString:@"，"] || [lastString isEqualToString:@"。"] ||[lastString isEqualToString:@"？"] ||[lastString isEqualToString:@"！"] ||[lastString isEqualToString:@"；"] ) {
            return [origin substringWithRange:NSMakeRange(0, origin.length-1)];
        }else{
            return origin;
        }
    }
    return @"";
}

- (void)updateDataInfoWithBaseID:(NSString*)baseID withCount:(NSString*)count withType:(PoetryClass)type
{
    
    NSInteger baseIndex = [baseID integerValue];
    NSInteger countValue = [count integerValue];
    [self.tmpArray removeAllObjects];
    
    for (int i = 1; i<= countValue; i++) {
        [self.tmpArray addObject:[NSString stringWithFormat:@"%ld",baseIndex+i]];
    }
    
    for (int i = 0; i< 3; i++) {
        NSInteger index = arc4random()%(self.tmpArray.count);
        NSString *string = [self.tmpArray objectAtIndex:index];
        if (type == PoetryClassEasy) {
            [self.easyArray addObject:string];
        }else if (type == PoetryClassGeneral){
            [self.generalArray addObject:string];
        }else if (type == PoetryClassDifficult){
            [self.difficultArray addObject:string];
        }
        [self.tmpArray removeObjectAtIndex:index];
        
    }

    
    
}

#pragma mark - 视图

- (void)loadCustomView
{
    self.progressView = [[WQLProgressView alloc]init];
    self.progressView.frameWidth = 100;
    self.progressView.frameHeight = 100;
    self.progressView.lineWidth = 10;
    [self.progressView loadCustomCircle];
    self.progressView.progress = 0;//需要先构建了layer，才能设置strokend
    [self.view addSubview:self.progressView];
    
    //元素的布局
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.view.mas_leading).offset((PhoneScreen_WIDTH-self.progressView.frameWidth)/2);
        make.top.equalTo(self.naviView.mas_bottom).offset(20);
        make.width.mas_equalTo(self.progressView.frameWidth);
        make.height.mas_equalTo(self.progressView.frameHeight);
        
    }];
    
    
//    self.mainScrollView = [[UIScrollView alloc]init];
//    [self.view addSubview:self.mainScrollView];
//    //元素的布局
//    [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.leading.equalTo(self.view.mas_leading).offset(0);
//        make.top.equalTo(self.progressView.mas_bottom).offset(20);
//        make.trailing.equalTo(self.view.mas_trailing).offset(0);
//        make.height.mas_equalTo(100);
//
//    }];
    
    self.questionLabel = [[UILabel alloc]init];
    self.questionLabel.numberOfLines = 0;
    self.questionLabel.font = [UIFont systemFontOfSize:16.f];
    self.questionLabel.textAlignment = NSTextAlignmentCenter;
    self.questionLabel.text = [self.easyModelArray firstObject];
    [self.view addSubview:self.questionLabel];
    //元素的布局
    [self.questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.view.mas_leading).offset(20);
        make.top.equalTo(self.progressView.mas_bottom).offset(30);
        make.trailing.equalTo(self.view.mas_trailing).offset(-20);
        make.height.mas_equalTo(80);
    }];
    [self updateLabelShow];
    
    [self addTimer];
}

- (void)updateLabelShow
{
    self.indexForQuestion += 1;
    NSInteger index = self.indexForQuestion*2;
    NSInteger simpleCount = self.easyModelArray.count;
    NSInteger generalCount = self.generalModelArray.count;
    NSInteger difficultCount = self.difficultModelArray.count;
    NSInteger random = arc4random()%2;

    if (index+random < simpleCount) {
        NSString *question = [self.easyModelArray objectAtIndex:index+random];
        self.questionLabel.text = question;
    }else if (index+random-simpleCount < generalCount){
        NSString *question = [self.generalModelArray objectAtIndex:(index+random-simpleCount)];
        self.questionLabel.text = question;
    }else if (index+random-simpleCount-generalCount < difficultCount){
        NSString *question = [self.difficultModelArray objectAtIndex:(index+random-simpleCount-generalCount)];
        self.questionLabel.text = question;
    }
}

- (void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}


- (void)timerAction:(NSTimer*)timer
{
    if (self.progressView.progress <= 1) {
        self.progressView.progress += 0.04;
    }else{
        self.progressView.progress = 0;
        [self updateLabelShow];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
