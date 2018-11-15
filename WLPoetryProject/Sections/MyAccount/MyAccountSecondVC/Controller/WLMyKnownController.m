//
//  WLMyKnownController.m
//  WLPoetryProject
//
//  Created by 变啦 on 2018/11/8.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLMyKnownController.h"
#import "WLChartView.h"
#import "UserInfoModel.h"
#import "WLCoreDataHelper.h"
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
 *  诗词储量
 **/
@property (nonatomic,strong) UILabel *numberLabel;

/**
 *  徽章
 **/
@property (nonatomic,strong) UIImageView *prizeView;
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
 *  勋章图片数组
 **/
@property (nonatomic,copy) NSArray *imageArray;
/**
 *  等级数组
 **/
@property (nonatomic,copy) NSArray *titleArray;

/**
 *  勋章颜色数组
 **/
@property (nonatomic,copy) NSArray *colorArray;
/**
 *  用户信息
 **/
@property (nonatomic,strong) UserInfoModel *userModel;
/**
 *  开始测评
 **/
@property (nonatomic,strong) UIButton *startBtn;






@end

@implementation WLMyKnownController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleForNavi = @"我的学识";
    self.view.backgroundColor = ViewBackgroundColor;
}

- (void)loadCustomData
{
    self.leftSpace = 15;
    self.imageArray = [NSArray arrayWithObjects:@"class_0",@"class_1",@"class_2",@"class_3",@"class_4",@"class_5",@"class_6",@"class_7", nil];
    self.titleArray = [NSArray arrayWithObjects:@"童生",@"秀才",@"举人",@"贡士",@"进士",@"探花",@"榜眼",@"状元", nil];
    self.colorArray = [NSArray arrayWithObjects:RGBCOLOR(33, 33, 33, 1.0),RGBCOLOR(121, 0, 233, 1.0),RGBCOLOR(17, 30, 211, 1.0),RGBCOLOR(16, 89, 146, 1.0),RGBCOLOR(103, 251, 12, 1.0),RGBCOLOR(244, 233, 15, 1.0),RGBCOLOR(242, 136, 18, 1.0),RGBCOLOR(251, 0, 5, 1.0), nil];
    
    self.userModel = [[WLCoreDataHelper shareHelper] fetchCurrentUserModel];
    
    
    
}



- (void)loadCustomView
{
    [self loadCustomData];

    self.mainScrollView.backgroundColor = [UIColor whiteColor];
    [self configureHeadImage];
    self.nameLabel.text = self.userName;
    //获取用户的等级
    NSInteger index = [self.userModel.userPoetryClass integerValue];
    self.classLabel.text = [NSString stringWithFormat:@"Lv%ld %@",index+1,[self.titleArray objectAtIndex:index]];
    self.classLabel.textColor = [self.colorArray objectAtIndex:index];
    self.numberLabel.text = [NSString stringWithFormat:@"诗词量：%@",self.userModel.userPoetryStorage];
    self.prizeView.backgroundColor = [UIColor whiteColor];
    
    [self.chartView configureView];
    NSArray *arr = self.userModel.poetryStorageList;
    
    self.startBtn.backgroundColor = [UIColor lightGrayColor];

}

- (void)configureHeadImage
{
    if (self.headImageURL.length > 0) {
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.headImageURL] placeholderImage:[UIImage imageNamed:@"defaultHeader"]];
    }else{
        
        self.headImageView.image = [UIImage imageNamed:@"defaultHeader"];
    }
}

- (void)startBtnAction:(UIButton*)sender
{
    BmobUser *user = [BmobUser currentUser];
    
    NSArray *array = [NSArray arrayWithObject:@"12345"];
    
    [user addObjectsFromArray:[array copy] forKey:@"poetryStorageList"];
    
    [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        NSLog(@"error %@",[error description]);
        
    }];
    
    [[WLCoreDataHelper shareHelper] updateDataWithTable:@"UserInfo" withKey:@"userID" withKeyValueEqualTo:kUserID withNewValue:@[@"12345",@"12345"] forNewKey:@"poetryStorageList" withResult:^(BOOL isSuccessful, NSError *error) {
        NSLog(@"isSuccss:%@",isSuccessful?@"YES":@"NO");
    }];
    
}

