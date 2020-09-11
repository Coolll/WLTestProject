//
//  WLHeaderImageController.m
//  WLPoetryProject
//
//  Created by 龙培 on 2020/6/8.
//  Copyright © 2020年 龙培. All rights reserved.
//

#import "WLHeaderImageController.h"
#import "WLHeadImageSelectCell.h"
@interface WLHeaderImageController ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  完成设置的回调
 **/
@property (nonatomic,copy) HeaderImageBlock finishBlock;

/**
 *  本地的原始图片 3张
 **/
@property (nonatomic,copy) NSArray *localImageArray;

/**
 *  网络请求到的图片
 **/
@property (nonatomic,strong) NSMutableArray *networkImageArray;

/**
 *  头像列表
 **/
@property (nonatomic,strong) UITableView *mainTableView;


@end

@implementation WLHeaderImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleForNavi = @"设置头像";
    self.view.backgroundColor = ViewBackgroundColor;
    [self loadCustomData];
}

- (void)loadCustomData{
    self.localImageArray = [NSArray arrayWithObjects:@"defaultHeader",@"my_head_image_man",@"my_head_image_woman", nil];
    self.networkImageArray = [NSMutableArray array];
    __weak __typeof(self)weakSelf = self;
    [[AppConfig config] loadAllHeadImageWithBlock:^(NSArray *originArray, NSArray *thumbArray, NSError *error) {
        
        NSLog(@"原始图片:%@",originArray);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf dealImageData:originArray thumbArray:thumbArray];
    }];
    
}

- (void)dealImageData:(NSArray*)originArray thumbArray:(NSArray*)thumbArray{
    [self.networkImageArray addObjectsFromArray:self.localImageArray];
    [self.networkImageArray addObjectsFromArray:thumbArray];
    [self.mainTableView reloadData];
}


- (void)finishSettingWithBlock:(HeaderImageBlock)block{
    if (block) {
        self.finishBlock = block;
    }
}


#pragma mark - table代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.networkImageArray.count/3);
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
    if (section == 0) {
        return 0.01;
    }else if(section == 1){
        return 30;
    }
    return 15;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWith = (PhoneScreen_WIDTH-60)/3;
    return itemWith+20;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    WLHeadImageSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WLHeadImageSelectCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger baseIndex = row*3;
    if (baseIndex < self.networkImageArray.count) {
        cell.oneImageUrlString = [self.networkImageArray objectAtIndex:baseIndex];
    }
    
    if ((baseIndex+1) < self.networkImageArray.count) {
        cell.twoImageUrlString = [self.networkImageArray objectAtIndex:(baseIndex+1)];
    }
    
    if ((baseIndex+2) < self.networkImageArray.count) {
        cell.threeImageUrlString = [self.networkImageArray objectAtIndex:(baseIndex+2)];
    }

    if (row == 0) {
        cell.isLocalImage = YES;
    }else{
        cell.isLocalImage = NO;
    }
    [cell loadCustomCell];
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableView*)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.estimatedRowHeight = 0;
        _mainTableView.estimatedSectionFooterHeight = 0;
        _mainTableView.estimatedSectionHeaderHeight = 0;
        [_mainTableView registerClass:[WLHeadImageSelectCell class] forCellReuseIdentifier:@"WLHeadImageSelectCell"];
        [self.view addSubview:_mainTableView];
        
        
        //元素的布局
        [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.view.mas_leading).offset(0);
            make.top.equalTo(self.naviView.mas_bottom).offset(0);
            make.bottom.equalTo(self.view.mas_bottom).offset(-49);
            make.trailing.equalTo(self.view.mas_trailing).offset(0);
        }];
    }
    return _mainTableView;
}

@end
