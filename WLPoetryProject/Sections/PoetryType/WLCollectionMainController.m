//
//  WLPoetryTypeController.m
//  WLPoetryProject
//
//  Created by 龙培 on 2018/5/7.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLCollectionMainController.h"
#import "WLPoetryListController.h"
#import "WLSearchController.h"
#import "WLTypeListCell.h"
#import "WLGradeTypeCell.h"
#import "WLTypeListController.h"

@interface WLCollectionMainController ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  诗词列表
 **/
@property (nonatomic,strong) UITableView *mainTableView;

/**
 *  年级 诗词数据源
 **/
@property (nonatomic,copy) NSArray *gradeSectionArray;

/**
 *  诗集 诗词数据源
 **/
@property (nonatomic,copy) NSArray *collectionSectionArray;

/**
 *  近期阅读的 诗词数据源
 **/
@property (nonatomic,strong) NSMutableArray *recentSectionArray;

@end

@implementation WLCollectionMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = ViewBackgroundColor;
    self.titleForNavi = @"诗词分类";
    [self loadCustomData];
    [self loadCustomView];
    [self loadSearchView];
}


- (void)loadSearchView
{
    UIImageView *searchImage = [[UIImageView alloc]init];
    searchImage.image = [UIImage imageNamed:@"search"];
    [self.naviView addSubview:searchImage];
    //元素的布局
    [searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.naviView.mas_bottom).offset(-10);
        make.trailing.equalTo(self.naviView.mas_trailing).offset(-25);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
        
    }];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor clearColor]];
    [self.naviView addSubview:btn];
    //元素的布局
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(searchImage.mas_leading).offset(-10);
        make.top.equalTo(searchImage.mas_top).offset(-10);
        make.bottom.equalTo(self.naviView.mas_bottom).offset(0);
        make.trailing.equalTo(self.naviView.mas_trailing).offset(0);
        
    }];
}
- (void)searchButtonAction:(UIButton*)sender
{
    NSLog(@"搜索");
    WLSearchController *searchVC = [[WLSearchController alloc]init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];

}


- (void)loadCustomData
{
    self.recentSectionArray = [NSMutableArray array];

    NSArray *recentList = [WLSaveLocalHelper loadObjectForKey:@"recentSelectTypeInfo"];
    if (!recentList) {
        [WLSaveLocalHelper saveObject:[NSArray array] forKey:@"recentSelectTypeInfo"];
    }else{
        self.recentSectionArray = [recentList mutableCopy];
    }
    
    
    self.gradeSectionArray = [NSArray arrayWithObjects:@"小学",@"初中",@"高中", nil];
    self.collectionSectionArray = [NSArray arrayWithObjects:@"唐诗",@"宋词", nil];

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
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.recentSectionArray && self.recentSectionArray.count > 0) {
        return 3;//近期、年级、诗集
    }else{
        return 2;//年级、诗集
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]init];
    headerView.frame = CGRectMake(0, 0, PhoneScreen_WIDTH, 40);
    headerView.backgroundColor = RGBCOLOR(235, 235, 235, 1.0);
    
    UILabel *sectionLabel = [[UILabel alloc]init];
    sectionLabel.frame = CGRectMake(15, 0, PhoneScreen_WIDTH-30, 40);
    sectionLabel.backgroundColor = RGBCOLOR(235, 235, 235, 1.0);
    sectionLabel.font = [UIFont systemFontOfSize:16.f];
    [headerView addSubview:sectionLabel];
    
    if (self.recentSectionArray && self.recentSectionArray.count > 0) {
        
        //如果近期阅读过，则把近期看的放在首位，然后年级、诗集
        if (section ==0) {
            sectionLabel.text = @"近期浏览";
        }else if (section == 1){
            sectionLabel.text = @"年级";
        }else if (section == 2){
            sectionLabel.text = @"诗集";
        }
        
    }else{
        //如果无近期阅读记录，则年级、诗集
        if (section == 0){
            sectionLabel.text = @"年级";
        }else if (section == 1){
            sectionLabel.text = @"诗集";
        }
        
    }
    
    
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.recentSectionArray && self.recentSectionArray.count > 0) {
        if (indexPath.section == 0) {
            return 60;
        }else if(indexPath.section == 1){
            return [WLGradeTypeCell heightForTypeCellWithCount:self.gradeSectionArray.count];
        }else if (indexPath.section == 2){
            return [WLGradeTypeCell  heightForTypeCellWithCount:self.collectionSectionArray.count];
        }
    }else{
        if(indexPath.section == 0){
            return [WLGradeTypeCell heightForTypeCellWithCount:self.gradeSectionArray.count];
        }else if (indexPath.section == 1){
            return [WLGradeTypeCell  heightForTypeCellWithCount:self.collectionSectionArray.count];
        }
    }
    
    
    
    return 200;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger section = indexPath.section;
    
    if (self.recentSectionArray && self.recentSectionArray.count > 0) {
        
        //近期、年级、诗集
        if (section == 0) {
            //近期
            WLTypeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WLTypeListCell"];;
            if (!cell) {
                cell = [[WLTypeListCell alloc]init];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            cell.imageName = @"typeHistory";
            cell.typeString = [self.recentSectionArray[indexPath.row] objectForKey:@"subTitle"];
            cell.needLine = NO;
            return cell;
        }else if (section == 1){
            //年级
            return [self cellForGradeAtIndexPath:indexPath withTable:tableView];

        }else if (section == 2){
            //诗集
            return [self cellForCollectionAtIndexPath:indexPath withTable:tableView];
            
        }
        
    }else{
        //年级、诗集
        if (section == 0){
            return [self cellForGradeAtIndexPath:indexPath withTable:tableView];
        }else if (section == 1){
            return [self cellForCollectionAtIndexPath:indexPath withTable:tableView];

        }
        
    }
    
    return [[UITableViewCell alloc]init];
}

