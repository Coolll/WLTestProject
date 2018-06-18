//
//  YLHomeViewController.m
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/1.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import "YLHomeViewController.h"
#import "WLCoreDataHelper.h"
#import "PoetryModel.h"
#import "WLPoetryListCell.h"
#import "PoetryDetailViewController.h"

@interface YLHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

/**
 *  诗词列表
 **/
@property (nonatomic,strong) UITableView *mainTableView;
/**
 *  背景图片
 **/
@property (nonatomic,strong) UIImageView *mainBgView;


/**
 *  诗词数据源
 **/
@property (nonatomic,strong) NSArray *poetryArray;

/**
 *  高度数组
 **/
@property (nonatomic,strong) NSMutableArray *heightArray;
/**
 *  json是否读取的数组
 **/
@property (nonatomic,strong) NSMutableArray *jsonStateArr;



@end

@implementation YLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = ViewBackgroundColor;
    self.titleForNavi = @"随机推荐";
    [self loadCustomData];
    
    [self checkLocalData];//加载本地数据

}

- (void)loadCustomData
{
    self.heightArray = [NSMutableArray array];
    
    self.poetryArray = [[WLCoreDataHelper shareHelper] fetchPoetryWithMainClass:@"99"];

    if (self.poetryArray.count == 0) {
        //从本地读取文件
        NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"recommendPoetry" ofType:@"json"]];
        //转为dic
        NSDictionary *poetryDic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
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
    }
    
    
}

- (void)fetchPoetryAndShowView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.poetryArray = [[WLCoreDataHelper shareHelper] fetchPoetryWithMainClass:@"99"];
        [self loadCustomView];
    });
   
}

- (void)readSoure
{
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"file" ofType:@".txt"];
    NSString *testSource = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *poetryArr = [testSource componentsSeparatedByString:@"======"];
    
    NSMutableArray *modelArray = [NSMutableArray array];
    for (int i = 0; i<poetryArr.count; i++) {
        NSArray *items = [[NSString stringWithFormat:@"%@",[poetryArr objectAtIndex:i]] componentsSeparatedByString:@"&&&"];
        PoetryModel *model = [[PoetryModel alloc]init];
        model.name = [items objectAtIndex:0];
        model.author = [items objectAtIndex:1];
        model.content = [items objectAtIndex:2];
        [modelArray addObject:model];
    }
    
    [[WLCoreDataHelper shareHelper]saveInBackgroundWithPeotryModelArray:modelArray withResult:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            
            
        }
    }];
    
    self.poetryArray = [[WLCoreDataHelper shareHelper] fetchAllPoetry];
    
    [self loadCustomView];
    
}

#pragma mark - 加载视图
- (void)loadCustomView
{
    self.mainBgView.image = [UIImage imageNamed:@"mainBgImage.jpg"];
    
    self.mainTableView.backgroundColor = [UIColor clearColor];
    
    

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




#pragma mark - 后台进程，添加所有的数据
- (void)checkLocalData
{
    NSMutableArray *jsonList = [NSMutableArray array];
    [jsonList addObject:@"gradePoetry_1"];
    [jsonList addObject:@"gradePoetry_2"];
    [jsonList addObject:@"gradePoetry_3"];
    [jsonList addObject:@"gradePoetry_4"];
    [jsonList addObject:@"gradePoetry_5"];
    [jsonList addObject:@"gradePoetry_6"];
    [jsonList addObject:@"gradePoetry_7_one"];
    [jsonList addObject:@"gradePoetry_7_two"];
    [jsonList addObject:@"gradePoetry_8_one"];
    [jsonList addObject:@"gradePoetry_8_two"];
    [jsonList addObject:@"gradePoetry_9_one"];
    [jsonList addObject:@"gradePoetry_9_two"];
    [jsonList addObject:@"tangPoetry_one"];
    [jsonList addObject:@"tangPoetry_two"];
    [jsonList addObject:@"tangPoetry_three"];
    [jsonList addObject:@"tangPoetry_four"];
    [jsonList addObject:@"tangPoetry_five"];
    [jsonList addObject:@"tangPoetry_six"];
    [jsonList addObject:@"tangPoetry_seven"];
    [jsonList addObject:@"songPoetry_one"];
    [jsonList addObject:@"songPoetry_two"];
    [jsonList addObject:@"songPoetry_three"];
    [jsonList addObject:@"songPoetry_four"];
    [jsonList addObject:@"songPoetry_five"];
    [jsonList addObject:@"songPoetry_six"];
    [jsonList addObject:@"songPoetry_seven"];
    [jsonList addObject:@"songPoetry_eight"];
    [jsonList addObject:@"songPoetry_nine"];
    [jsonList addObject:@"songPoetry_ten"];
    
    NSArray *jsonStateArray = [WLSaveLocalHelper loadObjectForKey:@"PoetryJsonState"];
    self.jsonStateArr = [NSMutableArray array];
    
    if (jsonStateArray && [jsonStateArray isKindOfClass:[NSArray class]] && jsonStateArray.count == jsonList.count ) {
        
        self.jsonStateArr = [jsonStateArray mutableCopy];
        
        for (int i = 0; i < jsonStateArray.count ;i++) {
            NSString *state = jsonStateArray[i];
            int time = 4*i;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
                if (![state isEqualToString:@"1"]) {
                    [self readLocalFileWithName:jsonList[i] withIndex:i];
                }
                
            });
            
        }
        
    }else{
        
        for (int i =0 ; i < jsonList.count; i++) {
            [self.jsonStateArr addObject:@"0"];
            
        }
        
        for (int i = 0; i < self.jsonStateArr.count ;i++) {
            NSString *state = self.jsonStateArr[i];
            int time = 4*i;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
                if (![state isEqualToString:@"1"]) {
                                        [self readLocalFileWithName:jsonList[i] withIndex:i];
                }
                
            });
            
        }
        
        
        
    }
}

