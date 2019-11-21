//
//  WLScoreController.m
//  WLPoetryProject
//
//  Created by 变啦 on 2018/11/23.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLScoreController.h"
#import "WLMyKnownController.h"

@interface WLScoreController ()
/**
 *  分数
 **/
@property (nonatomic,strong) UILabel *scoreLabel;
/**
 *  名字
 **/
@property (nonatomic,strong) UILabel *nameLabel;
/**
 *  诗词量
 **/
@property (nonatomic,assign) NSInteger userCount;



@end

@implementation WLScoreController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.titleForNavi = @"金榜提名";
    self.view.backgroundColor = ViewBackgroundColor;
    self.naviColor = [UIColor clearColor];
    [self loadCustomData];
    [self loadCustomView];
//    [self addBackButtonForFullScreen];

}

- (void)loadCustomData
{
    self.userCount = [self loadUserRealCount];
//    NSInteger userClass = [self configureUserClass];
    NSString *countString = [NSString stringWithFormat:@"%ld",self.userCount];
    
    [[NetworkHelper shareHelper] addUserChallengeRecord:kUserID storage:self.userCount withCompletion:^(BOOL success, NSDictionary *dic, NSError *error) {
        if (success) {
            
            NSString *code = [NSString stringWithFormat:@"%@",[dic objectForKey:@"retCode"]];
            if (![code isEqualToString:@"1000"]) {
                NSString *tipMessage = [dic objectForKey:@"message"];
                [self showHUDWithText:tipMessage];
                return ;
            }
            
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            if (self.block) {
                self.block(@{@"userPoetryStorage":countString,
                             @"userPoetryClass":[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"poetry_class"]]});
            }
            
        }else{
            
            [self showHUDWithText:@"请求失败，请稍后重试"];
        }
    }];

}
#pragma mark 级别 从0开始，童生

- (NSInteger)configureUserClass
{
    
    if (self.userCount<200) {
        return 0;
    }else if (self.userCount < 700){
        return 1;
    }else if (self.userCount < 1300){
        return 2;
    }else if (self.userCount < 2000){
        return 3;
    }else if (self.userCount < 2800){
        return 4;
    }else if (self.userCount < 3700){
        return 5;
    }else if (self.userCount < 4500){
        return 6;
    }else{
        return 7;
    }
    return 0;
}



- (void)loadCustomView
{
    CGFloat rate = PhoneScreen_WIDTH/414.f;
    
    UIImageView *mainBgImageView = [[UIImageView alloc]init];
    mainBgImageView.image = [UIImage imageNamed:@"scoreBg.jpg"];
    [self.view addSubview:mainBgImageView];
    
    //元素的布局
    [mainBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.view.mas_leading).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.trailing.equalTo(self.view.mas_trailing).offset(0);
        make.bottom.equalTo(self.view.mas_bottom);
        
    }];
    
    CGFloat circleW = 200*rate;
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.text = @"您的诗词量约为:";
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = RGBCOLOR(150, 150, 150, 1.0);
    tipLabel.font = [UIFont systemFontOfSize:rate*20.f];
    [self.view addSubview:tipLabel];
    //元素的布局
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.view.mas_leading).offset(0);
        make.top.equalTo(mainBgImageView.mas_top).offset((PhoneScreen_HEIGHT-50-circleW)/2);
        make.trailing.equalTo(self.view.mas_trailing).offset(0);
        make.height.mas_equalTo(30);
        
    }];
    
    
    UIImageView *circleImage = [[UIImageView alloc]init];
    circleImage.image = [UIImage imageNamed:@"scoreCir.png"];
    [self.view addSubview:circleImage];
    //元素的布局
    [circleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.view.mas_leading).offset((PhoneScreen_WIDTH-circleW)/2);
        make.top.equalTo(tipLabel.mas_bottom).offset(0);
        make.width.mas_equalTo(circleW);
        make.height.mas_equalTo(circleW);
    }];
    
    self.scoreLabel = [[UILabel alloc]init];
    self.scoreLabel.font = [UIFont boldSystemFontOfSize:30];
    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
    self.scoreLabel.textColor = RGBCOLOR(100, 100, 100, 1.0);
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld",self.userCount];
    [circleImage addSubview:self.scoreLabel];
    
    //元素的布局
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(circleImage.mas_leading).offset(0);
        make.top.equalTo(circleImage.mas_top).offset(0);
        make.bottom.equalTo(circleImage.mas_bottom).offset(0);
        make.trailing.equalTo(circleImage.mas_trailing).offset(0);
    }];
    
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.backgroundColor = RGBCOLOR(41, 179, 74, 1.0);
    finishBtn.alpha = 0.85;
    finishBtn.layer.cornerRadius = 6.f;
    finishBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    finishBtn.layer.borderWidth = 1.5f;
    [finishBtn setTitle:@"已阅" forState:UIControlStateNormal];
    [finishBtn addEventWithAction:^(UIButton *sender) {
       
        BOOL isPop = NO;
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[WLMyKnownController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                isPop = YES;
            }
        }
        
        if (!isPop) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
    [self.view addSubview:finishBtn];
    
    //元素的布局
    [finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.view.mas_leading).offset(15);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.trailing.equalTo(self.view.mas_trailing).offset(-15);
        make.height.mas_equalTo(40);
        
    }];
    
    
}

- (NSInteger)loadUserRealCount
{
    if (self.score > 0) {
        NSInteger count = self.score/1;
        NSInteger totalCount = count*count/2+arc4random()%100;
        return totalCount;
    }
    return 0;
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