- (WLGradeTypeCell*)cellForGradeAtIndexPath:(NSIndexPath *)indexPath withTable:(UITableView*)tableView
{
    WLGradeTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WLGradeTypeCell"];
    
    if (!cell) {
        cell = [[WLGradeTypeCell alloc]init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.booksArray = self.gradeSectionArray;
    [cell clickWithBlock:^(NSInteger index) {
        [self clickGradeWithIndex:index];
    }];
    [cell loadCustomView];
    return cell;
}

- (WLGradeTypeCell*)cellForCollectionAtIndexPath:(NSIndexPath*)indexPath withTable:(UITableView*)tableView
{
    WLGradeTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WLGradeTypeCell"];
    if (!cell) {
        cell = [[WLGradeTypeCell alloc]init];
    }
    cell.booksArray = self.collectionSectionArray;
    [cell clickWithBlock:^(NSInteger index) {
        [self clickCollectionWithIndex:index];
    }];
    [cell loadCustomView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    WLPoetryListController *listVC = [[WLPoetryListController alloc]init];
    NSDictionary *typeInfo = [NSDictionary dictionary];

    if (self.recentSectionArray && self.recentSectionArray.count > 0) {
        //近期、年级、唐诗、宋词
        if (section == 0) {
            typeInfo = self.recentSectionArray[indexPath.row];
            listVC.titleForNavi = [typeInfo objectForKey:@"subTitle"];
            listVC.jsonName = [typeInfo objectForKey:@"jsonName"];
            listVC.mainClass = [typeInfo objectForKey:@"mainClass"];
            [listVC loadCustomData];
            listVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:listVC animated:YES];

        }else if (section == 1){

        }else if (section == 2){

        }

    }else{
        
        //年级、唐诗、宋词
        if (section == 0){

        }else if (section == 1){

        }
        
    }

   
}


- (void)clickGradeWithIndex:(NSInteger)index
{
    WLTypeListController *vc = [[WLTypeListController alloc]init];
    NSArray *dataArray = nil;
    
    if (index == 0) {
        //小学
        dataArray = [self readConfigureWithFileName:@"configureGradePrimary"];
       
    }else if (index == 1){
        //初中
        dataArray = [self readConfigureWithFileName:@"configureGradeJuinor"];
        
    }else if (index == 2){
        //高中
        dataArray = [self readConfigureWithFileName:@"configureGradeSenior"];
        
    }
    
    vc.typeDataArray = dataArray;
    [vc loadCustomView];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

    [vc loadLastSelectWithBlock:^(NSDictionary *info) {
        [self.recentSectionArray removeAllObjects];
        [self.recentSectionArray addObject:info];
        [self.mainTableView reloadData];
    }];
}

- (void)clickCollectionWithIndex:(NSInteger)index
{
    WLTypeListController *vc = [[WLTypeListController alloc]init];
    NSArray *dataArray = nil;
    if (index == 0) {
        //唐诗
        dataArray = [self readConfigureWithFileName:@"configureTang"];
        
    }else if (index == 1){
        //宋词
        dataArray = [self readConfigureWithFileName:@"configureSong"];
       
    }
    
    vc.typeDataArray = dataArray;
    [vc loadCustomView];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    [vc loadLastSelectWithBlock:^(NSDictionary *info) {
        [self.recentSectionArray removeAllObjects];
        [self.recentSectionArray addObject:info];
        [self.mainTableView reloadData];
    }];
}

- (NSArray*)readConfigureWithFileName:(NSString*)fileName
{
    //从本地读取文件
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"json"]];
    //转为dic
    NSDictionary *configureData = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    
    //获取到年级的配置列表
    NSArray *array = [configureData objectForKey:@"dataList"];
    return array;
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
