//
//  YLHomeViewController.m
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/1.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import "YLHomeViewController.h"
#import "PoetryModel.h"
#import "WLHomePoetryCell.h"
#import "PoetryDetailViewController.h"
#import "WLImageCell.h"
#import "WLImageController.h"
#import "WLImageListController.h"
#import "WritePoetryController.h"
#import "BackupHelper.h"
#import "AESCipher.h"
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
@property (nonatomic,strong) NSMutableArray *poetryArray;

/**
 *  高度字典 key为poetryID，value为高度
 **/
@property (nonatomic,strong) NSMutableDictionary *heightDic;
/**
 *  json是否读取的数组
 **/
@property (nonatomic,strong) NSMutableDictionary *jsonStateDic;
/**
 *  图片是否加载的数组
 **/
@property (nonatomic,strong) NSMutableDictionary *imageStateDic;

/**
 *  network
 **/
@property (nonatomic,strong) NetworkHelper *networkHelper;
/**
 *  首页的题画背景URL
 **/
@property (nonatomic,copy) NSString *topImageURL;
/**
 *  完成的page
 **/
@property (nonatomic,assign) NSInteger finishLoadingCount;
/**
 *  是否正在网络请求，避免上拉时重复请求
 **/
@property (nonatomic,assign) BOOL isBackgroundRequesting;
/**
 *  page
 **/
@property (nonatomic,assign) NSInteger currentCount;
/**
 *  是否还有
 **/
@property (nonatomic,assign) BOOL hasNext;

/**
 *  当前的高度
 **/
@property (nonatomic,assign) CGFloat currentTableHeight;
/**
 *  背景色
 **/
@property (nonatomic,strong) UIColor *bgColor;
@end

@implementation YLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = ViewBackgroundColor;
    self.titleForNavi = @"热门推荐";
    self.networkHelper = [NetworkHelper shareHelper];

    [self loadCustomData];

    [[BackupHelper shareInstance] updateRecommendPoetry];//更新热门诗词

}


- (void)loadCustomData
{
    self.heightDic = [NSMutableDictionary dictionary];
    
    self.poetryArray = [NSMutableArray array];
    
    self.hasNext = YES;
    
    [self dealHomeTopImage];
    
    self.bgColor = RGBCOLOR(242, 246, 242, 1);
}

- (void)dealHomeTopImage{
    NSString *localImageURL = [WLSaveLocalHelper loadObjectForKey:@"HomeTopImageURLString"];
    if (kStringIsEmpty(localImageURL)) {
        self.topImageURL = @"";
    }else{
        self.topImageURL = [NSString stringWithFormat:@"%@",localImageURL];
    }
    
    [self requestHomeHotPoetry];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestHomeTopImage];
    });
}

- (void)requestHomeTopImage{
    __weak __typeof(self)weakSelf = self;
    [[NetworkHelper shareHelper] requestHomeTopImageWithCompletion:^(BOOL success, NSDictionary *dic, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;

        NSString *codeString = [NSString stringWithFormat:@"%@",[dic objectForKey:@"retCode"]];
        if ([codeString isEqualToString:@"1000"]) {
            NSArray *dataArr = [dic objectForKey:@"data"];
            if (dataArr.count > 0) {
                NSDictionary *dic = [dataArr firstObject];
                NSString *baseUrl = [dic objectForKey:@"image_base_url"];
                NSString *path = [dic objectForKey:@"origin_url"];
                strongSelf.topImageURL = [NSString stringWithFormat:@"%@%@",baseUrl,path];
                [WLSaveLocalHelper saveObject:[strongSelf.topImageURL copy] forKey:@"HomeTopImageURLString"];
            }
        }
    }];
}

- (void)requestHomeHotPoetry{
    __weak __typeof(self)weakSelf = self;
    [self.networkHelper requestHotPoetry:0 count:20 withCompletion:^(BOOL success, NSDictionary *dic, NSError *error) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSString *codeString = [NSString stringWithFormat:@"%@",[dic objectForKey:@"retCode"]];
        if ([codeString isEqualToString:@"1000"]) {
            NSArray *dataArr = [dic objectForKey:@"data"];
            NSMutableArray *randomArr = [NSMutableArray array];
           NSMutableArray *finalArr = [self loadRandomItemWithOriginArr:[dataArr mutableCopy] withRandomArr:randomArr];
            
            for (NSDictionary *poetryDic in finalArr) {
                PoetryModel *model = [[PoetryModel alloc]initPoetryWithDictionary:poetryDic];
                [strongSelf.poetryArray addObject:model];
            }
            if (dataArr && [dataArr isKindOfClass:[NSArray class]] && dataArr.count > 0 ) {
                strongSelf.hasNext = YES;
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf loadCustomView];
                [weakSelf calculateCurrentTableAllHeight];
            });
            
        }else{
            //从本地读取文件
            NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"recommendPoetry" ofType:@"json"]];
            //转为dic
            NSDictionary *poetryDic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
            //获取到诗词列表
            NSArray *poetryArr = [poetryDic objectForKey:@"poetryList"];
            NSString *poetryMainClass = [poetryDic objectForKey:@"mainClass"];
            
            //将诗词model化
            for (int i = 0; i<poetryArr.count; i++) {
                NSDictionary *itemDic = [poetryArr objectAtIndex:i];
                PoetryModel *model = [[PoetryModel alloc]initModelWithDictionary:itemDic];
                model.mainClass = poetryMainClass;
                [model loadFirstLineString];
                [strongSelf.poetryArray addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf loadCustomView];
            });
            
        }
        
    }];

}

