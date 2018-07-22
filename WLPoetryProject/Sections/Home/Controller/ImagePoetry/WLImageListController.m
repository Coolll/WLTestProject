//
//  WLImageListController.m
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/7/5.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLImageListController.h"
#import "WLImageController.h"

static const CGFloat imageLeftSpace = 15;
static const CGFloat imageItemSpace = 20;
static const NSInteger cellCount = 3;

@interface WLImageListController ()<UICollectionViewDelegate,UICollectionViewDataSource>
/**
 *  主collection
 **/
@property (nonatomic, strong) UICollectionView *mainCollection;

/**
 *  图片数组
 **/
@property (nonatomic, strong) NSMutableArray *imageArray;

/**
 *  保存图片的block
 **/
@property (nonatomic,copy) ListSaveImageBlock saveBlock;
@end

@implementation WLImageListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewBackgroundColor;
    self.titleForNavi = @"选择题画";
    [self loadCustomData];
    [self loadCustomView];
}

- (void)loadCustomData
{
    self.imageArray = [NSMutableArray arrayWithArray:[AppConfig config].bgImageInfo.allValues];
    
//    [self.imageArray addObject:@"classOne.jpg"];
//    [self.imageArray addObject:@"classTwo.jpg"];
//    [self.imageArray addObject:@"classThree.jpg"];
//    [self.imageArray addObject:@"classFour.jpg"];
//    [self.imageArray addObject:@"classFive.jpg"];
//    [self.imageArray addObject:@"classSix.jpg"];
//    [self.imageArray addObject:@"classSeven.jpg"];
//    [self.imageArray addObject:@"classNine.jpg"];
//    [self.imageArray addObject:@"classTen.jpg"];
//    [self.imageArray addObject:@"classEleven.jpg"];
//    [self.imageArray addObject:@"classTwelve.jpg"];
//    [self.imageArray addObject:@"classFourteen"];
//    [self.imageArray addObject:@"classSixteen"];
//    [self.imageArray addObject:@"classThirtyOne.jpg"];
//    [self.imageArray addObject:@"classThirtyTwo.jpg"];
//    [self.imageArray addObject:@"classThirtySeven.jpg"];
//    [self.imageArray addObject:@"classOHTen.jpg"];
}

- (void)loadCustomView
{
    self.mainCollection.backgroundColor = ViewBackgroundColor;
}
- (void)saveImageWithBlock:(ListSaveImageBlock)block
{
    if (block) {
        self.saveBlock = block;
    }
}

#pragma mark - UICollectionView  代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *imageName = self.imageArray[indexPath.row];
    
    static NSString *cellIdentifier = @"WLImageCollectionViewCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = ViewBackgroundColor;
    
    CGFloat space = imageLeftSpace*2+imageItemSpace*(cellCount-1);
    CGFloat itemW = (PhoneScreen_WIDTH-space)/cellCount;
    CGFloat itemH = itemW*667.f/375.f;
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(0, 0, itemW, itemH);
//    imageView.image = [UIImage imageNamed:imageName];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageName]];
    [cell addSubview:imageView];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *imageName = self.imageArray[indexPath.row];

    WLImageController *vc = [[WLImageController alloc]init];
    vc.imageName = imageName;
    [vc configureUI];
    [vc saveImageWithBlock:^{
        if (self.saveBlock) {
            self.saveBlock();
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
        CGFloat itemH = itemW*667.f/375.f;
        
        flowLayout.itemSize = CGSizeMake(itemW, itemH);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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
