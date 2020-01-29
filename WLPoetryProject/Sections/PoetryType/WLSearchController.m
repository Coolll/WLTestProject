//
//  WLSearchController.m
//  WLPoetryProject
//
//  Created by 龙培 on 2018/6/4.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLSearchController.h"
#import "SearchPoetryCell.h"
#import "PoetryDetailViewController.h"

@interface WLSearchController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
/**
 *  搜索输入框
 **/
@property (nonatomic,strong) UITextField *searchTextField;

/**
 *  诗词列表
 **/
@property (nonatomic,strong) UITableView *mainTableView;

/**
 *  诗词数据源
 **/
@property (nonatomic,strong) NSMutableArray *poetryArray;
/**
 *  高度数组
 **/
@property (nonatomic,strong) NSMutableArray *heightArray;
/**
 *  page
 **/
@property (nonatomic,assign) NSInteger currentPage;
/**
 *  搜索的关键词
 **/
@property (nonatomic,copy) NSString *keywordString;
/**
 *  首次创建
 **/
@property (nonatomic,assign) BOOL isFirstLoad;
/**
 *  是否正在网络请求，避免上拉时重复请求
 **/
@property (nonatomic,assign) BOOL isRequesting;
/**
 *  是否还有诗词
 **/
@property (nonatomic,assign) BOOL hasNext;



@end

@implementation WLSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.naviColor = RGBCOLOR(250, 250, 250, 1.0);
    self.poetryArray = [NSMutableArray array];
    [self removeAllNaviItems];
    
    [self loadCustomNavi];
    [self loadCustomData];
}

- (void)loadCustomData{
    self.isFirstLoad = YES;
    self.isRequesting = NO;
    self.hasNext = YES;
}

- (void)loadCustomNavi
{
    CGFloat cancelWidth = 60;
    CGFloat leftSpace = 15;
    UIView *searchBgView = [[UIView alloc]init];
    searchBgView.layer.cornerRadius = 4.0f;
    searchBgView.backgroundColor = RGBCOLOR(220, 220, 220, 1.0);
    [self.naviView addSubview:searchBgView];
    //元素的布局
    [searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.naviView.mas_leading).offset(leftSpace);
        make.bottom.equalTo(self.naviView.mas_bottom).offset(-8);
        make.trailing.equalTo(self.naviView.mas_trailing).offset(-leftSpace-cancelWidth);
        make.height.mas_equalTo(32);
        
    }];
    
    UIImageView *searchImage = [[UIImageView alloc]init];
    searchImage.image = [UIImage imageNamed:@"search_black"];
    [searchBgView addSubview:searchImage];
    //元素的布局
    [searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(searchBgView.mas_leading).offset(6);
        make.top.equalTo(searchBgView.mas_top).offset(6);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
        
    }];
    
    self.searchTextField = [[UITextField alloc]init];
    self.searchTextField.backgroundColor = RGBCOLOR(220, 220, 220, 1.0);
    self.searchTextField.placeholder = @"请输入搜索关键词";
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    self.searchTextField.delegate = self;
    [searchBgView addSubview:self.searchTextField];
    //元素的布局
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(searchImage.mas_trailing).offset(4);
        make.top.equalTo(searchBgView.mas_top).offset(0);
        make.bottom.equalTo(searchBgView.mas_bottom).offset(0);
        make.trailing.equalTo(searchBgView.mas_trailing).offset(-5);
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGBCOLOR(43, 180, 246, 1.0) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviView addSubview:cancelBtn];
    //元素的布局
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(searchBgView.mas_trailing).offset(10);
        make.top.equalTo(searchBgView.mas_top).offset(0);
        make.bottom.equalTo(searchBgView.mas_bottom).offset(0);
        make.trailing.equalTo(self.naviView.mas_trailing).offset(-5);
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.searchTextField becomeFirstResponder];
    });
    
    
}


#pragma mark - 点击返回的事件
- (void)cancelAction:(UIButton *)sender
{
    [self.searchTextField resignFirstResponder];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];

    });
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.currentPage = 0;
    self.keywordString = textField.text;
    NSLog(@"开始请求page:%ld",self.currentPage);

    [[NetworkHelper shareHelper] requestPoetryWithKeyword:textField.text withPage:self.currentPage withCompletion:^(BOOL success, NSDictionary *dic, NSError *error) {
        if (success) {
            NSString *codeString = [NSString stringWithFormat:@"%@",[dic objectForKey:@"retCode"]];
            if ([codeString isEqualToString:@"1000"]) {
                NSArray *dataArr = [dic objectForKey:@"data"];
                for (NSDictionary *poetryDic in dataArr) {
                    PoetryModel *model = [[PoetryModel alloc]initPoetryWithDictionary:poetryDic];
                    [model loadFirstLineString];
                    [self.poetryArray addObject:model];
                }
                self.currentPage += 1;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadCustomView];
                });
                
            }else{
                NSString *tipMessage = [dic objectForKey:@"message"];
                [self showHUDWithText:tipMessage];
                return ;
            }
        }else{
            [self showHUDWithText:@"请求失败，请重试"];
        }
       
    }];
    
    [self.searchTextField resignFirstResponder];
    return NO;
}

