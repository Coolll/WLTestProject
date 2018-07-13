//
//  YLAccountViewController.m
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/1.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import "YLAccountViewController.h"
#import "WLMyTableViewCell.h"
#import "WLMyHeaderTableViewCell.h"
#import "WLLoginViewController.h"
#import "WLSettingController.h"
#import "WLLikeController.h"
#import "AboutViewController.h"
#import "WLCustomImageListController.h"
@interface YLAccountViewController ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  主tableView
 **/
@property (nonatomic,strong) UITableView *mainTableView;

/**
 *  元素数组
 **/
@property (nonatomic,strong) NSArray *itemsArray;

/**
 *  图片数组
 **/
@property (nonatomic,strong) NSArray *imageArray;

/**
 *  是否可以下拉刷新
 **/
@property (nonatomic,assign) BOOL canPullData;

/**
 *  是否登录
 **/
@property (nonatomic,assign) BOOL isLoginSuccess;

/**
 *  用户名
 **/
@property (nonatomic,copy) NSString *userNameString;

/**
 *  头像
 **/
@property (nonatomic,copy) NSString *userImageURL;




@end

@implementation YLAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = ViewBackgroundColor;
    self.isShowBack = NO;
    [self loadCustomData];

    [self loadCustomView];

}



#pragma mark - 加载数据
- (void)loadCustomData
{
    NSString *tokenString = [NSString stringWithFormat:@"%@",kUserToken];
    if ([tokenString isEqualToString:@"(null)"]) {
        tokenString = @"";
    }
    
    NSString *nameString = [NSString stringWithFormat:@"%@",kUserName];
    if ([nameString isEqualToString:@"(null)"]) {
        nameString = @"";
    }
    
    self.userNameString = nameString;
    
    NSString *userHeadImaeString = [NSString stringWithFormat:@"%@",kUserHeadImage];
    if ([userHeadImaeString isEqualToString:@"(null)"]) {
        userHeadImaeString = @"";
    }
    
    self.userImageURL = userHeadImaeString;
    
    if (tokenString.length > 0 && nameString.length > 0 ) {
        self.isLoginSuccess = YES;
    }else{
        self.isLoginSuccess = NO;
    }

    self.canPullData = YES;
    self.itemsArray = [NSArray arrayWithObjects:@"我的题画",@"我的收藏",@"设置",@"关于", nil];
    self.imageArray = [NSArray arrayWithObjects:@"customImage",@"like",@"setting",@"about",nil];
}

- (void)refreshData
{
    NSString *tokenString = [NSString stringWithFormat:@"%@",kUserToken];
    if ([tokenString isEqualToString:@"(null)"]) {
        tokenString = @"";
    }
    
    NSString *nameString = [NSString stringWithFormat:@"%@",kUserName];
    if ([nameString isEqualToString:@"(null)"]) {
        nameString = @"";
    }
    
    self.userNameString = nameString;
    
    NSString *userHeadImaeString = [NSString stringWithFormat:@"%@",kUserHeadImage];
    if ([userHeadImaeString isEqualToString:@"(null)"]) {
        userHeadImaeString = @"";
    }
    
    self.userImageURL = userHeadImaeString;
    
    if (tokenString.length > 0 && nameString.length > 0 ) {
        self.isLoginSuccess = YES;
    }else{
        self.isLoginSuccess = NO;
    }
    
    self.canPullData = YES;

    if (self.mainTableView) {
        [self.mainTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

#pragma mark - 网络请求



#pragma mark 非零处理
- (NSString*)notNillValueWithKey:(NSString*)key withDic:(NSDictionary*)dic
{
    id object = [dic objectForKey:key];

    if (object) {
        
        NSString *string = [NSString stringWithFormat:@"%@",object];
        return string;
    }

    return @"";

}

#pragma mark - 加载视图
- (void)loadCustomView
{
    self.mainTableView = [[UITableView alloc]init];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.backgroundColor = RGBCOLOR(250, 250, 250, 1.0);
    self.mainTableView.scrollEnabled = NO;
    [self.view addSubview:self.mainTableView];
    
    //元素的布局
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.naviView.mas_bottom).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        
    }];
}

