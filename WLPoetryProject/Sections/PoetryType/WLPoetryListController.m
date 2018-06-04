//
//  WLPoetryListController.m
//  WLPoetryProject
//
//  Created by 龙培 on 2018/5/7.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLPoetryListController.h"
#import "WLCoreDataHelper.h"
#import "PoetryModel.h"
#import "WLPoetryListCell.h"
#import "PoetryDetailViewController.h"

@interface WLPoetryListController ()<UITableViewDataSource,UITableViewDelegate>
/**
 *  诗词列表
 **/
@property (nonatomic,strong) UITableView *mainTableView;

/**
 *  诗词数据源
 **/
@property (nonatomic,strong) NSArray *poetryArray;
/**
 *  高度数组
 **/
@property (nonatomic,strong) NSMutableArray *heightArray;

/**
 *  当前类型 本地json文件名
 **/
@property (nonatomic,copy) NSString *jsonName;
/**
 *  当前类型 的mainClass
 **/
@property (nonatomic,copy) NSString *mainClass;




@end

@implementation WLPoetryListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)setSource:(PoetrySource)source
{
    _source = source;
    switch (source) {
        case PoetrySourceGradeOne:
        {
            
            self.titleForNavi = @"一年级";
            self.jsonName = @"gradePoetry_1";
            self.mainClass = @"1";
        }
            break;
        case PoetrySourceGradeTwo:
        {
            
            self.titleForNavi = @"二年级";
            self.jsonName = @"gradePoetry_2";
            self.mainClass = @"2";
        }
            break;
            
        case PoetrySourceGradeThree:
        {
            
            self.titleForNavi = @"三年级";
            self.jsonName = @"gradePoetry_3";
            self.mainClass = @"3";
        }
            break;
            
        case PoetrySourceGradeFour:
        {
            
            self.titleForNavi = @"四年级";
            self.jsonName = @"gradePoetry_4";
            self.mainClass = @"4";
        }
            break;
            
        case PoetrySourceGradeFive:
        {
            
            self.titleForNavi = @"五年级";
            self.jsonName = @"gradePoetry_5";
            self.mainClass = @"5";
        }
            break;
            
        case PoetrySourceGradeSix:
        {
            
            self.titleForNavi = @"六年级";
            self.jsonName = @"gradePoetry_6";
            self.mainClass = @"6";
        }
            break;
        case PoetrySourceGradeSevenOne:
        {
            
            self.titleForNavi = @"七年级上";
            self.jsonName = @"gradePoetry_7_one";
            self.mainClass = @"7";
        }
            break;
            
        case PoetrySourceGradeSevenTwo:
        {
            
            self.titleForNavi = @"七年级下";
            self.jsonName = @"gradePoetry_7_two";
            self.mainClass = @"7.5";
        }
            break;
            
        case PoetrySourceGradeEightOne:
        {
            
            self.titleForNavi = @"八年级上";
            self.jsonName = @"gradePoetry_8_one";
            self.mainClass = @"8";
        }
            break;
            
        case PoetrySourceGradeEightTwo:
        {
            
            self.titleForNavi = @"八年级下";
            self.jsonName = @"gradePoetry_8_two";
            self.mainClass = @"8.5";
        }
            break;
            
        case PoetrySourceGradeNineOne:
        {
            
            self.titleForNavi = @"九年级上";
            self.jsonName = @"gradePoetry_9_one";
            self.mainClass = @"9";
        }
            break;
            
        case PoetrySourceGradeNineTwo:
        {
            
            self.titleForNavi = @"九年级下";
            self.jsonName = @"gradePoetry_9_two";
            self.mainClass = @"9.5";
        }
            break;
        case PoetrySourceTangOne:
        {
            
            self.titleForNavi = @"唐诗·一";
            self.jsonName = @"tangPoetry_one";
            self.mainClass = @"10";
        }
        break;

        case PoetrySourceTangTwo:
        {
            
            self.titleForNavi = @"唐诗·二";
            self.jsonName = @"tangPoetry_two";
            self.mainClass = @"11";
        }
        break;
        
        case PoetrySourceTangThree:
        {
            
            self.titleForNavi = @"唐诗·三";
            self.jsonName = @"tangPoetry_three";
            self.mainClass = @"12";
        }
        break;
        
        case PoetrySourceTangFour:
        {
            
            self.titleForNavi = @"唐诗·四";
            self.jsonName = @"tangPoetry_four";
            self.mainClass = @"13";
        }
        break;
        
        case PoetrySourceTangFive:
        {
            
            self.titleForNavi = @"唐诗·五";
            self.jsonName = @"tangPoetry_five";
            self.mainClass = @"14";
        }
        break;
        
        case PoetrySourceTangSix:
        {
            
            self.titleForNavi = @"唐诗·六";
            self.jsonName = @"tangPoetry_six";
            self.mainClass = @"15";
        }
        break;
        
        case PoetrySourceTangSeven:
        {
            
            self.titleForNavi = @"唐诗·七";
            self.jsonName = @"tangPoetry_seven";
            self.mainClass = @"16";
        }
        break;
        
        case PoetrySourceSongOne:
        {
            
            self.titleForNavi = @"宋词·一";
            self.jsonName = @"songPoetry_one";
            self.mainClass = @"17";
        }
        break;
        
        
        case PoetrySourceSongTwo:
        {
            
            self.titleForNavi = @"宋词·二";
            self.jsonName = @"songPoetry_two";
            self.mainClass = @"18";
        }
        break;
        
        case PoetrySourceSongThree:
        {
            
            self.titleForNavi = @"宋词·三";
            self.jsonName = @"songPoetry_three";
            self.mainClass = @"19";
        }
        break;
        
        case PoetrySourceSongFour:
        {
            
            self.titleForNavi = @"宋词·四";
            self.jsonName = @"songPoetry_four";
            self.mainClass = @"20";
        }
        break;
        
        case PoetrySourceSongFive:
        {
            
            self.titleForNavi = @"宋词·五";
            self.jsonName = @"songPoetry_five";
            self.mainClass = @"21";
        }
        break;
        
        case PoetrySourceSongSix:
        {
            
            self.titleForNavi = @"宋词·六";
            self.jsonName = @"songPoetry_six";
            self.mainClass = @"22";
        }
        break;
        
        case PoetrySourceSongSeven:
        {
            
            self.titleForNavi = @"宋词·七";
            self.jsonName = @"songPoetry_seven";
            self.mainClass = @"23";
        }
        break;
        
        case PoetrySourceSongEight:
        {
            
            self.titleForNavi = @"宋词·八";
            self.jsonName = @"songPoetry_eight";
            self.mainClass = @"24";
        }
        break;
        
        case PoetrySourceSongNine:
        {
            
            self.titleForNavi = @"宋词·九";
            self.jsonName = @"songPoetry_nine";
            self.mainClass = @"25";
        }
        break;
        
        case PoetrySourceSongTen:
        {
            
            self.titleForNavi = @"宋词·十";
            self.jsonName = @"songPoetry_ten";
            self.mainClass = @"26";
        }
        break;
        
        
        
        default:
            break;
    }
    
    [self loadCustomData];

}
- (void)loadCustomData
{
    self.heightArray = [NSMutableArray array];
    
    self.poetryArray = [[WLCoreDataHelper shareHelper] fetchPoetryWithMainClass:self.mainClass];
    
    if (self.poetryArray.count == 0) {
        //从本地读取文件
        NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.jsonName ofType:@"json"]];
        //转为dic
        NSDictionary *poetryDic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
        //        NSLog(@"dic:%@",poetryDic);
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
        //        [[WLCoreDataHelper shareHelper] deleteAllPoetry];
    }
    
    
    
}

