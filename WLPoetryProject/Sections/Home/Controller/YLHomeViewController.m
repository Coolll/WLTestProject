//
//  YLHomeViewController.m
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/1.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import "YLHomeViewController.h"
#import "WLCoreDataHelper.h"
#import "PoetryModel.h"
#import "WLHomePoetryCell.h"
#import "PoetryDetailViewController.h"
#import "WLImageCell.h"
#import "WLImageController.h"
#import "WLImageListController.h"
#import "WritePoetryController.h"

@interface YLHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

/**
 *  诗词列表
 **/
@property (nonatomic,strong) UITableView *mainTableView;
/**
 *  背景图片
 **/
@property (nonatomic,strong) UIImageView *mainBgView;


/**
 *  诗词数据源
 **/
@property (nonatomic,strong) NSArray *poetryArray;

/**
 *  高度数组
 **/
@property (nonatomic,strong) NSMutableArray *heightArray;
/**
 *  json是否读取的数组
 **/
@property (nonatomic,strong) NSMutableDictionary *jsonStateDic;



@end

@implementation YLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = ViewBackgroundColor;
    self.titleForNavi = @"热门推荐";
    [self loadCustomData];
    
    [self checkLocalData];//加载本地数据
}

- (void)loadCustomData
{
    self.heightArray = [NSMutableArray array];
    
    self.poetryArray = [[WLCoreDataHelper shareHelper] fetchPoetryWithMainClass:@"99"];

    if (self.poetryArray.count == 0) {
        //从本地读取文件
        NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"recommendPoetry" ofType:@"json"]];
        //转为dic
        NSDictionary *poetryDic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
        //获取到诗词列表
        NSArray *poetryArr = [poetryDic objectForKey:@"poetryList"];
        NSString *poetryMainClass = [poetryDic objectForKey:@"mainClass"];

        NSMutableArray *modelArray = [NSMutableArray array];
        //将诗词model化
        for (int i = 0; i<poetryArr.count; i++) {
            NSDictionary *itemDic = [poetryArr objectAtIndex:i];
            PoetryModel *model = [[PoetryModel alloc]initModelWithDictionary:itemDic];
            model.mainClass = poetryMainClass;
            [modelArray addObject:model];
        }
        
        //存储到本地数据库
        [[WLCoreDataHelper shareHelper]saveInBackgroundWithPeotryModelArray:modelArray withResult:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                //存储成功后读取然后展示
                [self fetchPoetryAndShowView];
                
            }
        }];
    }else{
        
        //直接展示数据
        [self loadCustomView];
    }
    
    
}

- (void)fetchPoetryAndShowView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.poetryArray = [[WLCoreDataHelper shareHelper] fetchPoetryWithMainClass:@"99"];
        [self loadCustomView];
    });
   
}

- (void)readSoure
{
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"file" ofType:@".txt"];
    NSString *testSource = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *poetryArr = [testSource componentsSeparatedByString:@"======"];
    
    NSMutableArray *modelArray = [NSMutableArray array];
    for (int i = 0; i<poetryArr.count; i++) {
        NSArray *items = [[NSString stringWithFormat:@"%@",[poetryArr objectAtIndex:i]] componentsSeparatedByString:@"&&&"];
        PoetryModel *model = [[PoetryModel alloc]init];
        model.name = [items objectAtIndex:0];
        model.author = [items objectAtIndex:1];
        model.content = [items objectAtIndex:2];
        [modelArray addObject:model];
    }
    
    [[WLCoreDataHelper shareHelper]saveInBackgroundWithPeotryModelArray:modelArray withResult:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            
            
        }
    }];
    
    self.poetryArray = [[WLCoreDataHelper shareHelper] fetchAllPoetry];
    
    [self loadCustomView];
    
}

