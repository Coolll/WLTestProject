//
//  YLTabbarController.m
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/1.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import "YLTabbarController.h"
#import "BaseNavigationController.h"
#import "YLHomeViewController.h"
#import "YLAccountViewController.h"
#import "WLPoetryTypeController.h"

static const CGFloat iconWidth = 22;
static const CGFloat textHeight = 15;

static const NSInteger buttonBaseTag = 2000;
@interface YLTabbarController ()

/**
 *  未选中时的图片数组
 **/
@property (nonatomic,strong) NSMutableArray *normalImageArray;

/**
 *  选中时的图片数组
 **/
@property (nonatomic,strong) NSMutableArray *selectedImageArray;

/**
 *  文本的数组
 **/
@property (nonatomic,strong) NSMutableArray *iconTextArray;

/**
 *  图标数组
 **/
@property (nonatomic,strong) NSMutableArray *iconArray;

/**
 *  文本数组
 **/
@property (nonatomic,strong) NSMutableArray *textArray;

/**
 *  tabbar视图
 **/
@property (nonatomic,strong) UIView *tabbarView;



@end

@implementation YLTabbarController

- (instancetype)init
{
    self = [super init];
    if (self) {
        //加载内容
        [self loadContentVC];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)loadContentVC
{
    //首页
    YLHomeViewController *homeVC = [[YLHomeViewController alloc]init];
    homeVC.view.backgroundColor = [UIColor whiteColor];
    homeVC.isShowBack = NO;
    BaseNavigationController *homeNavi = [[BaseNavigationController alloc]initWithRootViewController:homeVC];

    //诗词分类
    WLPoetryTypeController *typeVC = [[WLPoetryTypeController alloc]init];
    typeVC.view.backgroundColor = [UIColor whiteColor];
    typeVC.isShowBack = NO;
    BaseNavigationController *typeNavi = [[BaseNavigationController alloc]initWithRootViewController:typeVC];
    
    //个人
    YLAccountViewController *accountVC = [[YLAccountViewController alloc]init];
    accountVC.isShowBack = NO;
    accountVC.view.backgroundColor = [UIColor whiteColor];
    BaseNavigationController *accountNavi = [[BaseNavigationController alloc]initWithRootViewController:accountVC];
    
    
    NSArray *viewControllers = [NSArray arrayWithObjects:homeNavi,typeNavi,accountNavi, nil];
  
    self.viewControllers = viewControllers;
    
    //默认展示第一个界面
    self.selectedIndex = 0;
    
    //重写tabbar
    [self loadTabbarView];
    
}

//外部控制展示第几个视图
- (void)loadDefaultViewWithIndex:(NSInteger)index
{
    if (index < self.viewControllers.count) {
        
        [self refreshIconAndTextColorWithIndex:index];

    }
    
}
//自定义tabbar
- (void)loadTabbarView
{
    UIColor *tabbarColor = RGBCOLOR(240, 245, 250, 1.0);
    
    self.tabbarView = [[UIView alloc]init];
    self.tabbarView.backgroundColor = RGBCOLOR(201, 219, 226, 1.0);
    [self.tabBar addSubview:self.tabbarView];
    
    //元素的布局
    if (@available(iOS 11.0, *)) {
        [self.tabbarView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view.mas_left).offset(0);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-49);
            make.bottom.equalTo(self.view.mas_bottom).offset(0);
            make.right.equalTo(self.view.mas_right).offset(0);
        }];
    }else{
        [self.tabbarView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view.mas_left).offset(0);
            make.top.equalTo(self.view.mas_bottom).offset(-49);
            make.bottom.equalTo(self.view.mas_bottom).offset(0);
            make.right.equalTo(self.view.mas_right).offset(0);
            
        }];
        
    }
    //图标个数
    NSInteger itemCount = 3;
    //tabbar高度
    CGFloat tabbarH = 49;
    
    CGFloat leftSpace = 0;
    
    //单个宽度
    CGFloat itemWidth = PhoneScreen_WIDTH/itemCount;
    
    for (int i = 0; i< itemCount; i++) {
        
        //响应事件的按钮
        UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        itemBtn.tag = i+buttonBaseTag;
        itemBtn.backgroundColor = tabbarColor;
        [itemBtn addTarget:self action:@selector(selectItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabbarView addSubview:itemBtn];
        //元素的布局
        [itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.tabbarView.mas_left).offset(leftSpace);
            make.top.equalTo(self.tabbarView.mas_top).offset(0);
            make.bottom.equalTo(self.tabbarView.mas_bottom).offset(0);
            make.width.mas_equalTo(itemWidth);
            
        }];
        
        //图标
        UIImageView *iconImageView = [[UIImageView alloc]init];
        iconImageView.userInteractionEnabled = NO;
        [itemBtn addSubview:iconImageView];
        //元素的布局
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(itemBtn.mas_left).offset((itemWidth-iconWidth)/2);
            make.top.equalTo(itemBtn.mas_top).offset((tabbarH-iconWidth-textHeight)/3);
            make.width.mas_equalTo(iconWidth);
            make.height.mas_equalTo(iconWidth);
            
        }];
        
        //图标对应的文本
        UILabel *textLabel = [[UILabel alloc]init];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.text = self.iconTextArray[i];
        textLabel.font = [UIFont systemFontOfSize:13.0];
        [itemBtn addSubview:textLabel];
        //元素的布局
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(itemBtn.mas_left).offset(0);
            make.top.equalTo(iconImageView.mas_bottom).offset((tabbarH-iconWidth-textHeight)/3);
            make.right.equalTo(itemBtn.mas_right).offset(0);
            make.height.mas_equalTo(textHeight);
            
        }];
        if (i == 0) {
            //初始化时，默认选中第1个视图
            iconImageView.image = [self loadSelectedImageWithIndex:0];
            textLabel.textColor = TabbarTextSelectColor;
        }else{
            //其他为非选中状态
            iconImageView.image = [self loadNormalImageWithIndex:i];
            textLabel.textColor = TabbarTextNormalColor;
        }
        
        //后面需要视图的更新，这里把图标和文本放到数组中
        [self.textArray addObject:textLabel];
        [self.iconArray addObject:iconImageView];
        
        leftSpace += itemWidth;
    }
    
    
    
    UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, PhoneScreen_WIDTH, 0.8)];
    lineView.image = [UIImage imageNamed:@"tabbarLine"];
    [self.tabbarView addSubview:lineView];
}



