//
//  WLPoetryTypeController.m
//  WLPoetryProject
//
//  Created by 龙培 on 2018/5/7.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLPoetryTypeController.h"
#import "WLPoetryListController.h"
#import "WLSearchController.h"
#import "WLTypeListCell.h"

@interface WLPoetryTypeController ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  诗词列表
 **/
@property (nonatomic,strong) UITableView *mainTableView;

/**
 *  年级 诗词数据源
 **/
@property (nonatomic,strong) NSMutableArray *gradeSectionArray;
/**
 *  唐诗 诗词数据源
 **/
@property (nonatomic,strong) NSMutableArray *tangSectionArray;
/**
 *  宋词 诗词数据源
 **/
@property (nonatomic,strong) NSMutableArray *songSectionArray;
/**
 *  近期阅读的 诗词数据源
 **/
@property (nonatomic,strong) NSMutableArray *recentSectionArray;

@end

@implementation WLPoetryTypeController

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
        make.right.equalTo(self.naviView.mas_right).offset(-25);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
        
    }];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor clearColor]];
    [self.naviView addSubview:btn];
    //元素的布局
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(searchImage.mas_left).offset(-10);
        make.top.equalTo(searchImage.mas_top).offset(-10);
        make.bottom.equalTo(self.naviView.mas_bottom).offset(0);
        make.right.equalTo(self.naviView.mas_right).offset(0);
        
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

    NSArray *recentList = [WLSaveLocalHelper loadObjectForKey:@"recentSelectTypeList"];
    if (!recentList) {
        [WLSaveLocalHelper saveObject:[NSArray array] forKey:@"recentSelectTypeList"];
    }else{
        self.recentSectionArray = [recentList mutableCopy];
    }
    
    [self readConfigureGrade];
    [self readConfigureTang];
    [self readConfigureSong];
}

- (void)readConfigureGrade
{
    //从本地读取文件
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"configureGrade" ofType:@"json"]];
    //转为dic
    NSDictionary *configureData = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    
    //获取到年级的配置列表
    NSArray *gradeArray = [configureData objectForKey:@"dataList"];
    self.gradeSectionArray = [NSMutableArray arrayWithArray:gradeArray];
}

- (void)readConfigureTang
{
    //从本地读取文件
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"configureTang" ofType:@"json"]];
    //转为dic
    NSDictionary *configureData = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    
    //获取到年级的配置列表
    NSArray *gradeArray = [configureData objectForKey:@"dataList"];
    self.tangSectionArray = [NSMutableArray arrayWithArray:gradeArray];
}

- (void)readConfigureSong
{
    //从本地读取文件
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"configureSong" ofType:@"json"]];
    //转为dic
    NSDictionary *configureData = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    
    //获取到年级的配置列表
    NSArray *gradeArray = [configureData objectForKey:@"dataList"];
    self.songSectionArray = [NSMutableArray arrayWithArray:gradeArray];
}