- (void)loadTableHeaderAndFooter
{
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHomeData)];
    self.mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)refreshHomeData{
    if (self.isRequesting) {
        return;
    }
    NSLog(@"刷新数据了");
    self.currentPage = 0;
    self.isRequesting = YES;
    [[NetworkHelper shareHelper] requestPoetryWithKeyword:self.keywordString withPage:self.currentPage withCompletion:^(BOOL success, NSDictionary *dic, NSError *error) {
        self.isRequesting = NO;
        [self.mainTableView.mj_header endRefreshing];

        if (success) {
            NSString *codeString = [NSString stringWithFormat:@"%@",[dic objectForKey:@"retCode"]];
            if ([codeString isEqualToString:@"1000"]) {
                [self.poetryArray removeAllObjects];
                NSArray *dataArr = [dic objectForKey:@"data"];
                for (NSDictionary *poetryDic in dataArr) {
                    PoetryModel *model = [[PoetryModel alloc]initPoetryWithDictionary:poetryDic];
                    [model loadFirstLineString];
                    [self.poetryArray addObject:model];
                }
                if (dataArr.count == 10) {
                    self.hasNext = YES;
                }else{
                    self.hasNext = NO;
                }
                self.currentPage += 1;

                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadCustomView];
                });
                
            }else{
                NSString *tipMessage = [dic objectForKey:@"message"];
                [self showHUDWithText:tipMessage];
                return ;
            }
        }else{
            [self showHUDWithText:@"请求失败，请重试"];
        }
       
    }];

}

- (void)loadMoreData{
    NSLog(@"加载更多");
    if (self.isRequesting) {
        return;
    }
    if (!self.hasNext) {
        [self showHUDWithText:@"无更多数据了"];
        [self.mainTableView.mj_footer endRefreshing];
        return;
    }
    self.isRequesting = YES;
    NSLog(@"加载更多page:%ld",self.currentPage);

    [[NetworkHelper shareHelper] requestPoetryWithKeyword:self.keywordString withPage:self.currentPage withCompletion:^(BOOL success, NSDictionary *dic, NSError *error) {
        self.isRequesting = NO;
        [self.mainTableView.mj_footer endRefreshing];

        if (success) {
            NSString *codeString = [NSString stringWithFormat:@"%@",[dic objectForKey:@"retCode"]];
            if ([codeString isEqualToString:@"1000"]) {
                NSArray *dataArr = [dic objectForKey:@"data"];
                for (NSDictionary *poetryDic in dataArr) {
                    PoetryModel *model = [[PoetryModel alloc]initPoetryWithDictionary:poetryDic];
                    [model loadFirstLineString];
                    [self.poetryArray addObject:model];
                }
                if (dataArr.count == 10) {
                    self.hasNext = YES;
                }else{
                    self.hasNext = NO;
                }
                self.currentPage += 1;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadCustomView];
                });
                
            }else{
                NSString *tipMessage = [dic objectForKey:@"message"];
                [self showHUDWithText:tipMessage];
                return ;
            }
        }else{
            [self showHUDWithText:@"请求失败，请重试"];
        }
       
    }];
}


#pragma mark - 加载视图
- (void)loadCustomView
{
    [self.mainTableView reloadData];
    
    if (self.isFirstLoad) {
        [self loadTableHeaderAndFooter];
        self.isFirstLoad = NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.poetryArray.count;
    }
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.heightArray.count > indexPath.row) {
        return [[self.heightArray objectAtIndex:indexPath.row] floatValue];
    }else{
        if (self.poetryArray.count > indexPath.row) {
            return [SearchPoetryCell heightForFirstLine:[self.poetryArray objectAtIndex:indexPath.row]];
        }
    }
    
    return 0.001;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PoetryModel *model = [self.poetryArray objectAtIndex:indexPath.row];
    
    SearchPoetryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchPoetryCell"];;
    if (!cell) {
        cell = [[SearchPoetryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchPoetryCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    if (indexPath.row == self.poetryArray.count-1) {
        cell.isLast = YES;
    }else{
        cell.isLast = NO;
    }
    
    cell.dataModel = model;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.poetryArray.count) {
        
        PoetryDetailViewController *detailVC = [[PoetryDetailViewController alloc]init];
        detailVC.dataModel = self.poetryArray[indexPath.row];
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}


- (UITableView*)mainTableView
{
    if (!_mainTableView) {
        
        _mainTableView = [[UITableView alloc]init];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = [UIColor clearColor];
        _mainTableView.estimatedRowHeight = 0;
        _mainTableView.estimatedSectionFooterHeight = 0;
        _mainTableView.estimatedSectionHeaderHeight = 0;
        [self.view addSubview:_mainTableView];
        
        //元素的布局
        [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.view.mas_leading).offset(0);
            make.top.equalTo(self.naviView.mas_bottom).offset(0);
            make.bottom.equalTo(self.view.mas_bottom).offset(0);
            make.trailing.equalTo(self.view.mas_trailing).offset(0);
            
        }];

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
