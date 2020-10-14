//
//  WLReadImageController.m
//  WLPoetryProject
//
//  Created by 龙培 on 2020/10/13.
//  Copyright © 2020 龙培. All rights reserved.
//

#import "WLReadImageController.h"
#import "WLReadImageCell.h"
#import "WLReadImageListController.h"
#import "WLReadImageColorController.h"
@interface WLReadImageController ()<UITableViewDelegate,UITableViewDataSource>
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

@end

@implementation WLReadImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewBackgroundColor;
    self.titleForNavi = @"阅读背景";
    [self loadCustomData];
    [self loadCustomView];
}
- (void)loadCustomData
{
    self.itemsArray = [NSArray arrayWithObjects:@"选择图片背景",@"选择纯色背景", nil];
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
        return 2;
    }
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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
    WLReadImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WLReadImageCell"];
    
    if (!cell) {
        cell = [[WLReadImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WLReadImageCell"];
        cell.frame = CGRectMake(0, 0, PhoneScreen_WIDTH, 50);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 0 && indexPath.row < self.itemsArray.count) {
        cell.titleString = self.itemsArray[indexPath.row];
        
    }else if (indexPath.section == 1){
        
        cell.titleString = @"恢复默认背景";
    }
    
    if (indexPath.row == self.itemsArray.count-1) {
        cell.showLine = NO;//最后一行，不需要横线
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.showLine = NO;//恢复默认背景图，不需要横线，因为是独立的一行
        cell.rightArrow.hidden = YES;
    }
    
   
    
    [cell loadCustomView];
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0 && indexPath.section == 0) {
        NSLog(@"选择背景图");
        [self chooseImage];
    }else if (indexPath.row == 1 && indexPath.section == 0){
        NSLog(@"设置背景色");
        [self chooseColor];
    }else if (indexPath.row == 0 && indexPath.section == 1){
        NSLog(@"恢复默认");
        [self resetImage];
    }
}

- (void)chooseImage{
    WLReadImageListController *vc = [[WLReadImageListController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)chooseColor{
    WLReadImageColorController *vc = [[WLReadImageColorController alloc]init];
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
