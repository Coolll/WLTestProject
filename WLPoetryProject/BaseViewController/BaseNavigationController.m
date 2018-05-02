//
//  BaseNavigationController.m
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/1.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

- (void)viewWillAppear:(BOOL)animated
{

    self.navigationBar.hidden = YES;
    
    
}

- (void)backAction:(UIButton*)sender
{
    if (self.childViewControllers.count > 0) {
        [self popViewControllerAnimated:YES];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIImage *)resizableImage:(UIImage *)image
{
    //default is 2
    CGFloat top = image.size.height / 5; // 顶端盖高度
    CGFloat bottom = image.size.height / 5 ; // 底端盖高度
    CGFloat left = image.size.width / 5; // 左端盖宽度
    CGFloat right = image.size.width / 5; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    return [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
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
