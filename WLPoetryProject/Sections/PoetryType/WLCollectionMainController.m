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
#import "PoetryConfigureModel.h"
#import "WLLunYuController.h"
@interface WLCollectionMainController ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  诗词列表
 **/
@property (nonatomic,strong) UITableView *mainTableView;


/**
 *  近期阅读的 诗词数据源
 **/
@property (nonatomic,strong) NSMutableArray *recentSectionArray;

/**
 *  第一模块的诗词
 **/
@property (nonatomic,strong) NSMutableArray *sectionOneArray;
/**
 *  第二模块的诗词
 **/
@property (nonatomic,strong) NSMutableArray *sectionTwoArray;

/**
 *  第一模块的分类个数
 **/
@property (nonatomic,strong) NSMutableArray *sectionOneBooksTitleArray;

/**
 *  第二模块的分类个数
 **/
@property (nonatomic,strong) NSMutableArray *sectionTwoBooksTitleArray;



@end

@implementation WLCollectionMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = ViewBackgroundColor;
    self.titleForNavi = @"诗词分类";
    [self loadCustomData];
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
    self.sectionOneArray = [NSMutableArray array];
    self.sectionTwoArray = [NSMutableArray array];

    NSArray *recentList = [WLSaveLocalHelper loadObjectForKey:@"recentSelectTypeInfo"];
    if (!recentList) {
        [WLSaveLocalHelper saveObject:[NSArray array] forKey:@"recentSelectTypeInfo"];
    }else{
        self.recentSectionArray = [recentList mutableCopy];
    }
    
    [self requestPoetryConfigureData];

}

- (void)requestPoetryConfigureData{
    
    [[NetworkHelper shareHelper]requestPoetryConfigureWithCompletion:^(BOOL success, NSDictionary *dic, NSError *error) {
        if (success) {

            NSString *code = [NSString stringWithFormat:@"%@",[dic objectForKey:@"retCode"]];
            if (![code isEqualToString:@"1000"]) {
                NSString *tipMessage = [dic objectForKey:@"message"];
                [self showHUDWithText:tipMessage];
                return ;
            }
            [self dealConfigureData:dic];
            
            
        }else{
            if (!self.retryBtn) {
                [self loadEmptyView];
            }
        }
    }];

}

- (void)retryRequest
{
    [super retryRequest];
    [self requestPoetryConfigureData];
}