#pragma mark - 加载视图
- (void)loadCustomView
{
//    UIImageView *mainBgView = [[UIImageView alloc]init];
//    mainBgView.image = [UIImage imageNamed:@"mainBgImage"];
//    [self.view addSubview:mainBgView];
//    //元素的布局
//    [mainBgView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(self.view.mas_left).offset(0);
//        make.top.equalTo(self.naviView.mas_bottom).offset(0);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
//        make.right.equalTo(self.view.mas_right).offset(0);
//
//    }];
    
    self.mainTableView = [[UITableView alloc]init];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.backgroundColor = [UIColor clearColor];
    self.mainTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.mainTableView];
    
    //元素的布局
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.naviView.mas_bottom).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
        make.right.equalTo(self.view.mas_right).offset(0);
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.recentSectionArray && self.recentSectionArray.count > 0) {
        
        //如果近期阅读过，则把近期看的放在首位
        if (section == 0) {
            return self.recentSectionArray.count;
            
        }else if (section == 1){
            return self.gradeSectionArray.count;
            
        }else if (section == 2){
            return self.tangSectionArray.count;

        }else if (section == 3){
            return self.songSectionArray.count;

        }
    }else{
        //如果无近期阅读记录，则年级、唐诗、宋词
        if (section == 0) {
            return self.gradeSectionArray.count;
            
        }else if (section == 1){
            return self.tangSectionArray.count;
            
        }else if (section == 2){
            return self.songSectionArray.count;
            
        }
        
    }
    
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.recentSectionArray && self.recentSectionArray.count > 0) {
        return 4;//近期、年级、唐诗、宋词
    }else{
        return 3;//年级、唐诗、宋词
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
        
        //如果近期阅读过，则把近期看的放在首位，然后年级、唐诗、宋词
        if (section == 0) {
            sectionLabel.text = @"推荐";
        }else if (section ==1) {
            sectionLabel.text = @"年级";
        }else if (section == 2){
            sectionLabel.text = @"唐诗";
        }else if (section == 3){
            sectionLabel.text = @"宋词";
        }
        
    }else{
        //如果无近期阅读记录，则年级、唐诗、宋词

        if (section ==0) {
            sectionLabel.text = @"年级";
        }else if (section == 1){
            sectionLabel.text = @"唐诗";
        }else if (section == 2){
            sectionLabel.text = @"宋词";
        }
    }
    
    
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WLTypeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WLTypeListCell"];;
    if (!cell) {
        cell = [[WLTypeListCell alloc]init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    NSInteger section = indexPath.section;
    if (self.recentSectionArray && self.recentSectionArray.count > 0) {
        //近期、年级、唐诗、宋词
        if (section == 0) {
            cell.typeString = [self.recentSectionArray[indexPath.row] objectForKey:@"mainTitle"];
        }else if (section == 1){
            cell.typeString = [self.gradeSectionArray[indexPath.row] objectForKey:@"mainTitle"];

        }else if (section == 2){
            cell.typeString = [self.tangSectionArray[indexPath.row]objectForKey:@"mainTitle"];

        }else if (section == 3){
            cell.typeString = [self.songSectionArray[indexPath.row]objectForKey:@"mainTitle"];

        }
        
    }else{
        //年级、唐诗、宋词
        if (section == 0){
            cell.typeString = [self.gradeSectionArray[indexPath.row]objectForKey:@"mainTitle"];
            
        }else if (section == 1){
            cell.typeString = [self.tangSectionArray[indexPath.row]objectForKey:@"mainTitle"];
            
        }else if (section == 2){
            cell.typeString = [self.songSectionArray[indexPath.row]objectForKey:@"mainTitle"];
            
        }
    }
    
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
        }else if (section == 1){
            typeInfo = self.gradeSectionArray[indexPath.row];

        }else if (section == 2){
            typeInfo = self.tangSectionArray[indexPath.row];

        }else if (section == 3){
            typeInfo = self.songSectionArray[indexPath.row];

        }

    }else{
        //年级、唐诗、宋词
        if (section == 0){
            typeInfo = self.gradeSectionArray[indexPath.row];

        }else if (section == 1){
            typeInfo = self.tangSectionArray[indexPath.row];

        }else if (section == 2){
            typeInfo = self.songSectionArray[indexPath.row];

        }
    }

    
    listVC.titleForNavi = [typeInfo objectForKey:@"subTitle"];
    listVC.jsonName = [typeInfo objectForKey:@"jsonName"];
    listVC.mainClass = [typeInfo objectForKey:@"mainClass"];
    [listVC loadCustomData];
    listVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:listVC animated:YES];
    
    //近期浏览的 超过三个，则移除掉最先访问的，把最近访问的放在前面
    [self.recentSectionArray insertObject:typeInfo atIndex:0];
    
    if (self.recentSectionArray.count >3) {
        [self.recentSectionArray removeLastObject];
    }
    
    //更新到本地
    [WLSaveLocalHelper saveObject:[self.recentSectionArray copy] forKey:@"recentSelectTypeList"];
    [self.mainTableView reloadData];
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
