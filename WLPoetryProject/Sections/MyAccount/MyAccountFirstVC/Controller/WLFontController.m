//
//  WLFontController.m
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/6/17.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLFontController.h"
#import "WLColorPickerView.h"
@interface WLFontController ()
/**
 *  标题字号
 **/
@property (nonatomic, strong) UISlider *titleFontSlider;

/**
 *  作者字号
 **/
@property (nonatomic, strong) UISlider *authorFontSlider;
/**
 *  内容字号
 **/
@property (nonatomic, strong) UISlider *contentFontSlider;

/**
 *  标题
 **/
@property (nonatomic, strong) UILabel *tipLabel;
/**
 *  作者
 **/
@property (nonatomic, strong) UILabel *authorLabel;
/**
 *  内容
 **/
@property (nonatomic, strong) UILabel *contentLabel;

/**
 *  标题
 **/
@property (nonatomic, strong) UILabel *poetryTitleLabel;
/**
 *  作者
 **/
@property (nonatomic, strong) UILabel *poetryAuthorLabel;
/**
 *  内容
 **/
@property (nonatomic, strong) UILabel *poetryContentLabel;

/**
 *  字号
 **/
@property (nonatomic, assign) NSInteger titleFontSize,authorFontSize,contentFontSize;
/**
 *  字体颜色
 **/
@property (nonatomic,strong) UIColor *textColor;
/**
 *  颜色的提示视图
 **/
@property (nonatomic,strong) UIView *colorTipView;
/**
 *  文本颜色
 **/
@property (nonatomic,strong) WLColorPickerView *pickerView;
/**
 *  picker的背景图
 **/
@property (nonatomic,strong) UIView *coverView;
/**
 *  选择的颜色字符串
 **/
@property (nonatomic,copy) NSString *selectColorString;
@end

@implementation WLFontController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleForNavi = @"字体调整";
    self.view.backgroundColor = ViewBackgroundColor;
    [self loadCustomData];
    [self loadCustomView];
}

- (void)loadCustomData
{
    //从数据库中读取原先的自体大小配置数据
    id configureDic = kUserConfigure;
    if (configureDic && [configureDic isKindOfClass:[NSDictionary class]]) {
        
        NSString *titleFont = [configureDic objectForKey:@"poetryTitleFont"];
        if (titleFont) {
            self.titleFontSize = [titleFont integerValue];
        }
        
        NSString *authorFont = [configureDic objectForKey:@"poetryAuthorFont"];
        if (authorFont) {
            self.authorFontSize = [authorFont integerValue];
        }
        
        NSString *contentFont = [configureDic objectForKey:@"poetryContentFont"];
        if (contentFont) {
            self.contentFontSize = [contentFont integerValue];
        }
        
    }else{
        //如果没有配置数据，那么默认的字号为16 16 14
        self.titleFontSize = 16;
        self.authorFontSize = 16;
        self.contentFontSize = 14;
    }
    
    NSString *colorConfig = [WLSaveLocalHelper fetchReadTextRGB];
    self.textColor = RGBCOLOR(60, 60, 120, 1.0);
    
    if (kStringIsEmpty(colorConfig)) {
        self.selectColorString = @"60,60,120";
    }else{
        NSArray *array = [colorConfig componentsSeparatedByString:@","];
        if (array.count == 3) {
            NSInteger red = [[array objectAtIndex:0] integerValue];
            NSInteger green = [[array objectAtIndex:1] integerValue];
            NSInteger blue = [[array objectAtIndex:2] integerValue];
            self.textColor = RGBCOLOR(red, green, blue, 1);
        }
        self.selectColorString = colorConfig;
    }
    
}

