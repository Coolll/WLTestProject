//
//  WLLikeController.m
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/6/17.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLLikeController.h"
#import "PoetryModel.h"
#import "WLCoreDataHelper.h"
#import "WLPoetryListCell.h"
#import "PoetryDetailViewController.h"
@interface WLLikeController ()<UITableViewDataSource,UITableViewDelegate>
/**
 *  诗词列表
 **/
@property (nonatomic,strong) UITableView *mainTableView;
/**
 *  数据源
 **/
@property (nonatomic, strong) NSMutableArray *modelArray;
/**
 *  高度数组
 **/
@property (nonatomic,strong) NSMutableArray *heightArray;
/**
 *  空的数据
 **/
@property (nonatomic, strong) UILabel *noLabel;

@end

@implementation WLLikeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewBackgroundColor;
    self.titleForNavi = @"我的收藏";

    [self loadLikeData];
    
}

- (void)loadLikeData
{
    self.heightArray = [NSMutableArray array];

    self.modelArray = [NSMutableArray array];
    
    BmobUser *user = [BmobUser currentUser];
    
    if (user) {
        
        NSMutableArray *array = [NSMutableArray arrayWithArray:[user objectForKey:@"likePoetryIDList"]];
        
        if (array.count == 0) {
            [self loadEmptyLikeView];
            return;
        }else{
            self.noLabel.hidden = YES;
        }
        
        [self fetchPoetryWithIdArray:array];
        
        
    }
    
}


- (void)loadEmptyLikeView
{
    self.noLabel = [[UILabel alloc]init];
    self.noLabel.text = @"暂无收藏";//设置文本
    self.noLabel.textColor = RGBCOLOR(200, 200, 200, 1.0);
    self.noLabel.font = [UIFont boldSystemFontOfSize:20];//字号设置
    self.noLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.noLabel];
    //设置UI布局约束
    [self.noLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).offset((PhoneScreen_HEIGHT-40-64)/2);//元素顶部约束
        make.leading.equalTo(self.view.mas_leading).offset(0);//元素左侧约束
        make.trailing.equalTo(self.view.mas_trailing).offset(0);//元素右侧约束
        make.height.mas_equalTo(40);//元素高度
    }];
}

- (void)fetchPoetryWithIdArray:(NSArray*)array
{
    for (NSString *idString in array) {
        
        PoetryModel *model = [[WLCoreDataHelper shareHelper] fetchPoetryModelWithID:idString];
        [self.modelArray addObject:model];
    }
    
    [self loadCustomView];

    
}


#pragma mark - 加载视图
- (void)loadCustomView
{
    UIImageView *mainBgView = [[UIImageView alloc]init];
    mainBgView.image = [UIImage imageNamed:@"likeBgImage"];
    [self.view addSubview:mainBgView];
    //元素的布局
    [mainBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.naviView.mas_bottom).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        
    }];
    
    self.mainTableView = [[UITableView alloc]init];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.mainTableView];
    
    //元素的布局
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.naviView.mas_bottom).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.modelArray.count;
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
        if (self.modelArray.count > indexPath.row) {
            return [WLPoetryListCell heightForFirstLine:[self.modelArray objectAtIndex:indexPath.row]];
        }
    }
    
    return 0.001;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PoetryModel *model = [self.modelArray objectAtIndex:indexPath.row];
    
    
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
    if (indexPath.row < self.modelArray.count) {
        
        PoetryDetailViewController *detailVC = [[PoetryDetailViewController alloc]init];
        detailVC.dataModel = self.modelArray[indexPath.row];
        
        [detailVC clickLikeWithBlock:^(BOOL isLike){
            
            
            //可能需要删除
            if (!isLike) {
                [self.modelArray removeObjectAtIndex:indexPath.row];
                [self.mainTableView reloadData];
            }
        }];
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}


#pragma mark - 点击事件

- (void)backAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
