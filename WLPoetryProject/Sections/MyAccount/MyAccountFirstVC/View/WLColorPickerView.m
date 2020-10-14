//
//  WLColorPickerView.m
//  WLPoetryProject
//
//  Created by 龙培 on 2020/10/14.
//  Copyright © 2020 龙培. All rights reserved.
//

#import "WLColorPickerView.h"

@interface WLColorPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
/**
 *  背景色
 **/
@property (nonatomic,strong) UIView *coverView;
/**
 *  数据源
 **/
@property (nonatomic,strong) NSMutableArray *colorArray;
/**
 *  是否显示
 **/
@property (nonatomic,assign) BOOL isShowPicker;
/**
 *  颜色选择视图
 **/
@property (nonatomic,strong) UIView *pickerContentView;
/**
 *  picker
 **/
@property (nonatomic,strong) UIPickerView *pickerView;
/**
 *  完成的block
 **/
@property (nonatomic,copy) ColorPickerCompletionBlock finishBlock;
/**
 *  选中的index
 **/
@property (nonatomic,assign) NSInteger selectIndex;

@end

@implementation WLColorPickerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadCustomData];
        [self loadCustomView];
    }
    return self;
}

- (void)loadCustomData{
    self.isShowPicker = NO;
    
    self.colorArray = [NSMutableArray array];
    NSArray *originArray = @[@"0",@"85",@"170",@"255"];
    NSString *color = @"";
    for (int i = 0; i < originArray.count; i++) {
        NSString *currentRed = [originArray objectAtIndex:i];
        for (int j = 0;j < originArray.count; j++ ) {
            NSString *currentGreen = [originArray objectAtIndex:j];
            for (int k = 0;k < originArray.count; k++ ) {
                NSString *currentBlue = [originArray objectAtIndex:k];
                color = [NSString stringWithFormat:@"%@,%@,%@",currentRed,currentGreen,currentBlue];
                [self.colorArray addObject:color];
            }
        }
    }

}
- (void)loadCustomView{
    
    self.frame = CGRectMake(0, PhoneScreen_HEIGHT, PhoneScreen_WIDTH, (34+216+40));
    self.backgroundColor = RGBCOLOR(255, 255, 255, 1);
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = RGBCOLOR(220, 220, 220, 1);
    [self addSubview:topView];
    //元素的布局
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(34);
    }];

    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor:NavigationColor forState:UIControlStateNormal];
    [self addSubview:finishBtn];
    //元素的布局
    [finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(5);
        make.right.equalTo(self.mas_right).offset(-20);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(24);
    }];

    [finishBtn addTouchEvent:UIControlEventTouchUpInside withAction:^(UIButton *sender) {
        [self finishSelectColor];
    }];
    
    
    self.pickerView = [[UIPickerView alloc]init];
    self.pickerView.frame = CGRectMake(0, 34, PhoneScreen_WIDTH, 216);
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self addSubview:self.pickerView];
    
}

- (void)finishSelectWithCompletion:(ColorPickerCompletionBlock)block{
    if (block) {
        self.finishBlock = block;
    }
}

- (void)finishSelectColor{
    NSString *colorString = [self.colorArray objectAtIndex:self.selectIndex];
    NSArray *array = [colorString componentsSeparatedByString:@","];
    if (array.count == 3) {
        NSInteger red = [[array objectAtIndex:0] integerValue];
        NSInteger green = [[array objectAtIndex:1] integerValue];
        NSInteger blue = [[array objectAtIndex:2] integerValue];
        if (self.finishBlock) {
            self.finishBlock(RGBCOLOR(red, green, blue, 1),colorString);
        }
    }
    
    [self hideColorPicker];

}

- (void)showColorPicker{
    if (self.isShowPicker) {
        return;
    }
    
    [UIView animateWithDuration:0.35 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -290);
    }];
    
    self.isShowPicker = YES;
}

- (void)hideColorPicker{
    [UIView animateWithDuration:0.35 animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
    self.isShowPicker = NO;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.colorArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 60;
}
- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UIView *myView =[[UIView alloc]init];
    myView.frame = CGRectMake((PhoneScreen_WIDTH-100)/2, 0, 100, 60);
    NSString *colorString = [self.colorArray objectAtIndex:row];
    NSArray *array = [colorString componentsSeparatedByString:@","];
    if (array.count == 3) {
        NSInteger red = [[array objectAtIndex:0] integerValue];
        NSInteger green = [[array objectAtIndex:1] integerValue];
        NSInteger blue = [[array objectAtIndex:2] integerValue];
        myView.backgroundColor = RGBCOLOR(red, green, blue, 1);
    }

    return myView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.selectIndex = row;
}

@end
