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





@end

@implementation WLPoetryListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)loadCustomData
{
    
    self.poetryArray = [NSArray arrayWithArray:[[WLCoreDataHelper shareHelper] fetchPoetryWithMainClass:self.mainClass]];
    
    if (self.poetryArray.count == 0) {
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
        
        self.poetryArray = [NSArray arrayWithArray:[[WLCoreDataHelper shareHelper] fetchPoetryWithMainClass:self.mainClass]];
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
    self.mainTableView.backgroundColor = RGBCOLOR(246, 246, 246, 1.0);
    [self.view addSubview:self.mainTableView];
    
    //元素的布局
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.view.mas_leading).offset(0);
        make.top.equalTo(self.naviView.mas_bottom).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.trailing.equalTo(self.view.mas_trailing).offset(0);
        
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


        if (self.poetryArray.count > indexPath.row) {
            PoetryModel *model = [self.poetryArray objectAtIndex:indexPath.row];
            
            //如果有缓存的高度，则不计算了
            if (model.heightForCell > 0) {
                return model.heightForCell;
            }
            
            //没有缓存的高度，则需要计算
            if (indexPath.row == self.poetryArray.count-1) {
                //最后一行需要调整一下间距
                CGFloat cellHeight = [WLPoetryListCell heightForLastCell:[self.poetryArray objectAtIndex:indexPath.row]];
                model.heightForCell = cellHeight;

                return cellHeight;
            }else{
                CGFloat cellHeight = [WLPoetryListCell heightForFirstLine:[self.poetryArray objectAtIndex:indexPath.row]];
                model.heightForCell = cellHeight;
                NSLog(@"row:%ld 高度：%f",indexPath.row,cellHeight);
                return cellHeight;
            }
            
            
        }
    
    return 0.001;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PoetryModel *model = [self.poetryArray objectAtIndex:indexPath.row];
    
    WLPoetryListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WLPoetryListCell"];;
    if (!cell) {
        cell = [[WLPoetryListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WLPoetryListCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    if (indexPath.row == self.poetryArray.count-1) {
        cell.isLast = YES;
    }else{
        cell.isLast = NO;
    }
    
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
