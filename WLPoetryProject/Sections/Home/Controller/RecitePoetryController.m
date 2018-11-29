//
//  RecitePoetryController.m
//  WLPoetryProject
//
//  Created by 变啦 on 2018/11/5.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "RecitePoetryController.h"
#import "WLRecitePoetryCell.h"
#import "WLPoetryHeadCell.h"
static const CGFloat leftSpace = 10;//诗句的左右间距

@interface RecitePoetryController ()<UITableViewDelegate,UITableViewDataSource>

/**
 *  诗词内容table
 **/
@property (nonatomic,strong) UITableView *mainTableView;
/**
 *  是否展开了选项
 **/
@property (nonatomic,assign) BOOL isOpen;
/**
 *  选项 view
 **/
@property (nonatomic,strong) UIView *optionView;
/**
 *  分割数
 **/
@property (nonatomic,assign) NSInteger sepCount;

/**
 *  高度数组
 **/
@property (nonatomic,strong) NSMutableArray *heightArray;

/**
 *  是否需要隐藏
 **/
@property (nonatomic,strong)  NSMutableArray *hideArray;




@end

@implementation RecitePoetryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleForNavi = @"背诵诗词";
    [self loadCustomData];
}

- (void)loadCustomData
{
    self.sepCount = 3;
    self.heightArray = [NSMutableArray array];
    self.hideArray = [NSMutableArray array];
    
}
- (void)loadCustomView
{
    [self loadRightBtn];
    [self loadRandomHideData];
    self.mainTableView.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLayoutSubviews
{
    if (self.heightArray.count > 0) {
        CGFloat tableHeight = self.mainTableView.frame.size.height;
        CGFloat totalHeight = 60;
        for (NSString *heightString in self.heightArray) {
            CGFloat cellH = [heightString floatValue];
            totalHeight += cellH;
        }
        if (totalHeight < tableHeight) {
            self.mainTableView.scrollEnabled = NO;
        }
    }
}
- (void)loadRightBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addEventWithAction:^(UIButton *sender) {
        [self optionAction];
    }];
    [self.naviView addSubview:btn];
    
    //元素的布局
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.naviView.mas_bottom).offset(-10);
        make.trailing.equalTo(self.naviView.mas_trailing).offset(-15);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
        
    }];
    
    UIImageView *optionImage = [[UIImageView alloc]init];
    optionImage.image = [UIImage imageNamed:@"optionIcon"];
    [self.naviView addSubview:optionImage];
    //元素的布局
    [optionImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.naviView.mas_bottom).offset(-12);
        make.trailing.equalTo(self.naviView.mas_trailing).offset(-20);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
        
    }];
    
}
- (void)optionAction{
    NSLog(@"展开选项");
    self.isOpen = !self.isOpen;
    
    if (self.isOpen) {
        self.optionView.hidden = NO;
    }else{
        self.optionView.hidden = YES;
    }
}


- (void)tapTheOptionBg:(UITapGestureRecognizer*)tap
{
    self.optionView.hidden = YES;
    self.isOpen = NO;
}

- (void)optionBtnAction:(UIButton*)sender
{
    NSInteger index = sender.tag-1000;
    NSLog(@"index:%ld",index);
    self.optionView.hidden = YES;
    self.isOpen = NO;
    if (index == 0) {
        self.sepCount = 4;//每4个遮罩
    }else if (index == 1){
        self.sepCount = 2;//每2个遮罩
    }else if (index == 2){
        self.sepCount = 1;//全部遮罩
    }else if (index == 3){
        self.sepCount = INT_MAX;//不遮罩
    }
    [self loadRandomHideData];
    [self.mainTableView reloadData];
}


#pragma mark - TableView 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;//诗词名字+诗词内存
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return self.dataArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //诗词名字+作者
        return 60;
    }else if (indexPath.section == 1){
        //诗词内容
        if (indexPath.row < self.dataArray.count) {
            //如果有存储过高度，则使用
            if (indexPath.row < self.heightArray.count) {
                return [[self.heightArray objectAtIndex:indexPath.row]floatValue];
            }else{
                //计算cell的高度
                NSString *content = self.dataArray[indexPath.row];
                CGFloat height = [WLRecitePoetryCell heightForContent:content withWidth:(PhoneScreen_WIDTH-2*leftSpace-20)];
                [self.heightArray addObject:[NSString stringWithFormat:@"%f",height]];
                return height;
            }
            
        }
    }
    
    
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        WLPoetryHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WLPoetryHeadCell"];
        if (!cell) {
            cell = [[WLPoetryHeadCell alloc]init];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.author = self.dataModel.author;
        cell.name = self.dataModel.name;
        [cell loadCustomView];
        return cell;
    }
    WLRecitePoetryCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"WLPoetryContentCell"];
    if (!contentCell) {
        
        CGFloat cellHeight = 0;
        if (indexPath.row < self.dataArray.count) {
            NSString *content = self.dataArray[indexPath.row];
            cellHeight = [WLRecitePoetryCell heightForContent:content withWidth:(PhoneScreen_WIDTH-2*leftSpace-20)];
        }
        contentCell = [[WLRecitePoetryCell alloc]initWithFrame:CGRectMake(0, 0, PhoneScreen_WIDTH-2*leftSpace-20, cellHeight)];
        contentCell.cellHeight = cellHeight;
    }
    contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    contentCell.backgroundColor = [UIColor clearColor];
    contentCell.contentString = self.dataArray[indexPath.row];
    
    if ([[self.hideArray objectAtIndex:indexPath.row] isEqualToString:@"0"] ) {
        contentCell.needHide = YES;
    }
    return contentCell;
}