#pragma mark 下拉刷新
- (void)userRefreshData
{
    if (self.canPullData) {
        NSLog(@"下拉");
        //防止多次下拉
        self.canPullData = NO;
        
        //用户下拉时，如果
        if (self.isLoginSuccess) {
//            [self requestUserInfo];
        }else{
            [self.mainTableView.mj_header endRefreshing];
        }
        
        //1秒后可以再次刷新数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.canPullData = YES;
            
        });
        
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    
    return self.itemsArray.count;
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
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 125;
    }else if (indexPath.section == 1){
        return 50;
    }
    
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        WLMyHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WLMyAccountHeaderTableViewCell"];
        
        if (!cell) {
            
            cell = [[WLMyHeaderTableViewCell alloc]initWithFrame:CGRectMake(0, 0, PhoneScreen_WIDTH, 125)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        
        cell.isLogin = self.isLoginSuccess;
        cell.nameString = self.userNameString;
        cell.imageURL = self.userImageURL;

        __weak __typeof(self)weakSelf = self;
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        [cell clickEditBlock:^{
            if (self.isLoginSuccess) {

            }
        }];
        
        [cell clickLoginBlock:^{
            [strongSelf loginAction];
        }];
        
        [cell clickHeadImageBlock:^(BOOL isLogin) {
            [strongSelf changeHeaderImage:isLogin];

        }];
        
        return cell;
    }else if (indexPath.section == 1){
        
        WLMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WLMyAccountContentTableViewCell"];
        
        if (!cell) {
            
            cell = [[WLMyTableViewCell alloc]initWithFrame:CGRectMake(0, 0, PhoneScreen_WIDTH, 50)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        if (indexPath.row < self.itemsArray.count) {
            cell.titleString = self.itemsArray[indexPath.row];
            
        }
        
        if (indexPath.row < self.imageArray.count) {
            cell.iconImageName = self.imageArray[indexPath.row];
        }
        
        if (indexPath.row == self.itemsArray.count-1) {
            cell.needLine = NO;//最后一个不需要分割线
            
        }
        return cell;
        
    }
    
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    if (section == 1) {
        
        if (indexPath.row == 0) {
            //我的题画
            WLCustomImageListController *vc = [[WLCustomImageListController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if (indexPath.row == 1) {
            //我的收藏
            id token = kUserToken;
            if (!token) {
                token = @"";
            }
            
            NSString *tokenString = [NSString stringWithFormat:@"%@",token];
            //如果本地没有token，那么就意味着用户没有登录，不需要去拿收藏列表,该数据为未收藏
            if (tokenString.length == 0) {
                [self showHUDWithText:@"请先登录"];
                return;
            }
            
            
            WLLikeController *likeVC = [[WLLikeController alloc]init];
            likeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:likeVC animated:YES];
        }
        
        if (indexPath.row == 2) {
            //设置
            WLSettingController *vc = [[WLSettingController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [vc refreshLoginState:^(BOOL isLogin) {
                [self logoutAction:isLogin];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if (indexPath.row == 3) {
            //关于
            AboutViewController *vc = [[AboutViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
    
    
    
}

//从设置界面退出登录
- (void)logoutAction:(BOOL)isLogin
{
    self.isLoginSuccess = isLogin;

    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self.mainTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    });
}

- (void)loginAction
{
    NSLog(@"VC登录");
    
    WLLoginViewController *loginVC = [[WLLoginViewController alloc]init];
    loginVC.hidesBottomBarWhenPushed = YES;
    [loginVC loginSuccessWithBlock:^(UserInformation *user) {
        
        
        self.userNameString = user.userName;
        self.userImageURL = user.userImgurl;
        
        self.isLoginSuccess = YES;
        [self.mainTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        
    }];
    
    [self.navigationController pushViewController:loginVC animated:YES];

}

- (void)changeHeaderImage:(BOOL)isLogin
{
    NSLog(@"VC点击头像:%@",isLogin?@"YES":@"NO");
    
    if (!isLogin) {
        [self loginAction];
    }
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
