//
//  WLCustomImageListController.m
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/7/13.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLCustomImageListController.h"
#import "WLShowImageController.h"

static const CGFloat imageLeftSpace = 15;
static const CGFloat imageItemSpace = 20;
static const NSInteger cellCount = 3;

@interface WLCustomImageListController ()<UICollectionViewDelegate,UICollectionViewDataSource>
/**
 *  主collection
 **/
@property (nonatomic, strong) UICollectionView *mainCollection;

/**
 *  图片数组
 **/
@property (nonatomic, strong) NSMutableArray *imageArray;
/**
 *  空的数据
 **/
@property (nonatomic, strong) UILabel *noLabel;

@end

@implementation WLCustomImageListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewBackgroundColor;
    self.titleForNavi = @"我的题画";
    
    [self loadCustomData];
    
}

- (void)loadCustomData
{
    self.imageArray = [NSMutableArray arrayWithArray:[WLSaveLocalHelper loadCustomImageArray]];
    if (self.imageArray.count == 0) {
        [self loadEmptyLikeView];
    }else{
        [self loadCustomView];

    }
}

- (void)loadEmptyLikeView
{
    self.noLabel = [[UILabel alloc]init];
    self.noLabel.text = @"暂无题画";//设置文本
    self.noLabel.textColor = RGBCOLOR(200, 200, 200, 1.0);
    self.noLabel.font = [UIFont boldSystemFontOfSize:20];//字号设置
    self.noLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.noLabel];
    //设置UI布局约束
    [self.noLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).offset((PhoneScreen_HEIGHT-40-64)/2);//元素顶部约束
        make.leading.equalTo(self.view.mas_leading).offset(0);//元素左侧约束
        make.trailing.equalTo(self.view.mas_trailing).offset(0);//元素右侧约束
        make.height.mas_equalTo(40);//元素高度
    }];
}

- (void)loadCustomView
{
    self.mainCollection.backgroundColor = ViewBackgroundColor;
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
    CGFloat itemH = itemW*PhoneScreen_HEIGHT/PhoneScreen_WIDTH;
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(0, 0, itemW, itemH);
    imageView.image = [[WLPublicTool shareTool] loadDocumentImageWithName:imageName];
    [cell addSubview:imageView];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *imageName = self.imageArray[indexPath.row];
    UIImage *image = [[WLPublicTool shareTool]loadDocumentImageWithName:imageName];
    if (image) {
        WLShowImageController *vc = [[WLShowImageController alloc]init];
        vc.mainImage = image;
        [vc configureUI];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
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
        //        _mainCollection.collectionViewLayout = flowLayout;
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

@end