- (void)loadRandomHideData
{
    [self.hideArray removeAllObjects];
    //4 1
    NSInteger currentIndex = 0;
    NSInteger origin = 0;
    for (int i = 0; i < self.dataArray.count; i++) {
        //每4个进行一次随机
        if (i%self.sepCount == 0) {
            //获取随机数
            int count = arc4random()%self.sepCount;
            //初始值+随机数
            currentIndex = origin + count;
            //初始值 = 一组的起点位置，如果为4，则0-3为一组，4-7为一组，8-11为一组
            origin = origin + self.sepCount;
        }
        
        if (i == currentIndex) {
            [self.hideArray addObject:@"0"];
        }else{
            [self.hideArray addObject:@"1"];
        }
        
    }
    
}
#pragma mark - 属性

- (UIView*)optionView
{
    if (!_optionView) {
        _optionView = [[UIView alloc]init];
        [self.view addSubview:_optionView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTheOptionBg:)];
        [_optionView addGestureRecognizer:tap];
        _optionView.userInteractionEnabled = YES;
        
        //元素的布局
        [_optionView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.view.mas_leading).offset(0);
            make.top.equalTo(self.naviView.mas_bottom).offset(0);
            make.bottom.equalTo(self.view.mas_bottom).offset(0);
            make.trailing.equalTo(self.view.mas_trailing).offset(0);
        }];
        
        UIImageView *triangleImage = [[UIImageView alloc]init];
        triangleImage.image = [UIImage imageNamed:@"triangle"];
        triangleImage.contentMode = UIViewContentModeScaleAspectFill;
        [_optionView addSubview:triangleImage];
        //元素的布局
        [triangleImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_optionView.mas_top).offset(0);
            make.trailing.equalTo(_optionView.mas_trailing).offset(-20);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(12);
            
        }];
        
        UIView *contentBgView = [[UIView alloc]init];
        contentBgView.backgroundColor = RGBCOLOR(25, 150, 213, 1.0);
        [_optionView addSubview:contentBgView];
        //元素的布局
        [contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(triangleImage.mas_bottom).offset(-4);
            make.trailing.equalTo(_optionView.mas_trailing).offset(-10);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(200);
            
        }];
        
        CGFloat itemH = 50;
        NSArray *titleArray = @[@"简单",@"一般",@"困难",@"巩固"];
        for (int i = 0; i< titleArray.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = contentBgView.backgroundColor;
            btn.tag = 1000+i;
            [btn addTarget:self action:@selector(optionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [contentBgView addSubview:btn];
            //元素的布局
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.leading.equalTo(contentBgView.mas_leading).offset(0);
                make.top.equalTo(contentBgView.mas_top).offset(itemH*i);
                make.trailing.equalTo(contentBgView.mas_trailing).offset(0);
                make.height.mas_equalTo(itemH);
                
            }];
            
            if (i != 3) {
                UIView *lineView = [[UIView alloc]init];
                lineView.backgroundColor = [UIColor whiteColor];
                [btn addSubview:lineView];
                //元素的布局
                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.leading.equalTo(btn.mas_leading).offset(10);
                    make.bottom.equalTo(btn.mas_bottom).offset(-1);
                    make.trailing.equalTo(btn.mas_trailing).offset(-10);
                    make.height.mas_equalTo(0.7);
                    
                }];
            }
            
            
            UILabel *titleLabel = [[UILabel alloc]init];
            titleLabel.text = [titleArray objectAtIndex:i];
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn addSubview:titleLabel];
            //元素的布局
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.leading.equalTo(btn.mas_leading).offset(0);
                make.top.equalTo(btn.mas_top).offset(0);
                make.bottom.equalTo(btn.mas_bottom).offset(0);
                make.trailing.equalTo(btn.mas_trailing).offset(0);
               
            }];
        }
    }
    return _optionView;
}

- (UITableView*)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]init];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_mainTableView];
        
        if (@available(iOS 11.0, *)) {
            //元素的布局
            [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.leading.equalTo(self.view.mas_leading).offset(0);
                make.top.equalTo(self.naviView.mas_bottom).offset(0);
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
                make.trailing.equalTo(self.view.mas_trailing).offset(0);
                
            }];
        }else{
            
            //元素的布局
            [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.leading.equalTo(self.view.mas_leading).offset(0);
                make.top.equalTo(self.naviView.mas_bottom).offset(0);
                make.bottom.equalTo(self.view.mas_bottom).offset(0);
                make.trailing.equalTo(self.view.mas_trailing).offset(0);
                
            }];
        }
        
    }
    return _mainTableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