- (void)readLocalFileWithName:(NSString*)fileName withIndex:(NSInteger)jsonIndex
{
    //从本地读取文件
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"json"]];
    //转为dic
    NSDictionary *poetryDic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    NSInteger baseId = [[NSString stringWithFormat:@"%@",[poetryDic objectForKey:@"baseID"]]integerValue];
    
    //获取到诗词列表
    NSArray *poetryArr = [poetryDic objectForKey:@"poetryList"];
    NSString *poetryMainClass = [poetryDic objectForKey:@"mainClass"];
    
    NSMutableArray *modelArray = [NSMutableArray array];
    //将诗词model化
    for (int i = 0; i<poetryArr.count; i++) {
        NSDictionary *itemDic = [poetryArr objectAtIndex:i];
        PoetryModel *model = [[PoetryModel alloc]initModelWithDictionary:itemDic];
        model.mainClass = poetryMainClass;
        model.poetryID = [NSString stringWithFormat:@"%ld",[model.poetryID integerValue]+baseId];
        [modelArray addObject:model];
    }
    
    //存储到本地数据库
    [[WLCoreDataHelper shareHelper]saveInBackgroundWithPeotryModelArray:modelArray withResult:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //存储成功后更新状态
            [self.jsonStateArr replaceObjectAtIndex:jsonIndex withObject:@"1"];
            [WLSaveLocalHelper saveObject:[self.jsonStateArr copy] forKey:@"PoetryJsonState"];
            
        }
    }];
    
}

- (UIImageView*)mainBgView
{
    if (!_mainBgView) {
        _mainBgView = [[UIImageView alloc]init];
        _mainBgView.alpha = 0.5;
        _mainBgView.contentMode = UIViewContentModeScaleAspectFill;
        _mainBgView.clipsToBounds = YES;
        [self.view addSubview:_mainBgView];
        //元素的布局
        [_mainBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view.mas_left).offset(0);
            make.top.equalTo(self.naviView.mas_bottom).offset(0);
            make.bottom.equalTo(self.view.mas_bottom).offset(-49);
            make.right.equalTo(self.view.mas_right).offset(0);
            
        }];
    }
    return _mainBgView;
}

- (UITableView*)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]init];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_mainTableView];
        
//        if (@available(iOS 11.0, *)) {
//            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        }else {
//            self.automaticallyAdjustsScrollViewInsets = NO;
//        }
        //元素的布局
        [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view.mas_left).offset(0);
            make.top.equalTo(self.naviView.mas_bottom).offset(0);
            make.bottom.equalTo(self.view.mas_bottom).offset(-49);
            make.right.equalTo(self.view.mas_right).offset(0);
            
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