#pragma mark - 加载视图
- (void)loadCustomView
{
    self.mainTableView.backgroundColor = self.bgColor;
    [self loadTableHeaderAndFooter];
}

- (void)loadTableHeaderAndFooter
{
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHomeData)];
}

- (void)refreshHomeData{
    NSLog(@"刷新数据了");
    __weak __typeof(self)weakSelf = self;
    [self.networkHelper requestHotPoetry:0 count:20 withCompletion:^(BOOL success, NSDictionary *dic, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.mainTableView.mj_header endRefreshing];
        
        NSString *codeString = [NSString stringWithFormat:@"%@",[dic objectForKey:@"retCode"]];
        if ([codeString isEqualToString:@"1000"]) {
            [strongSelf.poetryArray removeAllObjects];
            NSArray *dataArr = [dic objectForKey:@"data"];
            NSMutableArray *randomArr = [NSMutableArray array];
           NSMutableArray *finalArr = [self loadRandomItemWithOriginArr:[dataArr mutableCopy] withRandomArr:randomArr];
            
            for (NSDictionary *poetryDic in finalArr) {
                PoetryModel *model = [[PoetryModel alloc]initPoetryWithDictionary:poetryDic];
                [model loadFirstLineString];
                [strongSelf.poetryArray addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.currentCount = weakSelf.poetryArray.count;
                weakSelf.finishLoadingCount = weakSelf.poetryArray.count;
                [strongSelf.mainTableView reloadData];
                [weakSelf calculateCurrentTableAllHeight];

            });
            
        }
    }];
    
}


- (NSMutableArray*)loadRandomItemWithOriginArr:(NSMutableArray*)originArr withRandomArr:(NSMutableArray*)mutArr {
    if (originArr.count == 0) {
        return mutArr;
    }else{
        NSInteger random = arc4random()%(originArr.count);
        [mutArr addObject:[originArr objectAtIndex:random]];
        [originArr removeObjectAtIndex:random];
        return [self loadRandomItemWithOriginArr:originArr withRandomArr:mutArr];
    }
}

- (void)loadMoreData{
    if (self.isBackgroundRequesting) {
        //正在请求新的数据，则不需要再次请求
        return;
    }
    if (self.finishLoadingCount >= (self.currentCount+1)) {
        //已经完成了下一页的数据请求，则不请求了
        return;
    }
    
    if (!self.hasNext) {
        //已经没有数据了，不请求了
        return;
    }
    self.isBackgroundRequesting = YES;
    NSLog(@"加载更多:%ld",self.currentCount);
        
    [self requestHotPoetryMoreData];
}


- (void)requestHotPoetryMoreData{
    NSLog(@"加载更多");
    NSInteger count = self.poetryArray.count;
    __weak __typeof(self)weakSelf = self;
    
    [self.networkHelper requestHotPoetry:(count+1) count:20 withCompletion:^(BOOL success, NSDictionary *dic, NSError *error) {
        
        weakSelf.isBackgroundRequesting = NO;
        NSString *codeString = [NSString stringWithFormat:@"%@",[dic objectForKey:@"retCode"]];
        if ([codeString isEqualToString:@"1000"]) {
            NSArray *dataArr = [dic objectForKey:@"data"];
            NSMutableArray *randomArr = [NSMutableArray array];

            NSMutableArray *finalArr = [self loadRandomItemWithOriginArr:[dataArr mutableCopy] withRandomArr:randomArr];
             
             for (NSDictionary *poetryDic in finalArr) {
                 PoetryModel *model = [[PoetryModel alloc]initPoetryWithDictionary:poetryDic];
                 [model loadFirstLineString];
                 [weakSelf.poetryArray addObject:model];
             }
            if (dataArr && [dataArr isKindOfClass:[NSArray class]] && dataArr.count > 0 ) {
                self.hasNext = YES;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.currentCount = weakSelf.poetryArray.count;
                weakSelf.finishLoadingCount = weakSelf.poetryArray.count;
                [weakSelf.mainTableView reloadData];
                [weakSelf calculateCurrentTableAllHeight];
            });
            
        }
    }];
}