- (void)dealConfigureData:(NSDictionary*)dic{
    NSArray *confDicArray = [dic objectForKey:@"data"];
    
    self.sectionOneBooksTitleArray = [NSMutableArray array];
    self.sectionTwoBooksTitleArray = [NSMutableArray array];
    [self.sectionOneArray removeAllObjects];
    [self.sectionTwoArray removeAllObjects];
    
    NSInteger sectionOneCount = self.sectionOneBooksTitleArray.count;
    NSInteger sectionTwoCount = self.sectionTwoBooksTitleArray.count;
    
    for (NSDictionary *confDic in confDicArray) {
        PoetryConfigureModel *model = [[PoetryConfigureModel alloc]initModelWithDictionary:confDic];
        if (model.tableSection == 0) {
            if (model.tableIndex+1 > sectionOneCount) {
                sectionOneCount = model.tableIndex+1;
                [self.sectionOneBooksTitleArray addObject:model.mainTitle];
            }
            [self.sectionOneArray addObject:model];
            
        }else if (model.tableSection == 1){
            if (model.tableIndex+1 > sectionTwoCount) {
                sectionTwoCount = model.tableIndex+1;
                [self.sectionTwoBooksTitleArray addObject:model.mainTitle];
            }
            [self.sectionTwoArray addObject:model];
        }
    }
    
    
    [self loadCustomView];

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
            if (self.sectionOneArray.count > 0) {
                PoetryConfigureModel *model = [self.sectionOneArray firstObject];
                sectionLabel.text = model.sectionTitle;
            }else{
                sectionLabel.text = @"";
            }
        }else if (section == 2){
            if (self.sectionTwoArray.count > 0) {
                PoetryConfigureModel *model = [self.sectionTwoArray firstObject];
                sectionLabel.text = model.sectionTitle;
            }else{
                sectionLabel.text = @"";
            }
            
        }
        
    }else{
        //如果无近期阅读记录，则年级、诗集
        if (section == 0){
            if (self.sectionOneArray.count > 0) {
                PoetryConfigureModel *model = [self.sectionOneArray firstObject];
                sectionLabel.text = model.sectionTitle;
            }else{
                sectionLabel.text = @"";
            }
            
        }else if (section == 1){
            if (self.sectionTwoArray.count > 0) {
                PoetryConfigureModel *model = [self.sectionTwoArray firstObject];
                sectionLabel.text = model.sectionTitle;
            }else{
                sectionLabel.text = @"";
            }
            
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
            return [WLGradeTypeCell heightForTypeCellWithCount:self.sectionOneBooksTitleArray.count];
        }else if (indexPath.section == 2){
            return [WLGradeTypeCell  heightForTypeCellWithCount:self.sectionTwoBooksTitleArray.count];
        }
    }else{
        if(indexPath.section == 0){
            return [WLGradeTypeCell heightForTypeCellWithCount:self.sectionOneBooksTitleArray.count];
        }else if (indexPath.section == 1){
            return [WLGradeTypeCell  heightForTypeCellWithCount:self.sectionTwoBooksTitleArray.count];
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
            NSDictionary *historyInfo = self.recentSectionArray[indexPath.row];
            NSString *mainTitle = [historyInfo objectForKey:@"mainTitle"];
            NSString *subTitle = [historyInfo objectForKey:@"subTitle"];
            NSString *mainClass = [historyInfo objectForKey:@"mainClass"];
            if ([mainClass isEqualToString:@"34"]||[mainClass isEqualToString:@"35"]||[mainClass isEqualToString:@"36"]) {
                cell.typeString = [NSString stringWithFormat:@"%@",subTitle];
            }else{
                cell.typeString = [NSString stringWithFormat:@"%@·%@",mainTitle,subTitle];
            }
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
    cell.booksArray = [self.sectionOneBooksTitleArray copy];
    [cell clickWithBlock:^(NSInteger index) {
        [self clickSectionOneWithIndex:index];
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
    cell.booksArray = [self.sectionTwoBooksTitleArray copy];
    [cell clickWithBlock:^(NSInteger index) {
        [self clickSectionTwoWithIndex:index];
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
            
            NSString *mainClass = [typeInfo objectForKey:@"mainClass"];
            if ([mainClass isEqualToString:@"34"]||[mainClass isEqualToString:@"35"]||[mainClass isEqualToString:@"36"]) {
                //论语进入的界面和普通界面不一样
                WLLunYuController *vc = [[WLLunYuController alloc]init];
                vc.titleForNavi =[typeInfo objectForKey:@"subTitle"];
                vc.mainClass = mainClass;
                [vc loadCustomData];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                //普通的诗词界面
                listVC.titleForNavi = [typeInfo objectForKey:@"subTitle"];
                listVC.mainClass = mainClass;
                [listVC loadCustomData];
                listVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:listVC animated:YES];
                
            }
            

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


- (void)clickSectionOneWithIndex:(NSInteger)index
{
    WLTypeListController *vc = [[WLTypeListController alloc]init];
    NSMutableArray *confDataArray = [NSMutableArray array];
    for (PoetryConfigureModel *model in self.sectionOneArray) {
        if (model.tableIndex == index) {
            [confDataArray addObject:model];
        }
    }
    
    vc.typeDataArray = confDataArray;
    [vc loadCustomView];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

    [vc loadLastSelectWithBlock:^(NSDictionary *info) {
        [self.recentSectionArray removeAllObjects];
        [self.recentSectionArray addObject:info];
        [self.mainTableView reloadData];
    }];
}

- (void)clickSectionTwoWithIndex:(NSInteger)index
{
    WLTypeListController *vc = [[WLTypeListController alloc]init];
    NSMutableArray *confDataArray = [NSMutableArray array];
    for (PoetryConfigureModel *model in self.sectionTwoArray) {
        if (model.tableIndex == index) {
            [confDataArray addObject:model];
        }
    }
    
    vc.typeDataArray = confDataArray;
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
