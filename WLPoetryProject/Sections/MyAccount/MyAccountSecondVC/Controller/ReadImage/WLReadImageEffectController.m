//
//  WLReadImageController.m
//  WLPoetryProject
//
//  Created by 龙培 on 2020/10/13.
//  Copyright © 2020 龙培. All rights reserved.
//

#import "WLReadImageEffectController.h"
#import "WLReadEffectCell.h"
#import "WLReadEffectPreviewController.h"
@interface WLReadImageEffectController ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  数据
 **/
@property (nonatomic, strong) UITableView *mainTableView;
/**
 *  元素数组
 **/
@property (nonatomic,strong) NSArray *itemsArray;

/**
 *  图片数组
 **/
@property (nonatomic,strong) NSArray *imageArray;
/**
 *  是否打开特效开关
 **/
@property (nonatomic,assign) BOOL openEffect;
@end

@implementation WLReadImageEffectController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewBackgroundColor;
    self.titleForNavi = @"阅读特效";
    [self loadCustomData];
    [self loadCustomView];
}
- (void)loadCustomData
{
    self.itemsArray = [NSArray arrayWithObjects:@"雪花",@"樱花",@"枫叶",@"梅花",@"细雨",@"流星", nil];
}

#pragma mark - 加载视图
- (void)loadCustomView
{
    self.mainTableView = [[UITableView alloc]init];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.backgroundColor = ViewBackgroundColor;
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
        return self.itemsArray.count;
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
    if (section == 0) {
        return 0.01;
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, PhoneScreen_WIDTH, 20)];
    headerView.backgroundColor = ViewBackgroundColor;
    return headerView;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WLReadEffectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WLReadEffectCell"];
    
    if (!cell) {
        cell = [[WLReadEffectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WLReadEffectCell"];
        cell.frame = CGRectMake(0, 0, PhoneScreen_WIDTH, 50);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 0 && indexPath.row < self.itemsArray.count) {
        cell.titleString = self.itemsArray[indexPath.row];
        cell.rightArrow.hidden = NO;//正常情况下，需要右侧箭头
    }
    
    if (indexPath.row == self.itemsArray.count-1) {
        cell.showLine = NO;//最后一行，不需要横线
    }else{
        cell.showLine = YES;
    }
   
    [cell loadCustomView];
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0 && indexPath.section == 0) {
        NSLog(@"雪花");
        [self chooseEffect:@"snow"];
    }else if (indexPath.row == 1 && indexPath.section == 0){
        NSLog(@"樱花");
        [self chooseEffect:@"flower"];
    }else if (indexPath.row == 2 && indexPath.section == 0){
        NSLog(@"枫叶");
        [self chooseEffect:@"mapleLeaf"];
    }else if (indexPath.row == 3 && indexPath.section == 0){
        NSLog(@"梅花");
        [self chooseEffect:@"plum"];
    }else if (indexPath.row == 4 && indexPath.section == 0){
        NSLog(@"细雨");
        [self chooseEffect:@"rain"];
    }else if (indexPath.row == 5 && indexPath.section == 0){
        NSLog(@"流星");
        [self chooseEffect:@"meteor"];
    }
}


- (void)chooseEffect:(NSString*)type{
    WLReadEffectPreviewController *vc = [[WLReadEffectPreviewController alloc]init];
    vc.effectType = type;
    [vc configureUI];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)resetImage{
    [WLSaveLocalHelper saveReadImageURLOrBackgroundRGB:@""];
    [self showHUDWithText:@"恢复成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });

}
#pragma mark - 返回
- (void)backAction:(UIButton*)sender
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