- (void)loadCustomView
{
    UILabel *textColorLabel = [[UILabel alloc]init];
    textColorLabel.text = @"选择颜色";
    textColorLabel.font = [UIFont systemFontOfSize:14.f];//字号设置
    [self.view addSubview:textColorLabel];
    //元素的布局
    [textColorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.naviView.mas_bottom).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(30);
    }];

    UIView *line = [[UIView alloc]init];
    line.backgroundColor = RGBCOLOR(160, 160, 160, 1);
    [self.view addSubview:line];
    //元素的布局
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textColorLabel.mas_left).offset(0);
        make.right.equalTo(textColorLabel.mas_right).offset(0);
        make.bottom.equalTo(textColorLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(0.8);
    }];

    self.colorTipView = [[UIView alloc]init];
    self.colorTipView.backgroundColor = self.textColor;
    [textColorLabel addSubview:self.colorTipView];
    //元素的布局
    [self.colorTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textColorLabel.mas_left).offset(80);
        make.top.equalTo(textColorLabel.mas_top).offset(6);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(18);
    }];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(needShowColorSelector)];
    [textColorLabel addGestureRecognizer:tap];
    textColorLabel.userInteractionEnabled = YES;
    
    self.tipLabel = [[UILabel alloc]init];
    self.tipLabel.text = [NSString stringWithFormat:@"标题字号 %ld",(long)self.titleFontSize];//设置文本
    self.tipLabel.font = [UIFont systemFontOfSize:14.f];//字号设置
    [self.view addSubview:self.tipLabel];
    //设置UI布局约束
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(textColorLabel.mas_bottom).offset(30);//元素顶部约束
        make.leading.equalTo(self.naviView.mas_leading).offset(15);//元素左侧约束
        make.trailing.equalTo(self.view.mas_trailing).offset(-15);
        make.height.mas_equalTo(20);//元素高度
    }];
    
    self.titleFontSlider = [[UISlider alloc]init];
    self.titleFontSlider.maximumValue = 20;
    self.titleFontSlider.minimumValue = 10;
    self.titleFontSlider.value = self.titleFontSize;
    [self.titleFontSlider addTarget:self action:@selector(fontChangeWithSliderAciton:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.titleFontSlider];
    //设置UI布局约束
    [self.titleFontSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.tipLabel.mas_bottom).offset(10);//元素顶部约束
        make.leading.equalTo(self.tipLabel.mas_leading).offset(0);//元素左侧约束
        make.trailing.equalTo(self.view.mas_trailing).offset(-15);//元素右侧约束
        make.height.mas_equalTo(20);//元素底部约束
    }];
    
    
    self.authorLabel = [[UILabel alloc]init];
    self.authorLabel.text = [NSString stringWithFormat:@"作者字号 %ld",(long)self.authorFontSize];
    self.authorLabel.font = [UIFont systemFontOfSize:14.f];//字号设置
    [self.view addSubview:self.authorLabel];
    //设置UI布局约束
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.titleFontSlider.mas_bottom).offset(20);//元素顶部约束
        make.leading.equalTo(self.naviView.mas_leading).offset(15);//元素左侧约束
        make.trailing.equalTo(self.view.mas_trailing).offset(-15);
        make.height.mas_equalTo(20);//元素高度
    }];
    
    self.authorFontSlider = [[UISlider alloc]init];
    self.authorFontSlider.maximumValue = 20;
    self.authorFontSlider.minimumValue = 10;
    self.authorFontSlider.value = self.authorFontSize;
    [self.authorFontSlider addTarget:self action:@selector(fontChangeWithSliderAciton:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.authorFontSlider];
    //设置UI布局约束
    [self.authorFontSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.authorLabel.mas_bottom).offset(10);//元素顶部约束
        make.leading.equalTo(self.authorLabel.mas_leading).offset(0);//元素左侧约束
        make.trailing.equalTo(self.view.mas_trailing).offset(-15);//元素右侧约束
        make.height.mas_equalTo(20);//元素底部约束
    }];
    
    
    
    
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.text = [NSString stringWithFormat:@"内容字号 %ld",(long)self.contentFontSize];//设置文本
    self.contentLabel.font = [UIFont systemFontOfSize:14.f];//字号设置
    [self.view addSubview:self.contentLabel];
    //设置UI布局约束
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.authorFontSlider.mas_bottom).offset(20);//元素顶部约束
        make.leading.equalTo(self.naviView.mas_leading).offset(15);//元素左侧约束
        make.trailing.equalTo(self.view.mas_trailing).offset(-15);
        make.height.mas_equalTo(20);//元素高度
    }];
    
    self.contentFontSlider = [[UISlider alloc]init];
    self.contentFontSlider.maximumValue = 20;
    self.contentFontSlider.minimumValue = 10;
    self.contentFontSlider.value = self.contentFontSize;
    [self.contentFontSlider addTarget:self action:@selector(fontChangeWithSliderAciton:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.contentFontSlider];
    //设置UI布局约束
    [self.contentFontSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentLabel.mas_bottom).offset(10);//元素顶部约束
        make.leading.equalTo(self.contentLabel.mas_leading).offset(0);//元素左侧约束
        make.trailing.equalTo(self.view.mas_trailing).offset(-15);//元素右侧约束
        make.height.mas_equalTo(20);//元素底部约束
    }];
    
    
    self.poetryTitleLabel = [[UILabel alloc]init];
    self.poetryTitleLabel.text = @"静夜思";
    self.poetryTitleLabel.font = [UIFont systemFontOfSize:self.titleFontSize];//字号设置
    self.poetryTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.poetryTitleLabel];
    //设置UI布局约束
    [self.poetryTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentFontSlider.mas_bottom).offset(40);//元素顶部约束
        make.leading.equalTo(self.view.mas_leading).offset(15);//元素左侧约束
        make.trailing.equalTo(self.view.mas_trailing).offset(-15);//元素右侧约束
        make.height.mas_equalTo(20);//元素高度
    }];
    
    
    self.poetryAuthorLabel = [[UILabel alloc]init];
    self.poetryAuthorLabel.text = @"李白";
    self.poetryAuthorLabel.textAlignment = NSTextAlignmentCenter;
    self.poetryAuthorLabel.font = [UIFont systemFontOfSize:self.authorFontSize];//字号设置
    [self.view addSubview:self.poetryAuthorLabel];
    //设置UI布局约束
    [self.poetryAuthorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.poetryTitleLabel.mas_bottom).offset(10);//元素顶部约束
        make.leading.equalTo(self.view.mas_leading).offset(15);//元素左侧约束
        make.trailing.equalTo(self.view.mas_trailing).offset(-15);//元素右侧约束
        make.height.mas_equalTo(20);//元素高度
    }];
    
    
    
    self.poetryContentLabel = [[UILabel alloc]init];
    self.poetryContentLabel.text = @"床前明月光\n疑是地上霜\n举头望明月\n低头思故乡";
    self.poetryContentLabel.numberOfLines = 0;
    self.poetryContentLabel.textAlignment = NSTextAlignmentCenter;
    self.poetryContentLabel.font = [UIFont systemFontOfSize:self.contentFontSize];//字号设置
    [self.view addSubview:self.poetryContentLabel];
    //设置UI布局约束
    [self.poetryContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.poetryAuthorLabel.mas_bottom).offset(10);//元素顶部约束
        make.leading.equalTo(self.view.mas_leading).offset(15);//元素左侧约束
        make.trailing.equalTo(self.view.mas_trailing).offset(-15);//元素右侧约束
        make.height.mas_equalTo(120);//元素高度
    }];
    
    //颜色赋予初始值
    self.poetryTitleLabel.textColor = self.textColor;
    self.poetryAuthorLabel.textColor = self.textColor;
    self.poetryContentLabel.textColor = self.textColor;

    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.backgroundColor = NavigationColor;
    [sureBtn addTarget:self action:@selector(sureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)needShowColorSelector{
    
    [self.pickerView showColorPicker];
    self.coverView.hidden = NO;

}

- (void)fontChangeWithSliderAciton:(UISlider*)slider
{
    float value = slider.value;
    
    if (slider == self.titleFontSlider) {
        
        self.tipLabel.text = [NSString stringWithFormat:@"标题字号 %.0f",value];
        self.poetryTitleLabel.font = [UIFont systemFontOfSize:value];//字号设置
        self.titleFontSize = value;
        
    }else if (slider == self.authorFontSlider){
        self.authorLabel.text = [NSString stringWithFormat:@"作者字号 %.0f",value];
        self.poetryAuthorLabel.font = [UIFont systemFontOfSize:value];//字号设置
        self.authorFontSize = value;
        
    }else if (slider == self.contentFontSlider){
        self.contentLabel.text = [NSString stringWithFormat:@"内容字号 %.0f",value];
        self.poetryContentLabel.font = [UIFont systemFontOfSize:value];//字号设置
        self.contentFontSize = value;
    }
    
}

- (void)sureButtonAction:(UIButton*)sender
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.titleFontSize] forKey:@"poetryTitleFont"];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.authorFontSize] forKey:@"poetryAuthorFont"];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.contentFontSize] forKey:@"poetryContentFont"];
    
    [WLSaveLocalHelper saveObject:dic forKey:UserPoetryConfigure];
    
    [WLSaveLocalHelper saveReadTextRGB:self.selectColorString];
    [self showHUDWithText:@"设置成功"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
        [self.navigationController popViewControllerAnimated:YES];
    });
}



