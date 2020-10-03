//
//  WLHeaderImageController.m
//  WLPoetryProject
//
//  Created by 龙培 on 2020/6/8.
//  Copyright © 2020年 龙培. All rights reserved.
//

#import "WLHeaderImageController.h"
#import "WLHeadImageSelectCell.h"
@interface WLHeaderImageController ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  完成设置的回调
 **/
@property (nonatomic,copy) HeaderImageBlock finishBlock;
/**
 *  网络请求到的图片
 **/
@property (nonatomic,strong) NSMutableArray *networkImageArray;

/**
 *  头像列表
 **/
@property (nonatomic,strong) UITableView *mainTableView;
/**
 *  完成按钮
 **/
@property (nonatomic,strong) UIButton *finishButton;

/**
 *  上次选中的行
 **/
@property (nonatomic,copy) NSString *selectRowString;
/**
 *  上次选中的图片index
 **/
@property (nonatomic,copy) NSString *selectImageString;
/**
 *  选择的图片URL
 **/
@property (nonatomic,copy) NSString *selectImageUrl;
@end

@implementation WLHeaderImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleForNavi = @"设置头像";
    self.finishButton.backgroundColor = NavigationColor;
    self.view.backgroundColor = ViewBackgroundColor;
    [self loadCustomData];
}

- (void)loadCustomData{
    self.networkImageArray = [NSMutableArray array];
    self.selectRowString = @"";
    self.selectImageString = @"";
    
    __weak __typeof(self)weakSelf = self;
    [[AppConfig config] loadAllHeadImageWithBlock:^(NSArray *originArray, NSArray *thumbArray, NSError *error) {
        
        NSLog(@"原始图片:%@",originArray);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf dealImageData:originArray thumbArray:thumbArray];
    }];
    
}

- (void)dealImageData:(NSArray*)originArray thumbArray:(NSArray*)thumbArray{
    [self.networkImageArray addObjectsFromArray:originArray];
    [self.mainTableView reloadData];
}


- (void)finishSettingWithBlock:(HeaderImageBlock)block{
    if (block) {
        self.finishBlock = block;
    }
}

- (void)finishAction:(UIButton*)sender{
    __weak typeof(self) weakSelf = self;
    [[NetworkHelper shareHelper] updateUserHeadImage:self.selectImageUrl withCompletion:^(BOOL success, NSDictionary *dic, NSError *error) {
        
        if (success) {
            
            NSString *code = [NSString stringWithFormat:@"%@",[dic objectForKey:@"retCode"]];
            if (![code isEqualToString:@"1000"]) {
                NSString *tipMessage = [dic objectForKey:@"message"];
                [weakSelf showHUDWithText:tipMessage];
                return ;
            }
            
            if (weakSelf.finishBlock) {
                weakSelf.finishBlock(YES, weakSelf.selectImageUrl);
            }
            
            [weakSelf showHUDWithText:@"设置成功!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [weakSelf showHUDWithText:@"请求失败，请稍后重试"];
        }
    }];
}

#pragma mark - table代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.networkImageArray.count/3);
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
    if (section == 0) {
        return 0.01;
    }else if(section == 1){
        return 30;
    }
    return 15;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWith = (PhoneScreen_WIDTH-60)/3;
    return itemWith+20;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    WLHeadImageSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WLHeadImageSelectCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger baseIndex = row*3;
    if (baseIndex < self.networkImageArray.count) {
        cell.oneImageUrlString = [self.networkImageArray objectAtIndex:baseIndex];
    }
    
    if ((baseIndex+1) < self.networkImageArray.count) {
        cell.twoImageUrlString = [self.networkImageArray objectAtIndex:(baseIndex+1)];
    }
    
    if ((baseIndex+2) < self.networkImageArray.count) {
        cell.threeImageUrlString = [self.networkImageArray objectAtIndex:(baseIndex+2)];
    }

    
    cell.rowIndex = row;
    
    if (!kStringIsEmpty(self.selectRowString)) {
        BOOL contain = ([self.selectRowString integerValue]==row)?YES:NO;
        cell.containSelected = contain;
        if (!kStringIsEmpty(self.selectImageString)) {
            cell.currentSelectIndex = [self.selectImageString integerValue];
        }
    }
    
    __weak typeof(self) weakSelf = self;
    [cell loadCustomCellWithCompletion:^(NSInteger rowIndex, NSInteger currentIndex, NSString * _Nonnull imageUrl) {
        [weakSelf dealImageSelect:rowIndex withImageIndex:currentIndex withSelectUrl:imageUrl];
    }];
    
    return cell;
    
}

- (void)dealImageSelect:(NSInteger)row withImageIndex:(NSInteger)imageIndex withSelectUrl:(NSString*)imageUrl{
    self.selectImageString = [NSString stringWithFormat:@"%ld",imageIndex];
    if (!kStringIsEmpty(self.selectRowString)) {
        NSInteger lastRow = [self.selectRowString integerValue];
        
        self.selectRowString = [NSString stringWithFormat:@"%ld",row];
        [self.mainTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastRow inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    self.selectRowString = [NSString stringWithFormat:@"%ld",row];
    self.selectImageUrl = imageUrl;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableView*)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.estimatedRowHeight = 0;
        _mainTableView.estimatedSectionFooterHeight = 0;
        _mainTableView.estimatedSectionHeaderHeight = 0;
        [_mainTableView registerClass:[WLHeadImageSelectCell class] forCellReuseIdentifier:@"WLHeadImageSelectCell"];
        [self.view addSubview:_mainTableView];
        
        
        //元素的布局
        [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.view.mas_leading).offset(0);
            make.top.equalTo(self.naviView.mas_bottom).offset(0);
            make.bottom.equalTo(self.finishButton.mas_top).offset(0);
            make.trailing.equalTo(self.view.mas_trailing).offset(0);
        }];
    }
    return _mainTableView;
}

- (UIButton*)finishButton{
    if (!_finishButton) {
        _finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishButton addTarget:self action:@selector(finishAction:) forControlEvents:UIControlEventTouchUpInside];
        _finishButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_finishButton setTitle:@"完成" forState:UIControlStateNormal];
        [self.view addSubview:_finishButton];
        
        if (@available(iOS 11.0, *)) {
            //元素的布局
            [_finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.view.mas_safeAreaLayoutGuideLeading).offset(0);
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-49);
                make.bottom.equalTo(self.view.mas_bottom).offset(0);
                make.trailing.equalTo(self.view.mas_trailing).offset(0);
            }];
        }else{
            //元素的布局
            [_finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.view.mas_leading).offset(0);
                make.bottom.equalTo(self.view.mas_bottom).offset(0);
                make.trailing.equalTo(self.view.mas_trailing).offset(0);
                make.height.mas_equalTo(49);
            }];
        }

    }
    return _finishButton;
}
@end
