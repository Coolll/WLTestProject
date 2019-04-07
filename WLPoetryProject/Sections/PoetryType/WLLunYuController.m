//
//  WLLunYuController.m
//  WLPoetryProject
//
//  Created by 龙培 on 2019/4/5.
//  Copyright © 2019年 龙培. All rights reserved.
//

#import "WLLunYuController.h"
#import "WLCoreDataHelper.h"
#import "WLLunYuCell.h"
@interface WLLunYuController ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  论语列表
 **/
@property (nonatomic,strong) UITableView *mainTableView;
/**
 *  数据源
 **/
@property (nonatomic,copy) NSArray *contentArray;
/**
 *  是否已存入数据库的标示dic，如果首页没存入该数据，则需要把该数据读取出来，然后写入数据库。如果不修改标示，则首页会再次写入，导致本地数据库数据重复。
 **/
@property (nonatomic,strong) NSMutableDictionary *jsonStateDic;

@end

@implementation WLLunYuController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = ViewBackgroundColor;

}

- (void)loadCustomData
{

    self.contentArray = [NSArray arrayWithArray:[[WLCoreDataHelper shareHelper] fetchPoetryWithMainClass:self.mainClass]];
    
    if (self.contentArray.count == 0) {
        //如果本地数据库没有数据，则需要读取并存储到本地，为了避免与首页的处理重复，则这里同步更新状态dic
        NSDictionary *jsonStateLocalDic = [WLSaveLocalHelper loadObjectForKey:@"PoetryJsonStateDic"];
        self.jsonStateDic = [NSMutableDictionary dictionaryWithDictionary:jsonStateLocalDic];
        
        //从本地读取文件
        NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.jsonName ofType:@"json"]];
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
            model.poetryID = [NSString stringWithFormat:@"%ld",(long)([model.poetryID integerValue]+baseId)];
            [modelArray addObject:model];
        }
        
        
        //存储到本地数据库
        [[WLCoreDataHelper shareHelper]saveInBackgroundWithPeotryModelArray:modelArray withResult:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                //存储成功后读取然后展示
                [self fetchPoetryAndShowView];
                //存储成功后更新状态
                [self.jsonStateDic setObject:@"1" forKey:self.jsonName];
                [WLSaveLocalHelper saveObject:[self.jsonStateDic copy] forKey:@"PoetryJsonStateDic"];
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
        
        self.contentArray = [NSArray arrayWithArray:[[WLCoreDataHelper shareHelper] fetchPoetryWithMainClass:self.mainClass]];
        [self loadCustomView];
    });
    
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
#pragma mark - UITableView代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArray.count;
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
    
    PoetryModel *model = [self.contentArray objectAtIndex:indexPath.row];
    
    WLLunYuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WLLunYuCell"];;
    if (!cell) {
        cell = [[WLLunYuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WLLunYuCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    if (indexPath.row == self.contentArray.count-1) {
        cell.isLast = YES;
    }else{
        cell.isLast = NO;
    }
    
    cell.model = model;
    
    return cell;
    return [[UITableViewCell alloc]init];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
