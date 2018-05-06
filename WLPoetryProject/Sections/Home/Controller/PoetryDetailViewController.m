//
//  PoetryDetailViewController.m
//  WLPoetryProject
//
//  Created by 龙培 on 2018/4/23.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "PoetryDetailViewController.h"
#import "WLPoetryContentCell.h"

static const CGFloat leftSpace = 10;//诗句的左右间距
static const CGFloat topSpace = 24;//诗句与标题的上间距

@interface PoetryDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

/**
 *  诗词内容table
 **/
@property (nonatomic,strong) UITableView *mainTable;
/**
 *  诗词句子
 **/
@property (nonatomic,strong) NSMutableArray *dataArray;



@end

@implementation PoetryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleForNavi = self.dataModel.name;
    [self loadMainBackImageView];//背景
    [self addFullTitleLabel];//诗词名字 添加背景之后调用，否则会被背景图遮住

    [self loadCustomData];//加载数据
    
    [self addBackButtonForFullScreen];//返回按钮，需要最后添加
}
#pragma mark - 初始化数据和视图

- (void)loadCustomData
{
    self.dataArray = [NSMutableArray array];
    //是否含有句号
    BOOL isContainEnd = [self.dataModel.content containsString:@"。"];
    //有的话，按句号划分
    if (isContainEnd) {
        //拆分成数组
        NSArray *arr = [self.dataModel.content componentsSeparatedByString:@"。"];
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
                
                for (NSString *partString in partArr) {
                    
                    NSArray *exclamationArr = [self dealExclamationWithOrigin:partString];
                    
                    for (NSString *exclamString in exclamationArr) {
                        
                        NSArray *questionArr = [self dealQuestionWithOrigin:exclamString];
                        
                        for (NSString *questionString in questionArr) {
                            [self.dataArray addObject:questionString];
                        }
                    }
                }
                
                
                //非空诗句添加到数组中
                
                
            }
           
            //循环处理了全部诗词
        }
        
        //加载诗句
        [self loadContentTableView];
    }
    
    
    
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

    //是否包含感叹号
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
    
    //是否包含问号
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

- (void)loadMainBackImageView
{
    //诗词主背景
    UIImageView *mainImageView = [[UIImageView alloc]init];
    mainImageView.image = [UIImage imageNamed:@"poetryBack.jpg"];
    [self.view addSubview:mainImageView];
    
    //元素的布局
    [mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);

    }];
    
}

- (void)loadContentTableView
{
    self.mainTable.backgroundColor = [UIColor clearColor];
}

#pragma mark - TableView 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataArray.count) {
        NSString *content = self.dataArray[indexPath.row];
        return [WLPoetryContentCell heightForContent:content withWidth:(PhoneScreen_WIDTH-2*leftSpace-20)];
    }
    
    return 0;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WLPoetryContentCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"WLPoetryContentCell"];
    if (!contentCell) {
        
        CGFloat cellHeight = 0;
        if (indexPath.row < self.dataArray.count) {
            NSString *content = self.dataArray[indexPath.row];
            cellHeight = [WLPoetryContentCell heightForContent:content withWidth:(PhoneScreen_WIDTH-2*leftSpace-20)];
        }
        contentCell = [[WLPoetryContentCell alloc]initWithFrame:CGRectMake(0, 0, PhoneScreen_WIDTH-2*leftSpace-20, cellHeight)];
    }
    contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    contentCell.backgroundColor = [UIColor clearColor];
    contentCell.contentString = self.dataArray[indexPath.row];
    return contentCell;
}
#pragma mark - 点击事件

- (void)backAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - Property
- (UITableView*)mainTable
{
    if (!_mainTable) {
        
        _mainTable = [[UITableView alloc]init];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTable.showsVerticalScrollIndicator= NO;
        [self.view addSubview:_mainTable];
        //元素的布局
        [_mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view.mas_left).offset(leftSpace);
            make.top.equalTo(self.titleFullLabel.mas_bottom).offset(topSpace);
            make.bottom.equalTo(self.view.mas_bottom).offset(-topSpace);
            make.right.equalTo(self.view.mas_right).offset(-leftSpace);
            
        }];
    }
    return _mainTable;
}



@end
