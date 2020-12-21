//
//  WLImageController.m
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/6/25.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLReadEffectPreviewController.h"
#import "WLPoetryLabel.h"
#import "WLSaveLocalHelper.h"
#import "WLSettingController.h"
#import "WLReadEffectCenter.h"

@interface WLReadEffectPreviewController ()
/**
 *  图片
 **/
@property (nonatomic, strong) UIImageView *mainImageView;

/**
 *  文本内容
 **/
@property (nonatomic,strong) UIView *poetryView;

/**
 *  诗词内容
 **/
@property (nonatomic,copy) NSString *originPoetry;
/**
 *  数据源
 **/
@property (nonatomic, copy) NSArray *contentArray;
/**
 *  当前点击的index
 **/
@property (nonatomic, assign) NSInteger currentIndex;

/**
 *  开始的点，结束的点
 **/
@property (nonatomic, assign) CGPoint beginPoint,endPoint;

/**
 *  视图的左侧、顶部距离
 **/
@property (nonatomic, strong) NSMutableArray *leftArray;
@property (nonatomic, strong) NSMutableArray *topArray;

/**
 *  上次的位置
 **/
@property (nonatomic, assign) CGFloat lastLeft,lastTop;

/**
 *  保存按钮
 **/
@property (nonatomic, strong) UIButton *saveButton;
/**
 *  保存特效的block
 **/
@property (nonatomic,copy) SureSelectEffectBlock saveBlock;

@end

@implementation WLReadEffectPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleForNavi = @"静夜思";
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)updateTitleTextColor{
    NSString *colorConfig = [WLSaveLocalHelper fetchReadTextRGB];
    UIColor *textColor = RGBCOLOR(60, 60, 120, 1.0);
    
    if (kStringIsEmpty(colorConfig)) {

    }else{
        NSArray *array = [colorConfig componentsSeparatedByString:@","];
        if (array.count == 3) {
            NSInteger red = [[array objectAtIndex:0] integerValue];
            NSInteger green = [[array objectAtIndex:1] integerValue];
            NSInteger blue = [[array objectAtIndex:2] integerValue];
            textColor = RGBCOLOR(red, green, blue, 1);
        }
    }
    self.titleFullLabel.textColor = textColor;
}
- (void)configureUI
{
    [self loadMainBackImageView];//背景
    [self loadCustomEffect];
    [self addFullTitleLabel];//诗词名字 添加背景之后调用，否则会被背景图遮住
    [self addBackButtonForFullScreen];//返回按钮，需要最后添加
    [self updateTitleTextColor];

    [self loadCustomData];
    [self loadCustomView];
}

- (void)loadCustomEffect
{
    if ([self.effectType isEqualToString:@"snow"]) {
        [[WLReadEffectCenter shareCenter] loadSnowEffectWithSuperView:self.view];
    }else if ([self.effectType isEqualToString:@"flower"]) {
        [[WLReadEffectCenter shareCenter] loadFlowerEffectWithSuperView:self.view];
    }else if ([self.effectType isEqualToString:@"mapleLeaf"]) {
        [[WLReadEffectCenter shareCenter] loadMapleLeafEffectWithSuperView:self.view];
    }else if ([self.effectType isEqualToString:@"plum"]) {
        [[WLReadEffectCenter shareCenter] loadEffectWithSuperView:self.view withType:WLEffectTypePlum];
    }else if ([self.effectType isEqualToString:@"rain"]) {
        [[WLReadEffectCenter shareCenter] loadEffectWithSuperView:self.view withType:WLEffectTypeRain];
    }else if ([self.effectType isEqualToString:@"meteor"]) {
        [[WLReadEffectCenter shareCenter] loadEffectWithSuperView:self.view withType:WLEffectTypeMeteor];
    }
}



- (void)loadCustomData
{
    self.currentIndex = 0;
    self.leftArray = [NSMutableArray array];
    self.topArray = [NSMutableArray array];
}

- (void)loadCustomView
{
    self.saveButton.backgroundColor = NavigationColor;
    [self loadHorizonView];
}



