//
//  WLFeedbackController.m
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/6/17.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLFeedbackController.h"
#import <BmobSDK/Bmob.h>
@interface WLFeedbackController ()
/**
 *  输入框
 **/
@property (nonatomic, strong) UITextView *inputTextView;
/**
 *  输入框
 **/
@property (nonatomic, strong) UITextView *contactTextView;

@end

@implementation WLFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleForNavi = @"意见反馈";
    self.view.backgroundColor = ViewBackgroundColor;
    [self loadCustomView];
}

- (void)loadCustomView
{
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.text = @"我们会认真对待您的每一条反馈～";//设置文本
    tipLabel.font = [UIFont systemFontOfSize:14.f];//字号设置
    [self.view addSubview:tipLabel];
    //设置UI布局约束
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.naviView.mas_bottom).offset(20);//元素顶部约束
        make.leading.equalTo(self.view.mas_leading).offset(15);//元素左侧约束
        make.trailing.equalTo(self.view.mas_trailing).offset(-15);//元素右侧约束
        make.height.mas_equalTo(20);//元素高度
    }];
    
    self.inputTextView = [[UITextView alloc]init];
    self.inputTextView.backgroundColor = [UIColor whiteColor];
    self.inputTextView.layer.cornerRadius = 10.f;
//    self.inputTextView.layer.borderColor = RGBCOLOR(65, 160, 225, 1.0).CGColor;
//    self.inputTextView.layer.borderWidth = 1.f;
    [self.view addSubview:self.inputTextView];
    //设置UI布局约束
    [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(tipLabel.mas_bottom).offset(10);//元素顶部约束
        make.leading.equalTo(tipLabel.mas_leading).offset(0);//元素左侧约束
        make.trailing.equalTo(tipLabel.mas_trailing).offset(0);//元素右侧约束
        make.height.mas_equalTo(160);//元素高度
    }];
    
    
    UILabel *contactLabel = [[UILabel alloc]init];
    contactLabel.text = @"您的邮箱或手机号（选填）";//设置文本
    contactLabel.font = [UIFont systemFontOfSize:14.f];//字号设置
    [self.view addSubview:contactLabel];
    //设置UI布局约束
    [contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.inputTextView.mas_bottom).offset(15);//元素顶部约束
        make.leading.equalTo(self.inputTextView.mas_leading).offset(0);//元素左侧约束
        make.trailing.equalTo(self.inputTextView.mas_trailing).offset(0);//元素右侧约束
        make.height.mas_equalTo(20);//元素高度
    }];
    
    self.contactTextView = [[UITextView alloc]init];
    self.contactTextView.layer.cornerRadius = 4.f;
//    self.contactTextView.layer.borderColor = RGBCOLOR(65, 160, 225, 1.0).CGColor;
//    self.contactTextView.layer.borderWidth = 0.8;
    [self.view addSubview:self.contactTextView];
    //设置UI布局约束
    [self.contactTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(contactLabel.mas_bottom).offset(10);//元素顶部约束
        make.leading.equalTo(contactLabel.mas_leading).offset(0);//元素左侧约束
        make.trailing.equalTo(contactLabel.mas_trailing).offset(0);//元素右侧约束
        make.height.mas_equalTo(30);//元素高度
    }];
    
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"提交" forState:UIControlStateNormal];
    sureBtn.backgroundColor = NavigationColor;
    [sureBtn addTarget:self action:@selector(submitFeedback:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    
    if (@available(iOS 11.0, *)) {
        //元素的布局
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.view.mas_safeAreaLayoutGuideLeading).offset(0);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-49);
            make.bottom.equalTo(self.view.mas_bottom).offset(0);
            make.trailing.equalTo(self.view.mas_trailing).offset(0);
            
        }];
    }else{
        //元素的布局
        //设置UI布局约束
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.view.mas_leading).offset(0);//元素左侧约束
            make.trailing.equalTo(self.view.mas_trailing).offset(0);//元素右侧约束
            make.bottom.equalTo(self.view.mas_bottom).offset(0);//元素底部约束
            make.height.mas_equalTo(49);//元素高度
        }];
        
    }
    
}

- (void)submitFeedback:(UIButton*)sender
{
    if (self.inputTextView.text.length == 0) {
        [self showHUDWithText:@"请输入反馈的内容～"];
        return;
    }
    
    BmobObject *feedback = [BmobObject objectWithClassName:@"FeedBackList"];
    [feedback setObject:self.inputTextView.text forKey:@"feedbackContent"];
    [feedback setObject:[NSString stringWithFormat:@"%@",self.contactTextView.text] forKey:@"feedbackContact"];
    
    [feedback saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"成功");
            [self showHUDWithText:@"提交成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            NSLog(@"失败");
        }
    }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    HidenKeybory;
}

#pragma mark - 返回事件

- (void)backAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
