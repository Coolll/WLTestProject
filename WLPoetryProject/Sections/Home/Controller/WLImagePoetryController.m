//
//  WLImagePoetryController.m
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/6/27.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLImagePoetryController.h"
#import "WLImageSearchController.h"
#import "PoetryModel.h"
#import "WLTextView.h"

@interface WLImagePoetryController ()
/**
 *  内容view
 **/
@property (nonatomic, strong) UIView *contentView;
/**
 *  搜索
 **/
@property (nonatomic, strong) UIView *searchView;
/**
 *  输入框
 **/
@property (nonatomic, strong) WLTextView *inputTextView;

/**
 *  完成按钮
 **/
@property (nonatomic, strong) UIButton *finishBtn;

/**
 *  诗词完成编辑时的block
 **/
@property (nonatomic, copy) ImagePoetryFinishBlock finishBlock;

/**
 *  是否采取竖版
 **/
@property (nonatomic, strong) UIView *typeView;

/**
 *  排版的勾选框
 **/
@property (nonatomic,strong) UIImageView *checkBox;


@end

@implementation WLImagePoetryController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = ViewBackgroundColor;
        self.titleForNavi = @"题画内容";
        [self loadCustomData];
        [self loadCustomView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",NSStringFromSelector(_cmd));

    
}



- (void)loadCustomData
{
    NSLog(@"%@",NSStringFromSelector(_cmd));

    self.isVertical = YES;//默认垂直排版
}

- (void)loadCustomView
{
    NSLog(@"%@",NSStringFromSelector(_cmd));

    self.searchView.backgroundColor = [UIColor whiteColor];
    self.inputTextView.backgroundColor = [UIColor whiteColor];
//    self.typeView.backgroundColor = ViewBackgroundColor;
    self.finishBtn.backgroundColor = RGBCOLOR(80, 175, 240, 1.0);
    
}

- (void)setIsVertical:(BOOL)isVertical
{
    NSLog(@"%@",NSStringFromSelector(_cmd));

    _isVertical = isVertical;
    self.typeView.backgroundColor = ViewBackgroundColor;
    if (isVertical) {
        self.checkBox.image = [UIImage imageNamed:@"check_box_sel"];
    }else{
        self.checkBox.image = [UIImage imageNamed:@"check_box"];
    }
}


- (void)setPoetryString:(NSString *)poetryString
{
    NSLog(@"%@",NSStringFromSelector(_cmd));

    _poetryString = poetryString;
    self.searchView.backgroundColor = [UIColor whiteColor];

    if (poetryString.length > 0) {
        self.inputTextView.text = poetryString;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@",NSStringFromSelector(_cmd));

    HidenKeybory;
}


- (void)finishAction:(UIButton*)sender
{
    NSLog(@"%@",NSStringFromSelector(_cmd));

    NSLog(@"完成");
    
    if (self.inputTextView.text.length == 0) {
        
        [self showHUDWithText:@"请输入诗词内容"];
        return;
    }
    
    if (self.finishBlock) {
        self.finishBlock(self.inputTextView.text,self.isVertical);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 搜索诗词
- (void)searchInList:(UITapGestureRecognizer*)tap
{
    NSLog(@"%@",NSStringFromSelector(_cmd));

    if ([self.inputTextView isFirstResponder]) {
        [self.inputTextView resignFirstResponder];
    }
    
    WLImageSearchController *searchVC = [[WLImageSearchController alloc]init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [searchVC selectPoetryWithBlock:^(PoetryModel *model) {
        [self selSearchPoetry:model];
    }];
    [self.navigationController pushViewController:searchVC animated:YES];
    
}

- (void)finishEditContentWithBlock:(ImagePoetryFinishBlock)block
{
    NSLog(@"%@",NSStringFromSelector(_cmd));

    if (block) {
        self.finishBlock = block;
    }
}

#pragma mark - 从搜素的结果中选中后
- (void)selSearchPoetry:(PoetryModel*)model
{
    NSLog(@"%@",NSStringFromSelector(_cmd));

    self.inputTextView.text = model.content;
}

#pragma mark - 点击排版按钮
- (void)typeButtonAction:(UIButton*)sender
{
    NSLog(@"%@",NSStringFromSelector(_cmd));

    self.isVertical = !self.isVertical;
}
#pragma mark - Property属性
#pragma mark 搜索诗词
- (UIView*)searchView
{
    NSLog(@"%@",NSStringFromSelector(_cmd));

    if (!_searchView) {
        _searchView = [[UIView alloc]init];
        _searchView.layer.cornerRadius = 4.f;
        [self.view addSubview:_searchView];
        //设置UI布局约束
        [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.naviView.mas_bottom).offset(20);//元素顶部约束
            make.leading.equalTo(self.view.mas_leading).offset(15);//元素左侧约束
            make.trailing.equalTo(self.view.mas_trailing).offset(-15);//元素右侧约束
            make.height.mas_equalTo(50);//元素高度
        }];
        
        CGFloat iconW = 18;
        CGFloat arrowW = 10;
        CGFloat arrowH = 16;
        
        UIImageView *iconImageView = [[UIImageView alloc]init];
        iconImageView.image = [UIImage imageNamed:@"searchInList"];
        [_searchView addSubview:iconImageView];
        //元素的布局
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(_searchView.mas_leading).offset(10);
            make.top.equalTo(_searchView.mas_top).offset((50-iconW)/2);
            make.width.mas_equalTo(iconW);
            make.height.mas_equalTo(iconW);
            
        }];
        
        
        UILabel *tipLabel = [[UILabel alloc]init];
        tipLabel.text = @"搜索诗词";
        tipLabel.font = [UIFont systemFontOfSize:16.f];
        [_searchView addSubview:tipLabel];
        //元素的布局
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(iconImageView.mas_trailing).offset(10);
            make.top.equalTo(_searchView.mas_top).offset(0);
            make.bottom.equalTo(_searchView.mas_bottom).offset(0);
            make.trailing.equalTo(_searchView.mas_trailing).offset(-10-arrowW-10);
            
        }];
        
        
        UIImageView *arrow = [[UIImageView alloc]init];
        arrow.image = [UIImage imageNamed:@"myArrow"];
        [_searchView addSubview:arrow];
        //设置UI布局约束
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_searchView.mas_top).offset((50-arrowH)/2);//元素顶部约束
            make.leading.equalTo(tipLabel.mas_trailing).offset(10);//元素左侧约束
            make.width.mas_equalTo(arrowW);//元素宽度
            make.height.mas_equalTo(arrowH);//元素高度
        }];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchInList:)];
        [_searchView addGestureRecognizer:tap];
        _searchView.userInteractionEnabled = YES;
    }
    return _searchView;
}

