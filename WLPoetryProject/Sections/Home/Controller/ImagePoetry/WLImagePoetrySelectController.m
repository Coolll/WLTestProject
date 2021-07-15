//
//  WLImagePoetrySelectController.m
//  WLPoetryProject
//
//  Created by 龙培 on 2021/7/15.
//  Copyright © 2021 龙培. All rights reserved.
//

#import "WLImagePoetrySelectController.h"
#import "WLPoetrySelectModel.h"
#import "WLPoetrySelectCell.h"
@interface WLImagePoetrySelectController ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  数据
 **/
@property (nonatomic,strong) NSMutableArray *dataArray;
/**
 *  诗词列表
 **/
@property (nonatomic,strong) UITableView *mainTableView;
/**
 *  底部tool
 **/
@property (nonatomic,strong) UIView *bottomToolView;
/**
 *  全部选中
 **/
@property (nonatomic,assign) BOOL currentAllSelected;
/**
 *  底部全选
 **/
@property (nonatomic,strong) UIImageView *selectImageView;
/**
 *  全选label
 **/
@property (nonatomic,strong) UILabel *selectLabel;
/**
 *  反选
 **/
@property (nonatomic,strong) UIButton *changeButton;
/**
 *  完成
 **/
@property (nonatomic,strong) UIButton *finishBtn;
/**
 *  完成的回调
 **/
@property (nonatomic,copy) PoetrySelectBlock finishBlock;
@end

@implementation WLImagePoetrySelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleForNavi = @"选择内容";
    [self loadCustomData];
    [self loadCustomView];
}

- (void)loadCustomData{
    self.dataArray = [NSMutableArray array];
    NSArray *textArr = [[WLPublicTool shareTool]poetrySeperateWithOrigin:self.contentString];
    NSArray *originArr = [[WLPublicTool shareTool]poetrySeperateWithOrigin:self.originString];
    
    NSInteger lastFindIndex = 0;
    NSInteger count = 0;
    for (int i = 0 ; i < originArr.count; i++) {
        WLPoetrySelectModel *model = [[WLPoetrySelectModel alloc]init];
        model.isSelect = NO;
        model.contentString = [NSString stringWithFormat:@"%@",[originArr objectAtIndex:i]];
        
        if (lastFindIndex < textArr.count) {
            for (NSInteger j = lastFindIndex; j < textArr.count; j++) {
                NSString *selStr = [textArr objectAtIndex:j];
                if ([model.contentString isEqualToString:selStr]) {
                    model.isSelect = YES;
                    count += 1;
                    lastFindIndex = j;
                    break;
                }
            }
        }
        [self.dataArray addObject:model];
    }
    if (count == originArr.count) {
        self.currentAllSelected = YES;
    }else{
        self.currentAllSelected = NO;
    }
}


#pragma mark - 加载视图
- (void)loadCustomView
{
    self.mainTableView = [[UITableView alloc]init];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.backgroundColor = [UIColor clearColor];
    self.mainTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.mainTableView];
    
    if (@available(iOS 11.0, *)) {
        //元素的布局
        [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.view.mas_leading).offset(0);
            make.top.equalTo(self.naviView.mas_bottom).offset(0);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-49);
            make.trailing.equalTo(self.view.mas_trailing).offset(0);
        }];
    }else{
        //元素的布局
        [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.view.mas_leading).offset(0);
            make.top.equalTo(self.naviView.mas_bottom).offset(0);
            make.bottom.equalTo(self.view.mas_bottom).offset(-49);
            make.trailing.equalTo(self.view.mas_trailing).offset(0);
        }];
    }

    self.bottomToolView.backgroundColor = [UIColor whiteColor];
    

}

- (void)selectAllButtonAction:(UIButton*)sender{
    if (self.currentAllSelected) {
        //当前已经全选，那就全部不选
        for (WLPoetrySelectModel *model in self.dataArray) {
            model.isSelect = NO;
        }
        self.currentAllSelected = NO;
        [self.mainTableView reloadData];
        self.selectImageView.image = [UIImage imageNamed:@"unselectPoetryContent"];

    }else{
        //当前没有全选，那就全选
        for (WLPoetrySelectModel *model in self.dataArray) {
            model.isSelect = YES;
        }
        self.currentAllSelected = YES;
        [self.mainTableView reloadData];
        self.selectImageView.image = [UIImage imageNamed:@"selectPoetryContent"];

    }
}

