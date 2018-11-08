//
//  WLMyKnownController.m
//  WLPoetryProject
//
//  Created by 变啦 on 2018/11/8.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLMyKnownController.h"

@interface WLMyKnownController ()

@end

@implementation WLMyKnownController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleForNavi = @"我的学识";
    self.view.backgroundColor = ViewBackgroundColor;
    [self loadCustomView];
}

- (void)loadCustomView
{
    

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
