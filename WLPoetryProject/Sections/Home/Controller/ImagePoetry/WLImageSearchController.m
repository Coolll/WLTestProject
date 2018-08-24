//
//  WLImageSearchController.m
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/6/29.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLImageSearchController.h"
#import "WLCoreDataHelper.h"
#import "WLPoetryListCell.h"
#import "PoetryDetailViewController.h"

@interface WLImageSearchController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
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
@property (nonatomic,strong) NSArray *poetryArray;

/**
 *  高度数组
 **/
@property (nonatomic,strong) NSMutableArray *heightArray;

/**
 *  选择的block
 **/
@property (nonatomic, copy) WLImageSelBlock selBlock;

@end

@implementation WLImageSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.naviColor = RGBCOLOR(250, 250, 250, 1.0);
    [self removeAllNaviItems];
    
    [self loadCustomNavi];
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
    self.poetryArray = [[WLCoreDataHelper shareHelper] searchPoetryListWithKeyWord:textField.text];
    [self loadCustomView];
    [self.searchTextField resignFirstResponder];
    return NO;
}


#pragma mark - 加载视图
- (void)loadCustomView
{
    self.mainTableView.backgroundColor = RGBCOLOR(246, 246, 246, 1.0);

    [self.mainTableView reloadData];

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
            return [WLPoetryListCell heightForFirstLine:[self.poetryArray objectAtIndex:indexPath.row]];
        }
    }
    
    return 0.001;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PoetryModel *model = [self.poetryArray objectAtIndex:indexPath.row];
    
    WLPoetryListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WLPoetryListCell"];;
    if (!cell) {
        cell = [[WLPoetryListCell alloc]initWithFrame:CGRectMake(0, 0, PhoneScreen_WIDTH, 125)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.dataModel = model;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < self.poetryArray.count) {
        
        PoetryModel *dataModel = self.poetryArray[indexPath.row];

//        [self showAlertWithModel:dataModel];
        [self sureUsePoetryWithModel:dataModel];

    }
    
}

- (void)showAlertWithModel:(PoetryModel*)model
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否使用该诗词？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"确定");
        [self sureUsePoetryWithModel:model];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"再看看" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"取消");
    }];
    
    [alertController addAction:action];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:NO completion:nil];

}


-(void)sureUsePoetryWithModel:(PoetryModel*)model
{
    if (self.selBlock) {
        self.selBlock(model);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}
- (void)selectPoetryWithBlock:(WLImageSelBlock)block
{
    if (block) {
        self.selBlock = block;
    }
}

#pragma mark - property属性
- (UITableView*)mainTableView
{
    if (!_mainTableView) {
        
//        UIImageView *mainBgView = [[UIImageView alloc]init];
//        mainBgView.image = [UIImage imageNamed:@"searchBg.jpg"];
//        [self.view addSubview:mainBgView];
        //元素的布局
//        [mainBgView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.leading.equalTo(self.view.mas_leading).offset(0);
//            make.top.equalTo(self.naviView.mas_bottom).offset(0);
//            make.bottom.equalTo(self.view.mas_bottom).offset(0);
//            make.trailing.equalTo(self.view.mas_trailing).offset(0);
//
//        }];
        
        _mainTableView = [[UITableView alloc]init];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = [UIColor clearColor];
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


@end
