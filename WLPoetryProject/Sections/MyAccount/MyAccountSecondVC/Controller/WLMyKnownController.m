//
//  WLMyKnownController.m
//  WLPoetryProject
//
//  Created by 变啦 on 2018/11/8.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLMyKnownController.h"
#import "WLChartView.h"

@interface WLMyKnownController ()
/**
 *  主scroll
 **/
@property (nonatomic,strong) UIScrollView *mainScrollView;
/**
 *  👨‍🎓
 **/
@property (nonatomic,strong) UIImageView *headImageView;

/**
 *  名称
 **/
@property (nonatomic,strong) UILabel *nameLabel;
/**
 *  级别
 **/
@property (nonatomic,strong) UILabel *classLabel;
/**
 *  徽章
 **/
@property (nonatomic,strong) UIView *prizeView;
/**
 *  当前诗词量
 **/
@property (nonatomic,strong) UILabel *currentKnowLabel;
/**
 *  表格
 **/
@property (nonatomic,strong) WLChartView *chartView;

/**
 *  左侧间距
 **/
@property (nonatomic,assign) CGFloat leftSpace;
/**
 *  数组
 **/
@property (nonatomic,copy) NSArray *imageArray;


@end

@implementation WLMyKnownController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleForNavi = @"我的学识";
    self.view.backgroundColor = ViewBackgroundColor;
    [self loadCustomData];
}

- (void)loadCustomData
{
    self.leftSpace = 15;
    self.imageArray = [NSArray arrayWithObjects:@"class_0",@"class_1",@"class_2",@"class_3",@"class_4",@"class_5",@"class_6",@"class_7", nil];
}

- (void)loadCustomView
{
    self.mainScrollView.backgroundColor = [UIColor whiteColor];
    [self configureHeadImage];
    self.nameLabel.text = self.userName;
    self.classLabel.text = @"状元";
    self.prizeView.backgroundColor = [UIColor whiteColor];
}

- (void)configureHeadImage
{
    if (self.headImageURL.length > 0) {
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.userName] placeholderImage:[UIImage imageNamed:@"headerUnlogin"]];
        
    }else{
        
        self.headImageView.image = [UIImage imageNamed:@"defaultHeader"];
      
    }
}

- (UIScrollView*)mainScrollView
{
    if (!_mainScrollView) {
        
        _mainScrollView = [[UIScrollView alloc]init];
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.userInteractionEnabled = YES;
        _mainScrollView.scrollEnabled = YES;
        [self.view addSubview:_mainScrollView];
        
        
        //元素的布局
        [_mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.view.mas_leading).offset(0);
            make.top.equalTo(self.naviView.mas_bottom).offset(0);
            make.bottom.equalTo(self.view.mas_bottom).offset(0);
            make.trailing.equalTo(self.view.mas_trailing).offset(0);
            
        }];
    }
    return _mainScrollView;
}

- (UIImageView*)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc]init];
        [self.mainScrollView addSubview:_headImageView];
        
        //元素的布局
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.mainScrollView.mas_leading).offset(self.leftSpace);
            make.top.equalTo(self.mainScrollView.mas_top).offset(15);
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(90);
            
        }];
    }
    return _headImageView;
}

- (UILabel*)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:14.f];
        [self.mainScrollView addSubview:_nameLabel];
        //元素的布局
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.headImageView.mas_trailing).offset(10);
            make.top.equalTo(self.headImageView.mas_top).offset(0);
            make.trailing.equalTo(self.mainScrollView.mas_trailing).offset(-_leftSpace);
            make.height.mas_equalTo(30);
            
        }];
    }
    return _nameLabel;
}

- (UILabel*)classLabel
{
    if (!_classLabel) {
        _classLabel = [[UILabel alloc]init];
        _classLabel.font = [UIFont systemFontOfSize:14.f];
        [self.mainScrollView addSubview:_classLabel];
        //元素的布局
        [_classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.headImageView.mas_trailing).offset(10);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(0);
            make.trailing.equalTo(self.mainScrollView.mas_trailing).offset(-_leftSpace);
            make.height.mas_equalTo(20);
            
        }];
    }
    return _classLabel;
}

- (UIView*)prizeView
{
    if (!_prizeView) {
        
        _prizeView = [[UIView alloc]init];
        [self.mainScrollView addSubview:_prizeView];
        
        //元素的布局
        [_prizeView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.nameLabel.mas_leading);
            make.top.equalTo(self.classLabel.mas_bottom).offset(0);
            make.trailing.equalTo(self.mainScrollView.mas_trailing).offset(-_leftSpace);
            make.height.mas_equalTo(30);
            
        }];
        
        
        for (int i = 0; i < self.imageArray.count; i++) {
            UIImageView *image = [[UIImageView alloc]init];
            image.image = [UIImage imageNamed:[self.imageArray objectAtIndex:i]];
            [_prizeView addSubview:image];
            
            //元素的布局
            [image mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.leading.equalTo(_prizeView.mas_leading).offset(i*30);
                make.top.equalTo(_prizeView.mas_top).offset(0);
                make.width.mas_equalTo(30);
                make.height.mas_equalTo(30);
                
            }];
        }
        
        
    }
    return _prizeView;
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