#pragma mark 输入框，编辑框
- (UITextView*)inputTextView
{
    NSLog(@"%@",NSStringFromSelector(_cmd));

    if (!_inputTextView) {
        
        _inputTextView = [[WLTextView alloc]init];
        _inputTextView.layer.cornerRadius = 4.f;
        _inputTextView.font = [UIFont systemFontOfSize:16.f];
        [self.view addSubview:_inputTextView];
        
        //设置UI布局约束
        [_inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.searchView.mas_bottom).offset(20);//元素顶部约束
            make.leading.equalTo(self.naviView.mas_leading).offset(15);//元素左侧约束
            make.trailing.equalTo(self.naviView.mas_trailing).offset(-15);//元素右侧约束
            make.height.mas_equalTo(160);//元素高度
        }];
    }
    return _inputTextView;
}
#pragma mark 排版视图

- (UIView*)typeView
{
    NSLog(@"%@",NSStringFromSelector(_cmd));

    if (!_typeView) {
        _typeView = [[UIView alloc]init];
        _typeView.layer.cornerRadius = 4.f;
        [self.view addSubview:_typeView];
        //设置UI布局约束
        [_typeView mas_makeConstraints:^(MASConstraintMaker *make) {

            make.top.equalTo(self.inputTextView.mas_bottom).offset(15);//元素顶部约束
            make.leading.equalTo(self.inputTextView.mas_leading).offset(0);//元素左侧约束
            make.trailing.equalTo(self.inputTextView.mas_trailing).offset(0);//元素右侧约束
            make.height.mas_equalTo(30);//元素高度
        }];



        CGFloat imageW = 18;
        _checkBox = [[UIImageView alloc]init];
        [_typeView addSubview:_checkBox];
        //元素的布局
        [_checkBox mas_makeConstraints:^(MASConstraintMaker *make) {

            make.leading.equalTo(_typeView.mas_leading).offset(0);
            make.top.equalTo(_typeView.mas_top).offset((30-imageW)/2);
            make.width.mas_equalTo(imageW);
            make.height.mas_equalTo(imageW);

        }];

        UILabel *tipLabel = [[UILabel alloc]init];
        tipLabel.text = @"垂直排版";
        [_typeView addSubview:tipLabel];
        //元素的布局
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {

            make.leading.equalTo(_checkBox.mas_trailing).offset(15);
            make.top.equalTo(_typeView.mas_top).offset(0);
            make.bottom.equalTo(_typeView.mas_bottom).offset(0);
            make.trailing.equalTo(_typeView.mas_trailing).offset(0);

        }];

        UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [typeBtn addTarget:self action:@selector(typeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_typeView addSubview:typeBtn];
        //元素的布局
        [typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {

            make.leading.equalTo(_typeView.mas_leading).offset(0);
            make.top.equalTo(_typeView.mas_top).offset(0);
            make.bottom.equalTo(_typeView.mas_bottom).offset(0);
            make.trailing.equalTo(_typeView.mas_trailing).offset(0);

        }];
    }
    return _typeView;
}

#pragma mark 完成按钮
- (UIButton*)finishBtn
{
    NSLog(@"%@",NSStringFromSelector(_cmd));

    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _finishBtn.layer.cornerRadius = 6.f;
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_finishBtn addTarget:self action:@selector(finishAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_finishBtn];
        
        if (@available(iOS 11.0, *)) {
            //设置UI布局约束
            [_finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-69);//元素顶部约束
                make.leading.equalTo(self.view.mas_leading).offset(15);//元素左侧约束
                make.trailing.equalTo(self.view.mas_trailing).offset(-15);//元素右侧约束
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-20);//元素底部约束
            }];
        }else{
            //设置UI布局约束
            [_finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(self.view.mas_bottom).offset(-69);//元素顶部约束
                make.leading.equalTo(self.view.mas_leading).offset(15);//元素左侧约束
                make.trailing.equalTo(self.view.mas_trailing).offset(-15);//元素右侧约束
                make.bottom.equalTo(self.view.mas_bottom).offset(-20);//元素底部约束
            }];
        }
        
        
    }
    
    return _finishBtn;
    
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