//按钮点击事件
- (void)selectItemAction:(UIButton*)sender
{
    NSInteger index = sender.tag-buttonBaseTag;
    
    [self refreshIconAndTextColorWithIndex:index];
    
    
}

//更新文本的颜色和图标
- (void)refreshIconAndTextColorWithIndex:(NSInteger)index
{
    for (int i = 0; i< self.iconArray.count; i++) {
        
        UIImageView *iconImageView = self.iconArray[i];
        UILabel *textLabel = self.textArray[i];
        
        if (i == index) {
            iconImageView.image = [self loadSelectedImageWithIndex:index];
            textLabel.textColor = TabbarTextSelectColor;
        }else{
            iconImageView.image = [self loadNormalImageWithIndex:i];
            textLabel.textColor = TabbarTextNormalColor;
        }
    }
    
    //切换视图
    if (index < self.viewControllers.count) {
        self.selectedIndex = index;
        
//        //当用户未登录，进入积分商城中登录，再返回扑客说的时候，需要更新数据，否则扑客说为未登录状态
//        if (index == 1) {
//            
//            BaseNavigationController *navi = self.viewControllers[index];\
//            YLAccountViewController *vc = navi.viewControllers.firstObject;
//            [vc refreshData];
//        }
    }
    

}

//正常状态图片
- (UIImage*)loadNormalImageWithIndex:(NSInteger)index
{
    NSString *imageName = self.normalImageArray[index];
    UIImage *image = [UIImage imageNamed:imageName];
    
    return image;
}

//选中状态图片
- (UIImage*)loadSelectedImageWithIndex:(NSInteger)index
{
    NSString *imageName = self.selectedImageArray[index];
    UIImage *image = [UIImage imageNamed:imageName];
    
    return image;
}

//正常图片数组
- (NSMutableArray*)normalImageArray
{
    if (!_normalImageArray) {
        
        _normalImageArray = [NSMutableArray array];
        NSString *homeIcon = @"tabbarOne";
        NSString *typeIcon = @"tabbarTwo";
        NSString *accountIcon = @"tabbarThree";
        
        [_normalImageArray addObject:homeIcon];
        [_normalImageArray addObject:typeIcon];
        [_normalImageArray addObject:accountIcon];
    }
    
    return _normalImageArray;
}

//选中图片数组
- (NSMutableArray*)selectedImageArray
{
    if (!_selectedImageArray) {
        
        _selectedImageArray = [NSMutableArray array];
        NSString *homeIcon = @"tabbarOne_sel";
        NSString *typeIcon = @"tabbarTwo_sel";
        NSString *accountIcon = @"tabbarThree_sel";
        
        [_selectedImageArray addObject:homeIcon];
        [_selectedImageArray addObject:typeIcon];
        [_selectedImageArray addObject:accountIcon];
    }
    
    return _selectedImageArray;
}

//图标对应文本的数组
- (NSMutableArray*)iconTextArray
{
    if (!_iconTextArray) {
        
        _iconTextArray = [NSMutableArray array];
        
        [_iconTextArray addObject:@"诗词"];
        [_iconTextArray addObject:@"分类"];
        [_iconTextArray addObject:@"我的"];
    }
    return _iconTextArray;
}

- (NSMutableArray*)iconArray
{
    if (!_iconArray) {
        _iconArray = [NSMutableArray array];
    }
    
    return _iconArray;
}


- (NSMutableArray*)textArray
{
    if (!_textArray) {
        _textArray = [NSMutableArray array];
        
    }
    return _textArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
