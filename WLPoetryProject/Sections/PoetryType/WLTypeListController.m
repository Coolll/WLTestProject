//
//  WLTypeListController.m
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/7/10.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLTypeListController.h"
#import "WLPoetryListController.h"
#import "WLTypeListCell.h"
#import "WLLunYuController.h"
#import "PoetryConfigureModel.h"
@interface WLTypeListController ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  诗词列表
 **/
@property (nonatomic,strong) UITableView *mainTableView;
/**
 *  上次浏览记录
 **/
@property (nonatomic, copy) LastPoetryTypeBlock lastBlock;
@end

@implementation WLTypeListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = ViewBackgroundColor;
    self.titleForNavi = @"诗词分类";
    [self loadCustomData];

}

- (void)loadLastSelectWithBlock:(LastPoetryTypeBlock)block
{
    if (block) {
        self.lastBlock = block;
    }
}

- (void)setTypeDataArray:(NSArray *)typeDataArray
{
    _typeDataArray = typeDataArray;
    
    if (typeDataArray && typeDataArray.count > 0) {
        PoetryConfigureModel *model = [typeDataArray firstObject];
        self.titleForNavi = model.mainTitle;
    }
}

- (void)loadCustomData
{
    
}


#pragma mark - 加载视图
- (void)loadCustomView
{
    
    self.mainTableView = [[UITableView alloc]init];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.backgroundColor = [UIColor clearColor];
    self.mainTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.mainTableView];
    
    //元素的布局
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.view.mas_leading).offset(0);
        make.top.equalTo(self.naviView.mas_bottom).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
        make.trailing.equalTo(self.view.mas_trailing).offset(0);
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.typeDataArray) {
        return self.typeDataArray.count;
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
    return 60;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WLTypeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WLTypeListCell"];;
    if (!cell) {
        cell = [[WLTypeListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WLTypeListCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    if (self.typeDataArray && self.typeDataArray.count > 0) {
        
        if (indexPath.row < self.typeDataArray.count) {
            PoetryConfigureModel *model = [self.typeDataArray objectAtIndex:indexPath.row];
            cell.typeString = model.subTitle;
        }
        cell.imageName = @"";
        
        if (indexPath.row == self.typeDataArray.count-1) {
            cell.needLine = NO;
        }
        
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WLPoetryListController *listVC = [[WLPoetryListController alloc]init];
    PoetryConfigureModel *model = [[PoetryConfigureModel alloc]init];
    
    if (self.typeDataArray && self.typeDataArray.count > indexPath.row) {
        model = self.typeDataArray[indexPath.row];
        
    }
    NSString *mainClass = model.mainClass;
    if ([mainClass isEqualToString:@"34"]||[mainClass isEqualToString:@"35"]||[mainClass isEqualToString:@"36"]) {
        //论语进入的界面和普通界面不一样
        WLLunYuController *vc = [[WLLunYuController alloc]init];
        vc.titleForNavi = model.subTitle;
        vc.mainClass = mainClass;
        [vc loadCustomData];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        //普通的诗词界面
        listVC.titleForNavi = model.subTitle;
        listVC.mainClass = mainClass;
        [listVC loadCustomData];
        listVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:listVC animated:YES];
        
    }
    NSDictionary *typeInfo = [NSDictionary dictionaryWithObjectsAndKeys:model.mainTitle,@"mainTitle",model.subTitle,@"subTitle",model.mainClass,@"mainClass", nil];
    
    NSArray *lastReadList = [NSArray arrayWithObject:typeInfo];
    
    //更新到本地
    [WLSaveLocalHelper saveObject:[lastReadList copy] forKey:@"recentSelectTypeInfo"];
    
    if (self.lastBlock) {
        self.lastBlock(typeInfo);
    }
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
