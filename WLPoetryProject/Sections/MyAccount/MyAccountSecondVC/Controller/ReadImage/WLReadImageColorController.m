//
//  WLReadImageColorController.m
//  WLPoetryProject
//
//  Created by 龙培 on 2020/10/13.
//  Copyright © 2020 龙培. All rights reserved.
//

#import "WLReadImageColorController.h"
#import "WLReadImagePreviewController.h"
static const CGFloat imageLeftSpace = 15;
static const CGFloat imageItemSpace = 20;
static const NSInteger cellCount = 3;

@interface WLReadImageColorController ()
/**
 *  主collection
 **/
@property (nonatomic, strong) UICollectionView *mainCollection;
/**
 *  颜色数组
 **/
@property (nonatomic, strong) NSMutableArray *colorArray;
/**
 *  保存图片的block
 **/
@property (nonatomic,copy) SelectReadColorBlock selectBlock;

@end

@implementation WLReadImageColorController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewBackgroundColor;
    self.titleForNavi = @"背景色";
    [self loadCustomData];
}

- (void)loadCustomData{
    self.colorArray = [NSMutableArray array];
//等比例组合 不太合适
//    NSArray *originArray = @[@"0",@"85",@"170",@"255"];
//    NSString *color = @"";
//    for (int i = 0; i < originArray.count; i++) {
//        NSString *currentRed = [originArray objectAtIndex:i];
//        for (int j = 0;j < originArray.count; j++ ) {
//            NSString *currentGreen = [originArray objectAtIndex:j];
//            for (int k = 0;k < originArray.count; k++ ) {
//                NSString *currentBlue = [originArray objectAtIndex:k];
//                color = [NSString stringWithFormat:@"%@,%@,%@",currentRed,currentGreen,currentBlue];
//                [self.colorArray addObject:color];
//            }
//        }
//    }

    
    [self.colorArray addObject:@"250,249,222"];
    [self.colorArray addObject:@"255,242,226"];
    [self.colorArray addObject:@"253,230,224"];
    [self.colorArray addObject:@"227,237,205"];
    [self.colorArray addObject:@"220,226,241"];
    [self.colorArray addObject:@"233,235,254"];
    [self.colorArray addObject:@"234,234,239"];
    [self.colorArray addObject:@"241,229,201"];
    [self.colorArray addObject:@"199,237,204"];
    [self.colorArray addObject:@"247,239,220"];
    [self.colorArray addObject:@"65,80,98"];
    [self.colorArray addObject:@"65,68,65"];
    [self.colorArray addObject:@"106,121,98"];
    [self.colorArray addObject:@"197,165,98"];
    [self.colorArray addObject:@"213,198,172"];
    [self.colorArray addObject:@"181,238,205"];
    [self.colorArray addObject:@"85,123,205"];
    [self.colorArray addObject:@"135,255,8"];
    [self.colorArray addObject:@"32,56,90"];
    [self.colorArray addObject:@"202,241,241"];
    [self.colorArray addObject:@"245,245,245"];
    [self.colorArray addObject:@"234,234,239"];
    [self.colorArray addObject:@"53,34,69"];
    [self.colorArray addObject:@"234,234,239"];
    [self.colorArray addObject:@"64,84,84"];
    [self.colorArray addObject:@"86,97,114"];

    [self loadCustomView];
}
- (void)loadCustomView{
    self.mainCollection.backgroundColor = ViewBackgroundColor;
}

#pragma mark - UICollectionView  代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.colorArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *colorRGB = self.colorArray[indexPath.row];
    
    static NSString *cellIdentifier = @"WLImageCollectionViewCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = ViewBackgroundColor;
    
    CGFloat space = imageLeftSpace*2+imageItemSpace*(cellCount-1);
    CGFloat itemW = (PhoneScreen_WIDTH-space)/cellCount;
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(0, 0, itemW, itemW);
    NSArray *array = [colorRGB componentsSeparatedByString:@","];
    if (array.count == 3) {
        NSInteger red = [[array objectAtIndex:0] integerValue];
        NSInteger green = [[array objectAtIndex:1] integerValue];
        NSInteger blue = [[array objectAtIndex:2] integerValue];
        imageView.backgroundColor = RGBCOLOR(red, green, blue, 1);
    }
    [cell addSubview:imageView];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *colorRGB = self.colorArray[indexPath.row];

    WLReadImagePreviewController *vc = [[WLReadImagePreviewController alloc]init];
    vc.imageColorString = colorRGB;
    vc.type = PreviewTypeColor;
    [vc configureUI];
    [vc saveImageWithBlock:^{
        if (self.selectBlock) {
            self.selectBlock();
        }
    }];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 属性
- (UICollectionView*)mainCollection
{
    if (!_mainCollection) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        
        CGFloat space = imageLeftSpace*2+imageItemSpace*(cellCount-1);
        CGFloat itemW = (PhoneScreen_WIDTH-space)/cellCount;
        
        flowLayout.itemSize = CGSizeMake(itemW, itemW);
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 15;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _mainCollection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _mainCollection.delegate = self;
        _mainCollection.dataSource = self;
        [_mainCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"WLImageCollectionViewCell"];
        [self.view addSubview:_mainCollection];
        
        
        if (@available(iOS 11.0, *)) {
            
            //设置UI布局约束
            [_mainCollection mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(self.naviView.mas_bottom).offset(0);//元素顶部约束
                make.leading.equalTo(self.view.mas_leading).offset(0);//元素左侧约束
                make.trailing.equalTo(self.view.mas_trailing).offset(0);//元素右侧约束
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);//元素底部约束
                
            }];
        }else{
            
            //设置UI布局约束
            [_mainCollection mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(self.naviView.mas_bottom).offset(0);//元素顶部约束
                make.leading.equalTo(self.view.mas_leading).offset(0);//元素左侧约束
                make.trailing.equalTo(self.view.mas_trailing).offset(0);//元素右侧约束
                make.bottom.equalTo(self.view.mas_bottom).offset(0);//元素底部约束
                
            }];
        }
        
        
    }
    return _mainCollection;
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