#pragma mark - 点击事件

- (void)backAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)tapTheCover{
    [self.pickerView hideColorPicker];
    self.coverView.hidden = YES;
}
- (void)finishSelectColor:(UIColor*)color withColorString:(NSString*)colorString{
    self.colorTipView.backgroundColor = color;
    self.poetryTitleLabel.textColor = color;
    self.poetryAuthorLabel.textColor = color;
    self.poetryContentLabel.textColor = color;
    
    self.coverView.hidden = YES;
    
    self.selectColorString = colorString;
}

- (WLColorPickerView*)pickerView{
    if (!_pickerView) {
        self.coverView = [[UIView alloc]init];
        self.coverView.backgroundColor = RGBCOLOR(50, 50, 50, 0.5);
        self.coverView.userInteractionEnabled = YES;
        self.coverView.frame = CGRectMake(0, 0, PhoneScreen_WIDTH, PhoneScreen_HEIGHT);
        [self.view addSubview:self.coverView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTheCover)];
        [self.coverView addGestureRecognizer:tap];
        
        _pickerView = [[WLColorPickerView alloc]init];
        __weak typeof(self) weakSelf = self;
        [_pickerView finishSelectWithCompletion:^(UIColor * _Nonnull color,NSString *colorString) {
            [weakSelf finishSelectColor:color withColorString:colorString];
        }];
        [self.view addSubview:_pickerView];
    }
    return _pickerView;
}

- (void)dealloc{
    NSLog(@"WLFontController dealloc");
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