- (UIScrollView*)mainScrollView
{
    if (!_mainScrollView) {
        
        _mainScrollView = [[UIScrollView alloc]init];
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
//        _mainScrollView.userInteractionEnabled = YES;
        _mainScrollView.scrollEnabled = YES;
        [self.view addSubview:_mainScrollView];
        
        _mainScrollView.contentSize = CGSizeMake(PhoneScreen_WIDTH, PhoneScreen_HEIGHT);
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

- (UILabel*)numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]init];
        _numberLabel.font = [UIFont systemFontOfSize:16.f];
        [self.mainScrollView addSubview:_numberLabel];
        //元素的布局
        [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.headImageView.mas_trailing).offset(10);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(0);
            make.trailing.equalTo(self.mainScrollView.mas_trailing).offset(-_leftSpace);
            make.height.mas_equalTo(30);
            
        }];
    }
    return _numberLabel;
}
- (UILabel*)classLabel
{
    if (!_classLabel) {
        _classLabel = [[UILabel alloc]init];
        _classLabel.font = [UIFont boldSystemFontOfSize:16.f];
        [self.mainScrollView addSubview:_classLabel];
        //元素的布局
        [_classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.prizeView.mas_trailing).offset(10);
            make.top.equalTo(self.prizeView.mas_top).offset(0);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(30);
            
        }];
    }
    return _classLabel;
}

- (UIImageView*)prizeView
{
    if (!_prizeView) {
        
        _prizeView = [[UIImageView alloc]init];
        [self.mainScrollView addSubview:_prizeView];
        
        //元素的布局
        [_prizeView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.numberLabel.mas_leading);
            make.top.equalTo(self.numberLabel.mas_bottom).offset(0);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
            
        }];
        
        
        
        NSInteger index = [self.userModel.userPoetryClass integerValue];

        
//        for (NSInteger i = index; i >= 0 ; i--) {
//            UIImageView *image = [[UIImageView alloc]init];
            if (index < self.imageArray.count) {
                _prizeView.image = [UIImage imageNamed:[self.imageArray objectAtIndex:index]];
            }
//            [_prizeView addSubview:image];
//
//            //元素的布局
//            [image mas_makeConstraints:^(MASConstraintMaker *make) {
//
//                make.leading.equalTo(titleLabel.mas_trailing).offset(i*30);
//                make.top.equalTo(_prizeView.mas_top).offset(0);
//                make.width.mas_equalTo(30);
//                make.height.mas_equalTo(30);
//
//            }];
//        }
//
        
    }
    return _prizeView;
}

- (WLChartView*)chartView
{
    if (!_chartView) {
        CGFloat rate = PhoneScreen_WIDTH/375.f;
        _chartView = [[WLChartView alloc]init];
        _chartView.viewW = PhoneScreen_WIDTH;
        _chartView.viewH = 300*rate;
        _chartView.dataArray = @[@"1243",@"4354",@"2234",@"767",@"434",@"5676",@"2454"];
        _chartView.titleArray = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
        _chartView.widthRate = 0.8;
        //        _chartView.widthForChart = 40;
        _chartView.animateTime = 0.35;
        _chartView.leftSpace = 10;
        [self.mainScrollView addSubview:_chartView];
        //元素的布局
        [_chartView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.mainScrollView.mas_leading).offset(0);
            make.top.equalTo(self.prizeView.mas_bottom).offset(20);
            make.height.mas_equalTo(300*rate);
            make.width.mas_equalTo(PhoneScreen_WIDTH);
        }];
    }
    return _chartView;
}
- (UIButton *)startBtn
{
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBtn addTarget:self action:@selector(startBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_startBtn setTitle:@"开始" forState:UIControlStateNormal];
        [self.mainScrollView addSubview:_startBtn];
        //元素的布局
        [_startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_chartView.mas_bottom).offset(20);
            make.centerX.equalTo(self.view.mas_centerX);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(40);
            
        }];
    }
    return _startBtn;
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