- (void)loadMainBackImageView
{
    //诗词主背景
    self.mainImageView = [[UIImageView alloc]init];
    self.mainImageView.contentMode = UIViewContentModeScaleToFill;
    self.mainImageView.userInteractionEnabled = YES;
    
    NSString *imageName = [WLSaveLocalHelper fetchReadImageURLOrRGB];

    if (imageName.length > 0 && ![imageName isEqualToString:@"<null>"] && ![imageName isEqualToString:@"(null)"]) {
        //这里暂时取消动态化的图片
        if ([imageName hasPrefix:@"http"] || [imageName hasPrefix:@"https"]) {
            [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:imageName]];
        }else if ([imageName containsString:@","]){
            NSArray *array = [imageName componentsSeparatedByString:@","];
            if (array.count == 3) {
                NSInteger red = [[array objectAtIndex:0] integerValue];
                NSInteger green = [[array objectAtIndex:1] integerValue];
                NSInteger blue = [[array objectAtIndex:2] integerValue];
                self.mainImageView.backgroundColor = RGBCOLOR(red, green, blue, 1);
            }else{
                self.mainImageView.image = [UIImage imageNamed:@"poetryBack.jpg"];
            }
        }else{
            self.mainImageView.image = [UIImage imageNamed:@"poetryBack.jpg"];
        }
    }else{
        self.mainImageView.image = [UIImage imageNamed:@"poetryBack.jpg"];
    }
        

    [self.view addSubview:self.mainImageView];
    
    //元素的布局
    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.view.mas_leading).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.trailing.equalTo(self.view.mas_trailing).offset(0);
        
    }];
    
}

#pragma mark - 创建诗词内容视图

- (void)loadHorizonView
{
    
    NSString *colorConfig = [WLSaveLocalHelper fetchReadTextRGB];
    UIColor *textColor = RGBCOLOR(60, 60, 120, 1.0);
    
    if (kStringIsEmpty(colorConfig)) {

    }else{
        NSArray *array = [colorConfig componentsSeparatedByString:@","];
        if (array.count == 3) {
            NSInteger red = [[array objectAtIndex:0] integerValue];
            NSInteger green = [[array objectAtIndex:1] integerValue];
            NSInteger blue = [[array objectAtIndex:2] integerValue];
            textColor = RGBCOLOR(red, green, blue, 1);
        }
    }

    CGFloat topSpace = 20;
    self.contentArray = @[@"床前明月光，",@"疑是地上霜。",@"举头望明月，",@"低头思故乡。"];
    for (int i =0; i< self.contentArray.count; i++) {
        
        NSString *content = [NSString stringWithFormat:@"%@",self.contentArray[i]];
        
        WLPoetryLabel *contentLabel = [[WLPoetryLabel alloc]initWithContent:content];
        contentLabel.font = [UIFont systemFontOfSize:16.f];
        contentLabel.textColor = textColor;
        contentLabel.userInteractionEnabled = YES;
        contentLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:contentLabel];
        
        CGFloat height = 28;
        CGFloat itemSpace = 2;
        //元素的布局
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.view.mas_leading).offset(20);
            make.trailing.equalTo(self.view.mas_trailing).offset(-20);
            make.top.equalTo(self.titleFullLabel.mas_bottom).offset(topSpace).priority(100);
            make.height.mas_equalTo(height);
        }];
                
        topSpace += height+itemSpace;
    }
    
}

- (void)saveEffectWithBlock:(SureSelectEffectBlock)block{
    if (block) {
        self.saveBlock = block;
    }
}

#pragma mark 保存
- (void)saveAction:(UIButton*)sender{
    NSLog(@"save");
   
    [WLSaveLocalHelper saveReadEffectType:self.effectType];
    
    [self showHUDWithText:@"设置成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[WLSettingController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    });
}
#pragma mark 完成按钮
- (UIButton*)saveButton
{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _saveButton.layer.cornerRadius = 25;
        [_saveButton setTitle:@"完成" forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
        _saveButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _saveButton.layer.borderWidth = 1.0f;
        [self.mainImageView addSubview:_saveButton];
        
        CGFloat btnW = PhoneScreen_WIDTH-80;
        if (@available(iOS 11.0, *)) {
            //设置UI布局约束
            [_saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-70);//元素顶部约束
                make.leading.equalTo(self.view.mas_leading).offset((PhoneScreen_WIDTH-btnW)/2);//元素左侧约束
                make.trailing.equalTo(self.view.mas_trailing).offset(-(PhoneScreen_WIDTH-btnW)/2);//元素右侧约束
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-20);//元素底部约束
            }];
        }else{
            //设置UI布局约束
            [_saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(self.view.mas_bottom).offset(-70);//元素顶部约束
                make.leading.equalTo(self.view.mas_leading).offset((PhoneScreen_WIDTH-btnW)/2);//元素左侧约束
                make.trailing.equalTo(self.view.mas_trailing).offset(-(PhoneScreen_WIDTH-btnW)/2);//元素右侧约束
                make.bottom.equalTo(self.view.mas_bottom).offset(-20);//元素底部约束
            }];
        }
    }
    
    return _saveButton;
    
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


