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
#import "WLScoreController.h"
#import "WLPercentView.h"

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
 *  简单诗词题目数组 确定数据源后不变
 **/
@property (nonatomic,strong) NSMutableArray *easyTextArray;
/**
 *  一般诗词题目数组 确定数据源后不变
 **/
@property (nonatomic,strong) NSMutableArray *generalTextArray;
/**
 *  困难诗词题目数组 确定数据源后不变
 **/
@property (nonatomic,strong) NSMutableArray *difficultTextArray;

/**
 *  简单诗词题目数组 每次题目更新都会变，直到获取了所需的量。比如说需要10道简单的题目，则从简单题目中抽完10道，则不再抽了（遇到空的内容，也会干掉）
 **/
@property (nonatomic,strong) NSMutableArray *easyLeftArray;
/**
 *  一般诗词题目数组 每次题目更新都会变，直到获取了所需的量。比如说需要10道简单的题目，则从简单题目中抽完10道，则不再抽了（遇到空的内容，也会干掉）
 **/
@property (nonatomic,strong) NSMutableArray *generalLeftArray;
/**
 *  困难诗词题目数组 每次题目更新都会变，直到获取了所需的量。比如说需要10道简单的题目，则从简单题目中抽完10道，则不再抽了（遇到空的内容，也会干掉）
 **/
@property (nonatomic,strong) NSMutableArray *difficultLeftArray;

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
 *  倒计时的视图
 **/
@property (nonatomic,strong) WQLProgressView *progressView;

/**
 *  题目的label
 **/
@property (nonatomic,strong) UILabel *questionLabel;

/**
 *  第一选项
 **/
@property (nonatomic,strong) UIButton *oneButton;
/**
 *  第二选项
 **/
@property (nonatomic,strong) UIButton *twoButton;

/**
 *  第三选项
 **/
@property (nonatomic,strong) UIButton *threeButton;

/**
 *  无正确选项
 **/
@property (nonatomic,strong) UIButton *noRightButton;

/**
 *  不认识选项
 **/
@property (nonatomic,strong) UIButton *unknownButton;

/**
 *  展示的题目序数
 **/
@property (nonatomic,assign) NSInteger rightIndex;
/**
 *  总题数 可设置
 **/
@property (nonatomic,assign) NSInteger countForAll;
/**
 *  简单/一般/困难 题数
 **/
@property (nonatomic,assign) NSInteger countForEasy,countForGeneral,countForDifficult;


/**
 *  正确与错误的个数 总题数
 **/
@property (nonatomic,assign) NSInteger countForRight,countForWrong;

/**
 *  答题的进度
 **/
@property (nonatomic,strong) WLPercentView *percentView;



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
    self.easyTextArray = [NSMutableArray array];
    self.generalTextArray = [NSMutableArray array];
    self.difficultTextArray = [NSMutableArray array];
    
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
    
    
    //正确的index
    self.rightIndex = 0;
    self.countForRight = 0;
    self.countForWrong = 0;
    
    self.countForAll = 30;
//    self.countForEasy = self.countForAll*0.3;
//    self.countForDifficult = self.countForAll*0.3;
//    self.countForGeneral = self.countForAll-self.countForEasy-self.countForDifficult;
    self.countForEasy = self.countForGeneral = self.countForDifficult = 2;
    
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
        [self.easyTextArray addObject:showTextString];//将展示的诗词添加到数组中
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
        [self.generalTextArray addObject:showTextString];//将展示的诗词添加到数组中
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
        [self.difficultTextArray addObject:showTextString];//将展示的诗词添加到数组中
    }
    
    //可变的内容
    self.easyLeftArray = [NSMutableArray arrayWithArray:self.easyTextArray];
    self.generalLeftArray = [NSMutableArray arrayWithArray:self.generalTextArray];
    self.difficultLeftArray = [NSMutableArray arrayWithArray:self.difficultTextArray];
    
    
    [self updateOptionArray];
    
    [self loadCustomView];
    
}
//把option更新一下，添加3个对应字数的选项
- (void)updateOptionArray
{
    [self dealOptionArrayWithArray:self.optionEasyArray];
    [self dealOptionArrayWithArray:self.optionGeneralArray];
    [self dealOptionArrayWithArray:self.optionDifficultArray];
    
}