#pragma mark - 加载视图
- (void)loadCustomView
{
    
    self.mainTableView.backgroundColor = RGBCOLOR(246, 246, 246, 1.0);

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return self.poetryArray.count;
    }
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 30;
    }
    return 0.01;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        //第二个section为热门诗词
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, PhoneScreen_WIDTH, 30)];
        headerView.backgroundColor = RGBCOLOR(246, 246, 246, 1.0);
        
        UILabel *poetryTipLabel = [[UILabel alloc]init];
        poetryTipLabel.text = @"热门·诗词";
        poetryTipLabel.font = [UIFont systemFontOfSize:14.f];
        poetryTipLabel.textColor = RGBCOLOR(100, 100, 100, 1.0);
        [headerView addSubview:poetryTipLabel];
        //元素的布局
        [poetryTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(headerView.mas_left).offset(15);
            make.top.equalTo(headerView.mas_top).offset(5);
            make.right.equalTo(headerView.mas_right).offset(-15);
            make.height.mas_equalTo(20);
            
        }];
        
        UIImageView *writeImage = [[UIImageView alloc]init];
        writeImage.image = [UIImage imageNamed:@"writePoetry"];
        [headerView addSubview:writeImage];
        //元素的布局
        [writeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(headerView.mas_top).offset(6);
            make.right.equalTo(headerView.mas_right).offset(-60);
            make.width.mas_equalTo(18);
            make.height.mas_equalTo(18);
            
        }];
        
        UILabel *writeLabel = [[UILabel alloc]init];
        writeLabel.text = @"创作";
        writeLabel.font = [UIFont systemFontOfSize:14.f];
        writeLabel.textColor = RGBCOLOR(100, 100, 100, 1.0);
        [headerView addSubview:writeLabel];
        //元素的布局
        [writeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(writeImage.mas_right).offset(5);
            make.top.equalTo(headerView.mas_top).offset(0);
            make.bottom.equalTo(headerView.mas_bottom).offset(0);
            make.right.equalTo(headerView.mas_right).offset(-15);
            
        }];
        
        UIButton *writeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [writeBtn addTarget:self action:@selector(writePoetryAction:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:writeBtn];
        //元素的布局
        [writeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(writeImage.mas_left).offset(-10);
            make.top.equalTo(headerView.mas_top).offset(0);
            make.bottom.equalTo(headerView.mas_bottom).offset(-0);
            make.right.equalTo(headerView.mas_right).offset(0);
           
            
        }];
        
        return headerView;
        
    }
    
    return nil;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if (section == 0) {
        //图片的高度
        CGFloat imageW = PhoneScreen_WIDTH-30;
        CGFloat imageH = imageW/2.88;//图片的比例是750：260
        //10 20 5 image 5 20
        return imageH+40;
        
        
    }else if (section == 1){
        
        //如果有缓存的高度，则不计算了
        if (self.heightArray.count > indexPath.row) {
            return [[self.heightArray objectAtIndex:indexPath.row] floatValue];
        }else{
            //没有缓存的高度，则需要计算
            if (self.poetryArray.count > indexPath.row) {
                
                if (indexPath.row == self.poetryArray.count-1) {
                    //最后一行需要调整一下间距
                    CGFloat cellHeight = [WLHomePoetryCell heightForLastCell:[self.poetryArray objectAtIndex:indexPath.row]];
                    [self.heightArray addObject:[NSString stringWithFormat:@"%f",cellHeight]];
                    return cellHeight;
                }else{
                    CGFloat cellHeight = [WLHomePoetryCell heightForFirstLine:[self.poetryArray objectAtIndex:indexPath.row]];
                    
                    if (indexPath.row == 0) {
                        cellHeight -= 25;
                    }
                    [self.heightArray addObject:[NSString stringWithFormat:@"%f",cellHeight]];
                    return cellHeight;
                }
            }
        }
    }
    
    
    
    return 0.001;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger section = indexPath.section;
    if (section == 0) {
        
        WLImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WLImageCell"];
        if (!cell) {
            cell = [[WLImageCell alloc]init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        [cell touchImageWithBlock:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self tapTheImage];
            });
        }];
        
        [cell loadCustomView];
        return cell;
        
    }else if (section == 1){
        PoetryModel *model = [self.poetryArray objectAtIndex:indexPath.row];
        WLHomePoetryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WLHomePoetryCell"];;
        if (!cell) {
            cell = [[WLHomePoetryCell alloc]initWithFrame:CGRectMake(0, 0, PhoneScreen_WIDTH, 125)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        if (indexPath.row == self.poetryArray.count-1) {
            cell.isLast = YES;
        }
        if (indexPath.row == 0) {
            cell.isFirst = YES;
        }
        cell.dataModel = model;
        return cell;
    }
    
    
    return [[UITableViewCell alloc]init];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;

    if (section == 1) {
        //选中诗词的时候，跳转到详情
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (indexPath.row < self.poetryArray.count) {
            
            PoetryDetailViewController *detailVC = [[PoetryDetailViewController alloc]init];
            detailVC.dataModel = self.poetryArray[indexPath.row];
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
   
}
#pragma mark - 点击事件
- (void)writePoetryAction:(UIButton*)sender
{
    WritePoetryController *vc = [[WritePoetryController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)tapTheImage
{
    WLImageListController *vc = [[WLImageListController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 后台进程，添加所有的数据
- (void)checkLocalData
{
    NSArray *jsonList = [NSArray array];
    jsonList = [AppConfig config].allPoetryList;
    
    NSDictionary *jsonStateDic = [WLSaveLocalHelper loadObjectForKey:@"PoetryJsonStateDic"];
    self.jsonStateDic = [NSMutableDictionary dictionary];
    
    if (jsonStateDic && [jsonStateDic isKindOfClass:[NSDictionary class]] && jsonStateDic.allKeys.count == jsonList.count ) {
        
        self.jsonStateDic = [jsonStateDic mutableCopy];
        
        for (int i = 0; i < jsonStateDic.allKeys.count ;i++) {
            NSString *state = jsonStateDic.allValues[i];
            int time = 4*i;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
                if (![state isEqualToString:@"1"]) {
                    [self readLocalFileWithName:jsonList[i] withKey:jsonStateDic.allKeys[i]];
                }
                
            });
            
        }
        
    }else{
        
        for (int i =0 ; i < jsonList.count; i++) {
            NSString *key = [NSString stringWithFormat:@"%@",jsonList[i]];
            [self.jsonStateDic setObject:@"0" forKey:key];
        }
        
        for (int i = 0; i < self.jsonStateDic.allValues.count ;i++) {
            NSString *state = self.jsonStateDic.allValues[i];
            int time = 4*i;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
                if (![state isEqualToString:@"1"]) {
                    [self readLocalFileWithName:jsonList[i] withKey:self.jsonStateDic.allKeys[i]];
                }
                
            });
            
        }
        
        
        
    }
}

- (void)readLocalFileWithName:(NSString*)fileName withKey:(NSString*)key
{
    //从本地读取文件
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"json"]];
    //转为dic
    NSDictionary *poetryDic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    NSInteger baseId = [[NSString stringWithFormat:@"%@",[poetryDic objectForKey:@"baseID"]]integerValue];
    
    //获取到诗词列表
    NSArray *poetryArr = [poetryDic objectForKey:@"poetryList"];
    NSString *poetryMainClass = [poetryDic objectForKey:@"mainClass"];
    
    NSMutableArray *modelArray = [NSMutableArray array];
    //将诗词model化
    for (int i = 0; i<poetryArr.count; i++) {
        NSDictionary *itemDic = [poetryArr objectAtIndex:i];
        PoetryModel *model = [[PoetryModel alloc]initModelWithDictionary:itemDic];
        model.mainClass = poetryMainClass;
        model.poetryID = [NSString stringWithFormat:@"%ld",(unsigned long)([model.poetryID integerValue]+baseId)];
        [modelArray addObject:model];
    }
    
    //存储到本地数据库
    [[WLCoreDataHelper shareHelper]saveInBackgroundWithPeotryModelArray:modelArray withResult:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //存储成功后更新状态
            [self.jsonStateDic setObject:@"1" forKey:key];
            [WLSaveLocalHelper saveObject:[self.jsonStateDic copy] forKey:@"PoetryJsonStateDic"];
            
        }
    }];
    
}

- (UIImageView*)mainBgView
{
    if (!_mainBgView) {
        _mainBgView = [[UIImageView alloc]init];
        _mainBgView.alpha = 0.5;
        _mainBgView.contentMode = UIViewContentModeScaleAspectFill;
        _mainBgView.clipsToBounds = YES;
        [self.view addSubview:_mainBgView];
        //元素的布局
        [_mainBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view.mas_left).offset(0);
            make.top.equalTo(self.naviView.mas_bottom).offset(0);
            make.bottom.equalTo(self.view.mas_bottom).offset(-49);
            make.right.equalTo(self.view.mas_right).offset(0);
            
        }];
    }
    return _mainBgView;
}

- (UITableView*)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]init];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_mainTableView];
        

        //元素的布局
        [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view.mas_left).offset(0);
            make.top.equalTo(self.naviView.mas_bottom).offset(0);
            make.bottom.equalTo(self.view.mas_bottom).offset(-49);
            make.right.equalTo(self.view.mas_right).offset(0);
            
        }];
    }
    return _mainTableView;
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