- (void)calculateCurrentTableAllHeight{
    self.currentTableHeight = 0;
    for (PoetryModel *model in self.poetryArray) {
        if (model.heightForCell > 0) {
            //如果有缓存的高度，则不计算了
            self.currentTableHeight += model.heightForCell;
        }else{
            CGFloat cellHeight = [WLHomePoetryCell heightForFirstLine:model];
            model.heightForCell = cellHeight;
            self.currentTableHeight += cellHeight;
        }
    }

}
#pragma mark - table代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.poetryArray.count+1;
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

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        //第二个section为热门诗词
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, PhoneScreen_WIDTH, 30)];
        headerView.backgroundColor = self.bgColor;
        
        UILabel *poetryTipLabel = [[UILabel alloc]init];
        poetryTipLabel.text = @"热门·诗词";
        poetryTipLabel.font = [UIFont systemFontOfSize:14.f];
        poetryTipLabel.textColor = RGBCOLOR(100, 100, 100, 1.0);
        [headerView addSubview:poetryTipLabel];
        //元素的布局
        [poetryTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(headerView.mas_leading).offset(15);
            make.top.equalTo(headerView.mas_top).offset(5);
            make.trailing.equalTo(headerView.mas_trailing).offset(-15);
            make.height.mas_equalTo(20);
            
        }];
        
        return headerView;
        
    }
    
    if (section != 0) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, PhoneScreen_WIDTH, 30)];
        headerView.backgroundColor = self.bgColor;
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
        CGFloat imageH = imageW/2.74;//图片的比例是1920：700
        //10 20 5 image 5 20
        return imageH+40;
        
        
    }else{
        
        //如果有缓存的高度，则不计算了
        
        PoetryModel *model = [self.poetryArray objectAtIndex:(section-1)];
        if (model.heightForCell > 0) {
            return model.heightForCell;
        }
        
        CGFloat cellHeight = [WLHomePoetryCell heightForFirstLine:[self.poetryArray objectAtIndex:(section-1)]];
        model.heightForCell = cellHeight;
        return cellHeight;
        
    }
    
    return 0.001;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if (section == 0) {
        
        WLImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WLImageCell"];
        if (!cell) {
            cell = [[WLImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WLImageCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = self.bgColor;
        }
        cell.imageURL = self.topImageURL;
        [cell touchImageWithBlock:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self tapTheImage];
            });
        }];
        
        [cell loadCustomView];
        return cell;
        
    }else {
        PoetryModel *model = [self.poetryArray objectAtIndex:(section-1)];
        WLHomePoetryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WLHomePoetryCell"];
        NSLog(@"=====cell:%@",cell);
        if (!cell) {
            cell = [[WLHomePoetryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WLHomePoetryCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = self.bgColor;
            cell.backgroundColor = self.bgColor;

            NSLog(@"====index:%ld %@",indexPath.section,cell);
        }
        if (indexPath.section == self.poetryArray.count) {
            cell.isLast = YES;
        }else{
            cell.isLast = NO;
        }
        if (indexPath.section == 0) {
            cell.isFirst = YES;
        }else{
            cell.isFirst = NO;
        }
        cell.dataModel = model;
        return cell;
    }
    
    
    return nil;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    
    if (section != 0) {
        //选中诗词的时候，跳转到详情
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if ((indexPath.section-1) < self.poetryArray.count) {
            
            PoetryDetailViewController *detailVC = [[PoetryDetailViewController alloc]init];
            detailVC.dataModelArray = self.poetryArray;
            detailVC.dataModel = self.poetryArray[(indexPath.section-1)];
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.currentTableHeight == 0) {
        [self calculateCurrentTableAllHeight];
    }
        

    CGFloat leftH = self.currentTableHeight-PhoneScreen_HEIGHT-scrollView.contentOffset.y+64;
    
    if (leftH < PhoneScreen_HEIGHT/2) {
        NSLog(@"需要加载");
        [self loadMoreData];
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
            
            make.leading.equalTo(self.view.mas_leading).offset(0);
            make.top.equalTo(self.naviView.mas_bottom).offset(0);
            make.bottom.equalTo(self.view.mas_bottom).offset(-49);
            make.trailing.equalTo(self.view.mas_trailing).offset(0);
            
        }];
    }
    return _mainBgView;
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
//        [_mainTableView registerClass:[WLHomePoetryCell class] forCellReuseIdentifier:@"WLHomePoetryCell"];
        [self.view addSubview:_mainTableView];
        

        //元素的布局
        [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.view.mas_leading).offset(0);
            make.top.equalTo(self.naviView.mas_bottom).offset(0);
            make.bottom.equalTo(self.view.mas_bottom).offset(-49);
            make.trailing.equalTo(self.view.mas_trailing).offset(0);
            
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