- (void)dealOptionArrayWithArray:(NSArray*)originArray
{
    for (NSMutableArray *optionsArray in originArray) {
        //从可选项中分别处理
        if (optionsArray.count ==0 ) {
            return;
        }
        //拿到正确答案
        NSString *correctAnswer = [optionsArray firstObject];
        //把正确答案中的符号去掉
        NSString *noSignAnswer = [self loadNoSignContentWithOrigin:correctAnswer];
        //数据数组
        NSArray *dataArray ;
        //如果答案是3个字，则从三个字的数组中拿,如果答案是四个字，则从四个字的数组中拿
        if (noSignAnswer.length == 3) {
            dataArray = self.threeCharArray;
        }else if (noSignAnswer.length == 4){
            dataArray = self.fourCharArray;
        }else if (noSignAnswer.length == 5){
            dataArray = self.fiveCharArray;
        }else if (noSignAnswer.length == 7){
            dataArray = self.sevenCharArray;
        }else{
            dataArray = self.otherCharArray;
        }
        
        //子数组，可变。假如答案是5字，则从五字数组中取选项，当取了1个之后，第二次取的时候，五字数组需要移除掉第一次选项，不然的话，可能会出现重复的选项
        NSMutableArray *subArray = [NSMutableArray arrayWithArray:dataArray];
        for (int i =0 ; i < 3; i ++) {
            //获取数据源总共有多少数据
            NSInteger totalCount = subArray.count;
            //获取随机数
            NSInteger index = arc4random()%totalCount;
            if (index < subArray.count) {
                //拿到随机的答案
                NSString *option = [subArray objectAtIndex:index];
                //选项池中 移除掉对应的答案
                [subArray removeObjectAtIndex:index];
                //将选项添加到对应题目的选择中
                [optionsArray addObject:option];
            }else if (self.otherCharArray.count > 0 && optionsArray.count < 2){
                //如果不够选，则从其他的选项池中选 如果一个都没找到，则从其他选项池中选1个
                NSInteger subIndex = arc4random()%self.otherCharArray.count;
                NSString *option = [self.otherCharArray objectAtIndex:subIndex];
                [optionsArray addObject:option];
            }else if(self.fiveCharArray.count > 0 && optionsArray.count < 3 ){
                //如果只找到1个，则从五字选项池中选1个
                NSInteger subIndex = arc4random()%self.fiveCharArray.count;
                NSString *option = [self.fiveCharArray objectAtIndex:subIndex];
                [optionsArray addObject:option];
            }else if (self.sevenCharArray.count > 0 && optionsArray.count < 4){
                //如果只找到2个，则从七字选项池中选1个
                NSInteger subIndex = arc4random()%self.sevenCharArray.count;
                NSString *option = [self.sevenCharArray objectAtIndex:subIndex];
                [optionsArray addObject:option];
            }
        }
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
            for (NSInteger i =currentContent.length-2 ; i >=0 ; i--) {
                [emptyString replaceCharactersInRange:NSMakeRange(i, 1) withString:@"__"];
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
            for (NSInteger i =currentContent.length-2 ; i >=0 ; i--) {
                [emptyString replaceCharactersInRange:NSMakeRange(i, 1) withString:@"__"];
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

#pragma mark 根据类型，添加随机ID到对应的数组中
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
    //时间进度
    self.progressView.backgroundColor = ViewBackgroundColor;
    //从0开始动画
    [self.progressView restartCircle];
    
    self.percentView.progress = 0.0;
    
    //完成后 更新可选项，动画重新开始
    [self.progressView finishWithBlock:^{
        //动画完成后还没选，则错误项+1
        self.countForWrong += 1;
        //更新展示内容
        [self updateLabelShow];
        //重新开始
        [self.progressView restartCircle];
    }];

    
    [self updateLabelShow];
    [self.noRightButton setTitle:@"无正确项" forState:UIControlStateNormal];
    [self.unknownButton setTitle:@"暂不认识" forState:UIControlStateNormal];
    
}


#pragma mark - 更新展示的内容

- (void)updateLabelShow
{
    //随机值
    NSInteger random;
    //选的内容
    NSArray *optionArr;
    //如果简单级别的数量没达标，则从简单的内容中获取
    if (self.countForEasy > 0 && self.easyLeftArray.count > 0) {
        //随机拿一个Index
        random = arc4random()%(self.easyLeftArray.count);
        //获取随机的内容
        NSString *question = [self.easyLeftArray objectAtIndex:random];
        if (question.length == 0) {
            //如果题目内容是空的，则跳过
            [self.easyLeftArray removeObjectAtIndex:random];
            [self updateLabelShow];
            return;
        }
        //设置对应的值
        self.questionLabel.text = question;
        //需求量减1
        self.countForEasy -= 1;
        //找到题目所对应的答案index
        NSInteger originIndex = [self.easyTextArray indexOfObject:question];
        //得到可选项
        optionArr = [self.optionEasyArray objectAtIndex:originIndex];
    }else if (self.countForGeneral > 0 && self.generalLeftArray.count > 0){
        //随机拿一个Index
        random = arc4random()%(self.generalLeftArray.count);
        //获取随机的内容
        NSString *question = [self.generalLeftArray objectAtIndex:random];
        if (question.length == 0) {
            //如果题目内容是空的，则跳过
            [self.generalLeftArray removeObjectAtIndex:random];
            [self updateLabelShow];
            return;
        }
        //设置对应的值
        self.questionLabel.text = question;
        //需求量减1
        self.countForGeneral -= 1;
        //找到题目所对应的答案index
        NSInteger originIndex = [self.generalTextArray indexOfObject:question];
        //得到可选项
        optionArr = [self.optionGeneralArray objectAtIndex:originIndex];

    }else if (self.countForDifficult > 0 && self.difficultLeftArray.count > 0){
        //随机拿一个Index
        random = arc4random()%(self.difficultLeftArray.count);
        //获取随机的内容
        NSString *question = [self.difficultLeftArray objectAtIndex:random];
        [self.difficultLeftArray removeObjectAtIndex:random];

        if (question.length == 0) {
            //如果题目内容是空的，则跳过
            [self updateLabelShow];
            return;
        }
        //设置对应的值
        self.questionLabel.text = question;
        //需求量减1
        self.countForDifficult -= 1;
        //找到题目所对应的答案index
        NSInteger originIndex = [self.difficultTextArray indexOfObject:question];
        //得到可选项
        optionArr = [self.optionDifficultArray objectAtIndex:originIndex];
        
    }else{

        WLScoreController *vc = [[WLScoreController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
        NSLog(@"结束");
    }
    
    CGFloat percent = (CGFloat)(self.countForRight+self.countForWrong)/(CGFloat)self.countForAll;
    self.percentView.progress = percent;
    [self mixedUpArray:optionArr];
    
    
    [self updateQuestionLabelLineSpace];
    
}
//把答案混淆一下顺序
- (void)mixedUpArray:(NSArray*)array
{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
    NSInteger rightBtnIndex = 3;
    if (arr.count == 0) {
        return;
    }
    
    //随机获取一个index
    NSInteger index = arc4random()%arr.count;
    if (index < arr.count) {
        //设置对应选项的值
        [self.oneButton setTitle:[arr objectAtIndex:index] forState:UIControlStateNormal];
        //移除掉 防止有重复的选项
        [arr removeObjectAtIndex:index];
        if (index == 0) {
            rightBtnIndex = 0;
        }
    }
    
    NSInteger indexTwo = arc4random()%arr.count;
    if (indexTwo < arr.count) {
        //设置对应选项的值
        [self.twoButton setTitle:[arr objectAtIndex:indexTwo] forState:UIControlStateNormal];
        [arr removeObjectAtIndex:indexTwo];
        if (index != 0 && indexTwo == 0) {
            rightBtnIndex = 1;
        }
    }
    
    
    NSInteger indexThree = arc4random()%arr.count;
    if (indexThree < arr.count) {
        //设置对应选项的值
        [self.threeButton setTitle:[arr objectAtIndex:indexThree] forState:UIControlStateNormal];
        if (index != 0 && indexTwo !=0 && indexThree == 0) {
            rightBtnIndex = 2;
        }
    }
    
    self.rightIndex = rightBtnIndex;
    
}

- (void)updateQuestionLabelLineSpace
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:self.questionLabel.text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing:10];
    [style setAlignment:NSTextAlignmentCenter];
    [attString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, self.questionLabel.text.length)];
    self.questionLabel.attributedText = attString;

}



- (void)userChooseItem
{
    [self.progressView restartCircle];
    
    
    self.oneButton.backgroundColor = [UIColor whiteColor];
    self.twoButton.backgroundColor = [UIColor whiteColor];
    self.threeButton.backgroundColor = [UIColor whiteColor];
    self.unknownButton.backgroundColor = [UIColor whiteColor];
    self.noRightButton.backgroundColor = [UIColor whiteColor];
    
    [self updateLabelShow];
}

- (void)touchAnswerWithIndex:(NSInteger)selIndex
{
    if (selIndex == self.rightIndex) {
        NSLog(@"正确");
        UIView *view = [self.view viewWithTag:(1000+selIndex)];
        view.backgroundColor = RGBCOLOR(116, 204, 53, 1.0);
        self.countForRight += 1;
    }else{
        NSLog(@"错误");
        UIView *view = [self.view viewWithTag:(1000+selIndex)];
        view.backgroundColor = RGBCOLOR(220, 70, 70, 1.0);
        self.countForWrong += 1;
    }
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self userChooseItem];
    });
}
- (void)oneButtonAction:(UIButton*)sender
{
    NSLog(@"第1选项");
    NSInteger index = sender.tag-1000;
    [self touchAnswerWithIndex:index];

}
- (void)twoButtonAction:(UIButton*)sender
{
    NSLog(@"第2选项");
    NSInteger index = sender.tag-1000;

    
    [self touchAnswerWithIndex:index];


}
- (void)threeButtonAction:(UIButton*)sender
{
    NSLog(@"第3选项");
    NSInteger index = sender.tag-1000;

    [self touchAnswerWithIndex:index];


}
- (void)noRightButtonAction:(UIButton*)sender
{
    NSLog(@"无正确选项");
    NSInteger index = sender.tag-1000;

    [self touchAnswerWithIndex:index];

}
- (void)unknowButtonAction:(UIButton*)sender
{
    NSLog(@"不知道选项");
    
    self.countForWrong += 1;

    [self userChooseItem];
    
}