- (void)fetchPoetryAndShowView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.poetryArray = [[WLCoreDataHelper shareHelper] fetchPoetryWithMainClass:self.mainClass];
        [self loadCustomView];
    });
    
}



#pragma mark - 加载视图
- (void)loadCustomView
{
    UIImageView *mainBgView = [[UIImageView alloc]init];
    mainBgView.image = [UIImage imageNamed:@"mainBgImage"];
    [self.view addSubview:mainBgView];
    //元素的布局
    [mainBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.naviView.mas_bottom).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        
    }];
    
    self.mainTableView = [[UITableView alloc]init];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.mainTableView];
    
    //元素的布局
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.naviView.mas_bottom).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.poetryArray.count;
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
    if (self.heightArray.count > indexPath.row) {
        return [[self.heightArray objectAtIndex:indexPath.row] floatValue];
    }else{
        if (self.poetryArray.count > indexPath.row) {
            return [WLPoetryListCell heightForFirstLine:[self.poetryArray objectAtIndex:indexPath.row]];
        }
    }
    
    return 0.001;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PoetryModel *model = [self.poetryArray objectAtIndex:indexPath.row];
    
    
    WLPoetryListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WLPoetryListCell"];;
    if (!cell) {
        cell = [[WLPoetryListCell alloc]initWithFrame:CGRectMake(0, 0, PhoneScreen_WIDTH, 125)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.dataModel = model;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.poetryArray.count) {
        
        PoetryDetailViewController *detailVC = [[PoetryDetailViewController alloc]init];
        detailVC.dataModel = self.poetryArray[indexPath.row];
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}




#pragma mark - 点击事件

- (void)backAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
