//
//  WLPoetryListController.m
//  WLPoetryProject
//
//  Created by 龙培 on 2018/5/7.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLPoetryListController.h"
#import "WLCoreDataHelper.h"
#import "PoetryModel.h"
#import "WLPoetryListCell.h"
#import "PoetryDetailViewController.h"

@interface WLPoetryListController ()<UITableViewDataSource,UITableViewDelegate>
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
@end

@implementation WLPoetryListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)setSource:(PoetrySource)source
{
    _source = source;
    switch (source) {
        case PoetrySourceGradeOne:
        {
            
            self.titleForNavi = @"小学一年级";

            [self loadCustomData];
        }
            break;
            
        default:
            break;
    }
}
- (void)loadCustomData
{
    self.heightArray = [NSMutableArray array];
    
    self.poetryArray = [[WLCoreDataHelper shareHelper] fetchPoetryWithMainClass:@"1"];
    
    if (self.poetryArray.count == 0) {
        //从本地读取文件
        NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"gradePoetry_1" ofType:@"json"]];
        //转为dic
        NSDictionary *poetryDic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
        //        NSLog(@"dic:%@",poetryDic);
        //获取到诗词列表
        NSArray *poetryArr = [poetryDic objectForKey:@"poetryList"];
        NSString *poetryMainClass = [poetryDic objectForKey:@"mainClass"];
        
        NSMutableArray *modelArray = [NSMutableArray array];
        //将诗词model化
        for (int i = 0; i<poetryArr.count; i++) {
            NSDictionary *itemDic = [poetryArr objectAtIndex:i];
            PoetryModel *model = [[PoetryModel alloc]initModelWithDictionary:itemDic];
            model.mainClass = poetryMainClass;
            [modelArray addObject:model];
        }
        
        //存储到本地数据库
        [[WLCoreDataHelper shareHelper]saveInBackgroundWithPeotryModelArray:modelArray withResult:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                //存储成功后读取然后展示
                [self fetchPoetryAndShowView];
                
            }
        }];
    }else{
        
        //直接展示数据
        [self loadCustomView];
        //        [[WLCoreDataHelper shareHelper] deleteAllPoetry];
    }
    
    
    
}

- (void)fetchPoetryAndShowView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.poetryArray = [[WLCoreDataHelper shareHelper] fetchPoetryWithMainClass:@"1"];
        [self loadCustomView];
    });
    
}



#pragma mark - 加载视图
- (void)loadCustomView
{
    UIImageView *mainBgView = [[UIImageView alloc]init];
    mainBgView.image = [UIImage imageNamed:@"mainBgImage"];
    [self.view addSubview:mainBgView];
    //元素的布局
    [mainBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.naviView.mas_bottom).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
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
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
        make.right.equalTo(self.view.mas_right).offset(0);
        
    }];
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
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
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