#pragma mark - 属性
- (UIView *)percentView
{
    if (!_percentView) {
        _percentView = [[WLPercentView alloc]init];
        _percentView.frameWidth = PhoneScreen_WIDTH-40;
        _percentView.frameHeight = 10;
        _percentView.progress = 0;
        [_percentView loadCustomLayer];
        [self.view addSubview:_percentView];
        //元素的布局
        [_percentView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.view.mas_leading).offset(20);
            make.top.equalTo(self.naviView.mas_bottom).offset(10);
            make.trailing.equalTo(self.view.mas_trailing).offset(-20);
            make.height.mas_equalTo(10);
            
        }];
    }
    return _percentView;
}
- (WQLProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[WQLProgressView alloc]init];
        _progressView.frameWidth = 100;
        _progressView.frameHeight = 100;
        _progressView.lineWidth = 10;
        [_progressView loadCustomCircle];
        _progressView.progress = 0;//需要先构建了layer，才能设置strokend
        [self.view addSubview:_progressView];
        
        //元素的布局
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.view.mas_leading).offset((PhoneScreen_WIDTH-self.progressView.frameWidth)/2);
            make.top.equalTo(self.naviView.mas_bottom).offset(40);
            make.width.mas_equalTo(self.progressView.frameWidth);
            make.height.mas_equalTo(self.progressView.frameHeight);
            
        }];
        
    }
    return _progressView;
}
- (UILabel *)questionLabel
{
    if (!_questionLabel) {
        _questionLabel = [[UILabel alloc]init];
        _questionLabel.numberOfLines = 0;
        _questionLabel.font = [UIFont systemFontOfSize:16.f];
        _questionLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_questionLabel];
        //元素的布局
        [_questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.view.mas_leading).offset(20);
            make.top.equalTo(self.progressView.mas_bottom).offset(30);
            make.trailing.equalTo(self.view.mas_trailing).offset(-20);
            make.height.mas_equalTo(80);
        }];
    }
    return _questionLabel;
}


