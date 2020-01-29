//
//  WLSettingController.m
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/6/16.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLSettingController.h"
#import "WLSettingCell.h"
#import "WLFontController.h"
#import "WLFeedbackController.h"

@interface WLSettingController ()<UITableViewDelegate,UITableViewDataSource>
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
 *  回调的block
 **/
@property (nonatomic, copy) SettingBlock block;
/**
 *  文件大小
 **/
@property (nonatomic,assign) float countFileSize;
@end

@implementation WLSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleForNavi = @"设置";

    [self loadCustomData];
    [self loadCustomView];
}

- (void)loadCustomData
{
    self.itemsArray = [NSArray arrayWithObjects:@"权限设置",@"字体大小",@"空间清理",@"意见反馈", nil];
    self.imageArray = [NSArray arrayWithObjects:@"help",@"setting",@"about",@"contact",nil];
    self.countFileSize = [self countTheDisk];
}

- (void)refreshLoginState:(SettingBlock)block
{
    if (block) {
        self.block = block;
    }
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
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, PhoneScreen_WIDTH, 20)];
    headerView.backgroundColor = ViewBackgroundColor;
    return headerView;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WLSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WLSettingCell"];
    
    if (!cell) {
        
        cell = [[WLSettingCell alloc]initWithFrame:CGRectMake(0, 0, PhoneScreen_WIDTH, 50)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    if (indexPath.section == 0 && indexPath.row < self.itemsArray.count) {
        cell.titleString = self.itemsArray[indexPath.row];
        
        if (indexPath.row == 2) {
            cell.needRight = YES;
            cell.rightLabel.text = [NSString stringWithFormat:@"共%.2fM",self.countFileSize];
        }
    }else if (indexPath.section == 1){
        
        cell.titleString = @"退出登录";
        cell.titleLabel.textAlignment = NSTextAlignmentCenter;
        cell.rightArrow.hidden = YES;
    }
    
    if (indexPath.row == self.itemsArray.count-1) {
        cell.showLine = NO;//最后一行，不需要横线
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.showLine = NO;//退出登录，不需要横线，因为是独立的一行
    }
    
    [cell loadCustomView];
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //权限设置
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                } else {
                    // Fallback on earlier versions
                    [[UIApplication sharedApplication] openURL:url];

                }
            }
        }else if (indexPath.row == 1) {
            //调整字体
            WLFontController *fontVC = [[WLFontController alloc]init];
            [self.navigationController pushViewController:fontVC animated:YES];
            
        }else if(indexPath.row == 2){
            //空间清理
            [self cleanTheDisk];
        }else if (indexPath.row == 3){
            //意见反馈
            WLFeedbackController *feedVc = [[WLFeedbackController alloc]init];
            [self.navigationController pushViewController:feedVc animated:YES];
        }
    }
    
    if (indexPath.section == 1) {
        //退出登录
        
        [[NetworkHelper shareHelper] logoutWithUserID:kUserID withCompletion:^(BOOL success, NSDictionary *dic, NSError *error) {
            if (success) {
                
                NSString *code = [NSString stringWithFormat:@"%@",[dic objectForKey:@"retCode"]];
                if (![code isEqualToString:@"1000"]) {
                    NSString *tipMessage = [dic objectForKey:@"message"];
                    [self showHUDWithText:tipMessage];
                    return ;
                }
                
                if (self.block) {
                    self.block(NO);
                }
                [self showHUDWithText:@"退出成功"];
                [WLSaveLocalHelper saveObject:@"0" forKey:LoginStatusKey];//退出

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
            }else{
                
                [self showHUDWithText:@"请求失败，请稍后重试"];
            }
            
        }];
       
        

        
       
    }
    
}

#pragma mark 清除缓存
- (CGFloat)countTheDisk
{
    //找到缓存文件的保存路径
    //NSHomeDirectory() 找到应用的沙盒路径
    NSString *filePath=[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Caches/default/com.hackemist.SDWebImageCache.default"];
    NSLog(@"文件路径：%@",filePath);
    
    //获取所有的缓存文件
    //文件管理对象类NSFileManager，用它去管理我们的文件目录
    NSFileManager *fileManager =[NSFileManager defaultManager];
    //subpathsOfDirectoryAtPath 获取当前路径下所有子文件名
    NSArray *fileArray=[fileManager subpathsOfDirectoryAtPath:filePath error:nil];
    //计算所有缓存文件的大小
    long long fileSize =0;//所有文件的总字节数
    for (NSString *fileName in fileArray) {
        //获得每一个缓存文件的路径
        NSString *subFilePath =[filePath stringByAppendingPathComponent:fileName];
        NSDictionary *attributes =[fileManager attributesOfItemAtPath:subFilePath error:nil];
        //每一个子文件所占的大小
        long long size =[attributes [NSFileSize]longLongValue];
        fileSize +=size;
    }
    _countFileSize = fileSize/1000.f/1000.f;
    
    NSLog(@"countSize:%f",_countFileSize);
    return _countFileSize;
}

- (void)cleanTheDisk
{
    
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        
        self.countFileSize = 0;
        [self showAlert:[NSString stringWithFormat:@"清除缓存成功！"]];
        [self.mainTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
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
