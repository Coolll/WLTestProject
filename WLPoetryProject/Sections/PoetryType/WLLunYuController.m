//
//  WLLunYuController.m
//  WLPoetryProject
//
//  Created by 龙培 on 2019/4/5.
//  Copyright © 2019年 龙培. All rights reserved.
//

#import "WLLunYuController.h"
#import "WLLunYuCell.h"
@interface WLLunYuController ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  论语列表
 **/
@property (nonatomic,strong) UITableView *mainTableView;
/**
 *  数据源
 **/
@property (nonatomic,strong) NSMutableArray *contentArray;
/**
 *  状态源
 **/
@property (nonatomic,strong) NSMutableArray *stateArray;

/**
 *  状态源
 **/
@property (nonatomic,strong) NSMutableArray *heigthArray;
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

    self.contentArray = [NSMutableArray array];
    self.stateArray = [NSMutableArray array];
    self.heigthArray = [NSMutableArray array];
    
    [[NetworkHelper shareHelper]requestPoetryWithMainClass:self.mainClass withCompletion:^(BOOL success, NSDictionary *dic, NSError *error) {
        
        if (success) {
            
            NSString *code = [NSString stringWithFormat:@"%@",[dic objectForKey:@"retCode"]];
            if (![code isEqualToString:@"1000"]) {
                NSString *tipMessage = [dic objectForKey:@"message"];
                [self showHUDWithText:tipMessage];
                return ;
            }
            
            NSArray *dataArr = [dic objectForKey:@"data"];
            for (NSDictionary *poetryDic in dataArr) {
                PoetryModel *model = [[PoetryModel alloc]initPoetryWithDictionary:poetryDic];
                [self.contentArray addObject:model];
            }
            
            for (int i=0; i<self.contentArray.count; i++) {
                [self.stateArray addObject:@"0"];
            }
            
            [self updateCellHeightWithIndex:0];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //直接展示数据
                [self loadCustomView];
            });
            
        }else{
            [self showHUDWithText:@"请求失败，请稍后重试"];
        }
        
    }];
    
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
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
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
    CGFloat cellHeight = [[self.heigthArray objectAtIndex:indexPath.row] floatValue];
    if (cellHeight > 0) {
        return cellHeight;
    }
    return 0.01;
    
}


- (void)updateCellHeightWithIndex:(NSInteger)index
{
    if (!self.heigthArray) {
        self.heigthArray = [NSMutableArray array];
    }
    
    if (self.heigthArray.count == 0) {
        for (PoetryModel *model in self.contentArray) {
            CGFloat cellHeight = [WLLunYuCell heightForCellWithModel:model isShow:NO];
            [self.heigthArray addObject:[NSString stringWithFormat:@"%f",cellHeight]];
        }
    }
    
    PoetryModel *poetryModel = [self.contentArray objectAtIndex:index];
    NSString *state = [self.stateArray objectAtIndex:index];
    if ([state isEqualToString:@"0"]) {
        CGFloat cellHeight = [WLLunYuCell heightForCellWithModel:poetryModel isShow:NO];
        [self.heigthArray replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%f",cellHeight]];

    }else{
        CGFloat cellHeight = [WLLunYuCell heightForCellWithModel:poetryModel isShow:YES];
        [self.heigthArray replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%f",cellHeight]];
    }
    
    
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PoetryModel *model = [self.contentArray objectAtIndex:indexPath.row];
    
    WLLunYuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WLLunYuCell"];;
    if (!cell) {
        cell = [[WLLunYuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WLLunYuCell"];
        [cell loadCellContent];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    if (indexPath.row == self.contentArray.count-1) {
        cell.isLast = YES;
    }else{
        cell.isLast = NO;
    }
    
    NSString *state = [self.stateArray objectAtIndex:indexPath.row];
    
    if ([state isEqualToString:@"0"]) {
        cell.showTransfer = NO;
    }else{
        cell.showTransfer = YES;
    }
    
    cell.model = model;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *stateString = [self.stateArray objectAtIndex:indexPath.row];
    if ([stateString isEqualToString:@"0"]) {
        [self.stateArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
    }else{
        [self.stateArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
    }
    
    [self updateCellHeightWithIndex:indexPath.row];
    
    [self.mainTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