- (UIButton *)oneButton
{
    if (!_oneButton) {
        _oneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _oneButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        _oneButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _oneButton.titleLabel.numberOfLines = 1;
        _oneButton.layer.cornerRadius = 4.f;
        _oneButton.clipsToBounds = YES;
        _oneButton.tag = 1000;
        _oneButton.backgroundColor = [UIColor whiteColor];
        [_oneButton setTitleColor:RGBCOLOR(50, 50, 50, 1.0) forState:UIControlStateNormal];
        [_oneButton addTarget:self action:@selector(oneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_oneButton];
        //元素的布局
        [_oneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.questionLabel.mas_leading).offset(0);
            make.top.equalTo(self.questionLabel.mas_bottom).offset(40);
            make.trailing.equalTo(self.questionLabel.mas_trailing).offset(0);
            make.height.mas_equalTo(40);
            
        }];
    }
    return _oneButton;
}

- (UIButton *)twoButton
{
    if (!_twoButton) {
        _twoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _twoButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        _twoButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _twoButton.titleLabel.numberOfLines = 1;
        _twoButton.layer.cornerRadius = 4.f;
        _twoButton.clipsToBounds = YES;
        _twoButton.tag = 1001;
        _twoButton.backgroundColor = [UIColor whiteColor];
        [_twoButton setTitleColor:RGBCOLOR(50, 50, 50, 1.0) forState:UIControlStateNormal];
        
        [_twoButton addTarget:self action:@selector(twoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_twoButton];
        
        //元素的布局
        [_twoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.questionLabel.mas_leading).offset(0);
            make.top.equalTo(self.oneButton.mas_bottom).offset(12);
            make.trailing.equalTo(self.questionLabel.mas_trailing).offset(0);
            make.height.mas_equalTo(40);
            
        }];
    }
    return _twoButton;
}
- (UIButton *)threeButton
{
    if (!_threeButton) {
        _threeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _threeButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        _threeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _threeButton.titleLabel.numberOfLines = 1;
        _threeButton.layer.cornerRadius = 4.f;
        _threeButton.clipsToBounds = YES;
        _threeButton.tag = 1002;
        _threeButton.backgroundColor = [UIColor whiteColor];
        [_threeButton setTitleColor:RGBCOLOR(50, 50, 50, 1.0) forState:UIControlStateNormal];
        
        [_threeButton addTarget:self action:@selector(threeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_threeButton];
        
        //元素的布局
        [_threeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.questionLabel.mas_leading).offset(0);
            make.top.equalTo(self.twoButton.mas_bottom).offset(12);
            make.trailing.equalTo(self.questionLabel.mas_trailing).offset(0);
            make.height.mas_equalTo(40);
            
        }];
    }
    return _threeButton;
}
- (UIButton *)noRightButton
{
    if (!_noRightButton) {
        _noRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _noRightButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        _noRightButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _noRightButton.titleLabel.numberOfLines = 1;
        _noRightButton.layer.cornerRadius = 4.f;
        _noRightButton.clipsToBounds = YES;
        _noRightButton.tag = 1003;
        _noRightButton.backgroundColor = [UIColor whiteColor];
        [_noRightButton setTitleColor:RGBCOLOR(50, 50, 50, 1.0) forState:UIControlStateNormal];
        
        [_noRightButton addTarget:self action:@selector(noRightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_noRightButton];
        //元素的布局
        [_noRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.questionLabel.mas_leading).offset(0);
            make.top.equalTo(self.threeButton.mas_bottom).offset(12);
            make.trailing.equalTo(self.questionLabel.mas_trailing).offset(0);
            make.height.mas_equalTo(40);
            
        }];
    }
    return _noRightButton;
}

- (UIButton *)unknownButton
{
    if (!_unknownButton) {
        _unknownButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _unknownButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        _unknownButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _unknownButton.titleLabel.numberOfLines = 1;
        _unknownButton.layer.cornerRadius = 4.f;
        _unknownButton.clipsToBounds = YES;
        _unknownButton.tag = 1004;
        _unknownButton.backgroundColor = [UIColor whiteColor];
        [_unknownButton setTitleColor:RGBCOLOR(50, 50, 50, 1.0) forState:UIControlStateNormal];
        [_unknownButton addTarget:self action:@selector(unknowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_unknownButton];
        
        //元素的布局
        [_unknownButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.questionLabel.mas_leading).offset(0);
            make.top.equalTo(self.noRightButton.mas_bottom).offset(12);
            make.trailing.equalTo(self.questionLabel.mas_trailing).offset(0);
            make.height.mas_equalTo(40);
            
        }];
    }
    return _unknownButton;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
