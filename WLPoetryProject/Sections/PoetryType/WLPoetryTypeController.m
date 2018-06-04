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

@interface WLPoetryTypeController ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  诗词列表
 **/
@property (nonatomic,strong) UITableView *mainTableView;

/**
 *  诗词数据源
 **/
@property (nonatomic,strong) NSMutableArray *typeSectionArray;
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
    self.typeSectionArray = [NSMutableArray array];
    [self.typeSectionArray addObject:@"一年级"];
    [self.typeSectionArray addObject:@"二年级"];
    [self.typeSectionArray addObject:@"三年级"];
    [self.typeSectionArray addObject:@"四年级"];
    [self.typeSectionArray addObject:@"五年级"];
    [self.typeSectionArray addObject:@"六年级"];
    [self.typeSectionArray addObject:@"七年级上"];
    [self.typeSectionArray addObject:@"七年级下"];
    [self.typeSectionArray addObject:@"八年级上"];
    [self.typeSectionArray addObject:@"八年级下"];
    [self.typeSectionArray addObject:@"九年级上"];
    [self.typeSectionArray addObject:@"九年级下"];
    [self.typeSectionArray addObject:@"唐诗·一"];
    [self.typeSectionArray addObject:@"唐诗·二"];
    [self.typeSectionArray addObject:@"唐诗·三"];
    [self.typeSectionArray addObject:@"唐诗·四"];
    [self.typeSectionArray addObject:@"唐诗·五"];
    [self.typeSectionArray addObject:@"唐诗·六"];
    [self.typeSectionArray addObject:@"唐诗·七"];
    [self.typeSectionArray addObject:@"宋词·一"];
    [self.typeSectionArray addObject:@"宋词·二"];
    [self.typeSectionArray addObject:@"宋词·三"];
    [self.typeSectionArray addObject:@"宋词·四"];
    [self.typeSectionArray addObject:@"宋词·五"];
    [self.typeSectionArray addObject:@"宋词·六"];
    [self.typeSectionArray addObject:@"宋词·七"];
    [self.typeSectionArray addObject:@"宋词·八"];
    [self.typeSectionArray addObject:@"宋词·九"];
    [self.typeSectionArray addObject:@"宋词·十"];

}

#pragma mark - 加载视图
- (void)loadCustomView
{
    UIImageView *mainBgView = [[UIImageView alloc]init];
    mainBgView.image = [UIImage imageNamed:@"mainBgImage"];
//    [self.view addSubview:mainBgView];
    //元素的布局
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
    if (section == 0) {
        return self.typeSectionArray.count;
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
    
    
    return 80;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WLPoetryTypeCell"];;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, PhoneScreen_WIDTH, 80)];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.typeSectionArray[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.typeSectionArray.count) {
        
        WLPoetryListController *listVC = [[WLPoetryListController alloc]init];
        listVC.source = [self dealSourceWithIndex:indexPath.row];
        listVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:listVC animated:YES];
    }
}

- (PoetrySource)dealSourceWithIndex:(NSInteger)index
{
    if (index == 0) {
        return PoetrySourceGradeOne;
    }else if (index == 1){
        return PoetrySourceGradeTwo;
    }else if (index == 2){
        return PoetrySourceGradeThree;
    }else if (index == 3){
        return PoetrySourceGradeFour;
    }else if (index == 4){
        return PoetrySourceGradeFive;
    }else if (index == 5){
        return PoetrySourceGradeSix;
    }else if (index == 6){
        return PoetrySourceGradeSevenOne;
    }else if (index == 7){
        return PoetrySourceGradeSevenTwo;
    }else if (index == 8){
        return PoetrySourceGradeEightOne;
    }else if (index == 9){
        return PoetrySourceGradeEightTwo;
    }else if (index == 10){
        return PoetrySourceGradeNineOne;
    }else if (index == 11){
        return PoetrySourceGradeNineTwo;
    }else if (index == 12){
        return PoetrySourceTangOne;
    }else if (index == 13){
        return PoetrySourceTangTwo;
    }else if (index == 14){
        return PoetrySourceTangThree;
    }else if (index == 15){
        return PoetrySourceTangFour;
    }else if (index == 16){
        return PoetrySourceTangFive;
    }else if (index == 17){
        return PoetrySourceTangSix;
    }else if (index == 18){
        return PoetrySourceTangSeven;
    }else if (index == 19){
        return PoetrySourceSongOne;
    }else if (index == 20){
        return PoetrySourceSongTwo;
    }else if (index == 21){
        return PoetrySourceSongThree;
    }else if (index == 22){
        return PoetrySourceSongFour;
    }else if (index == 23){
        return PoetrySourceSongFive;
    }else if (index == 24){
        return PoetrySourceSongSix;
    }else if (index == 25){
        return PoetrySourceSongSeven;
    }else if (index == 26){
        return PoetrySourceSongEight;
    }else if (index == 27){
        return PoetrySourceSongNine;
    }else if (index == 28){
        return PoetrySourceSongTen;
    }
    return PoetrySourceRecommend;
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
