//
//  WLClassInfoController.m
//  WLPoetryProject
//
//  Created by 变啦 on 2018/11/28.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLClassInfoController.h"

@interface WLClassInfoController ()
/**
 *  诗词量数组
 **/
@property (nonatomic,copy) NSArray *numberArray;


@end

@implementation WLClassInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleForNavi = @"等级说明";
    self.view.backgroundColor = ViewBackgroundColor;
    [self loadCustomData];
}

- (void)loadCustomData
{
    self.numberArray = [NSArray arrayWithObjects:@"0~199",@"200~699",@"700~1299",@"1300~1999",@"2000~2799",@"2800~3699",@"3700~4499",@"4500+", nil];
}

- (void)loadCustomView
{
    CGFloat classW,titleW,numberW,prizeW;
    CGFloat allW = PhoneScreen_WIDTH-30;
    classW = allW*0.2;
    titleW = allW*0.2;
    numberW = allW*0.4;
    prizeW = allW*0.2;
    
    for (int i =0 ; i <= self.titleArray.count; i++) {
        
        UILabel *classLabel, *titleLabel ,*numberLabel,*prizeLabel;
        UIImageView *prizeImageView;
        
        classLabel = [[UILabel alloc]init];
        [self.view addSubview:classLabel];
        
        titleLabel = [[UILabel alloc]init];
        [self.view addSubview:titleLabel];
        
        numberLabel = [[UILabel alloc]init];
        [self.view addSubview:numberLabel];
        
        if (i == 0) {
            classLabel.text = @"等级";
            titleLabel.text = @"称号";
            numberLabel.text = @"诗词量";
            
            prizeLabel = [[UILabel alloc]init];
            prizeLabel.text = @"勋章";
            prizeLabel.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:prizeLabel];
            //元素的布局
            [prizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.leading.equalTo(numberLabel.mas_trailing).offset(5);
                make.top.equalTo(classLabel.mas_top).offset(0);
                make.bottom.equalTo(classLabel.mas_bottom).offset(0);
                make.width.mas_equalTo(60*kWRate);
            }];
            
        }else{
            prizeImageView = [[UIImageView alloc]init];
            [self.view addSubview:prizeImageView];

            
            classLabel.text = [NSString stringWithFormat:@"LV %d",i];
            titleLabel.text = [self.titleArray objectAtIndex:(i-1)];
            numberLabel.text = [self.numberArray objectAtIndex:(i-1)];
            prizeImageView.image = [UIImage imageNamed:[self.imageArray objectAtIndex:(i-1)]];
            
        }
       
        
        //元素的布局
        [classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.view.mas_leading).offset(15);
            make.top.equalTo(self.naviView.mas_bottom).offset(30+30*i);
            make.width.mas_equalTo(classW);
            make.height.mas_equalTo(30);
            
        }];
        
        
        //元素的布局
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(classLabel.mas_trailing).offset(5);
            make.top.equalTo(classLabel.mas_top).offset(0);
            make.bottom.equalTo(classLabel.mas_bottom).offset(0);
            make.width.mas_equalTo(titleW);
            
        }];
        
        
        //元素的布局
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(titleLabel.mas_trailing).offset(5);
            make.top.equalTo(classLabel.mas_top).offset(0);
            make.bottom.equalTo(classLabel.mas_bottom).offset(0);
            make.width.mas_equalTo(numberW);
            
        }];
        
        
        
        
        //元素的布局
        [prizeImageView mas_makeConstraints:^(MASConstraintMaker *make) {

            make.leading.equalTo(numberLabel.mas_trailing).offset((prizeW-30)/2);
            make.top.equalTo(classLabel.mas_top).offset(0);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
        
        
        
    }
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