- (void)changeSelectAction:(UIButton*)sender{
    //当前没有全选，那就全选
    NSInteger count = 0;
    for (WLPoetrySelectModel *model in self.dataArray) {
        if (model.isSelect) {
            model.isSelect = NO;
        }else{
            model.isSelect = YES;
            count += 1;
        }
    }
    if (count == self.dataArray.count) {
        self.currentAllSelected = YES;
        self.selectImageView.image = [UIImage imageNamed:@"selectPoetryContent"];

    }else{
        self.currentAllSelected = NO;
        self.selectImageView.image = [UIImage imageNamed:@"unselectPoetryContent"];
    }

    [self.mainTableView reloadData];
}

- (void)finishBtnAction:(UIButton*)sender{
    NSMutableString *string = [NSMutableString string];
    for (WLPoetrySelectModel *model in self.dataArray) {
        if (model.isSelect) {
            [string appendString:model.contentString];
        }
    }
    
    if (self.finishBlock) {
        self.finishBlock([string copy]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadPoetrySelectBlock:(PoetrySelectBlock)block{
    if (block) {
        self.finishBlock = block;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray) {
        return self.dataArray.count;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WLPoetrySelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WLPoetrySelectCell"];;
    if (!cell) {
        cell = [[WLPoetrySelectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WLPoetrySelectCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    if (self.dataArray && self.dataArray.count > 0) {
        
        if (indexPath.row < self.dataArray.count) {
            WLPoetrySelectModel *model = [self.dataArray objectAtIndex:indexPath.row];
            cell.textString = model.contentString;
            cell.isSelect = model.isSelect;
        }
        
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.dataArray && self.dataArray.count > indexPath.row) {
        WLPoetrySelectModel *model = self.dataArray[indexPath.row];
        if (model.isSelect) {
            model.isSelect = NO;
        }else{
            model.isSelect = YES;
        }
        
        [self.mainTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self checkAndUpdateBottomBtn];
    }
}

- (void)checkAndUpdateBottomBtn{
    NSInteger count = 0;
    for (WLPoetrySelectModel *model in self.dataArray) {
        if (model.isSelect) {
            count += 1;
        }
    }
    if (count == 0) {
        self.currentAllSelected = NO;
    }else if (count == self.dataArray.count){
        self.currentAllSelected = YES;
    }else {
        self.currentAllSelected = NO;
    }
    
    if (self.currentAllSelected) {
        self.selectImageView.image = [UIImage imageNamed:@"selectPoetryContent"];
    }else{
        self.selectImageView.image = [UIImage imageNamed:@"unselectPoetryContent"];
    }

    
}

- (UIView *)bottomToolView{
    if (!_bottomToolView) {
        _bottomToolView = [[UIView alloc]init];
        [self.view addSubview:_bottomToolView];
        //元素的布局
        [_bottomToolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(0);
            make.right.equalTo(self.view.mas_right).offset(0);
            make.top.equalTo(self.mainTableView.mas_bottom);
            make.bottom.equalTo(self.view.mas_bottom).offset(0);
        }];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, PhoneScreen_WIDTH, 1)];
        line.backgroundColor = NavigationColor;
        [_bottomToolView addSubview:line];
        
        self.selectImageView = [[UIImageView alloc]init];
        self.selectImageView.frame = CGRectMake(12, 12, 25, 25);
        [_bottomToolView addSubview:self.selectImageView];
        if (self.currentAllSelected) {
            self.selectImageView.image = [UIImage imageNamed:@"selectPoetryContent"];
        }else{
            self.selectImageView.image = [UIImage imageNamed:@"unselectPoetryContent"];
        }

        self.selectLabel = [[UILabel alloc]init];
        self.selectLabel.frame = CGRectMake(47, 12, 60, 25);
        self.selectLabel.text = @"全选";
        self.selectLabel.font = [UIFont systemFontOfSize:16];
        [_bottomToolView addSubview:self.selectLabel];
        
        UIButton *selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectAllBtn.frame = CGRectMake(0, 0, self.selectLabel.frame.origin.x+self.selectLabel.frame.size.width, 49);
        [selectAllBtn addTarget:self action:@selector(selectAllButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomToolView addSubview:selectAllBtn];

        self.changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.changeButton.frame = CGRectMake((PhoneScreen_WIDTH-60)/2, 0, 60, 49);
        [self.changeButton addTarget:self action:@selector(changeSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        self.changeButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.changeButton setTitleColor:RGBCOLOR(25, 19, 0, 1) forState:UIControlStateNormal];
        [self.changeButton setTitle:@"反选" forState:UIControlStateNormal];
        [_bottomToolView addSubview:self.changeButton];
        
        
        UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        finishBtn.frame = CGRectMake((PhoneScreen_WIDTH-92), 10, 80, 29);
        finishBtn.backgroundColor = NavigationColor;
        finishBtn.layer.cornerRadius = 14.5;
        [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [finishBtn addTarget:self action:@selector(finishBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomToolView addSubview:finishBtn];
        
    }
    return _bottomToolView;
}


@end
