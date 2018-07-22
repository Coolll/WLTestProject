//
//  WLCustomImageListController.m
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/7/13.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLCustomImageListController.h"
#import "WLShowImageController.h"
#import "WLImageListController.h"

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
/**
 *  空的图片
 **/
@property (nonatomic,strong) UIImageView *noImageView;



/**
 *  是否为编辑状态
 **/
@property (nonatomic,assign) BOOL isEditing;

/**
 *  编辑
 **/
@property (nonatomic,strong) UIImageView *editImage;
/**
 *  编辑按钮
 **/
@property (nonatomic,strong) UIButton *editBtn;




@end

@implementation WLCustomImageListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewBackgroundColor;
    self.titleForNavi = @"我的题画";
    
    [self loadCustomData];
}
//需要两个元素 新建与编辑
- (void)loadTwoEditItem
{
    
    UIImageView *addImage = [[UIImageView alloc]init];
    addImage.image = [UIImage imageNamed:@"addImage"];
    [self.naviView addSubview:addImage];
    //元素的布局
    [addImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.naviView.mas_bottom).offset(-10);
        make.right.equalTo(self.naviView.mas_right).offset(-25);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
        
    }];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor clearColor]];
    [self.naviView addSubview:btn];
    //元素的布局
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(addImage.mas_left).offset(-5);
        make.top.equalTo(addImage.mas_top).offset(-10);
        make.bottom.equalTo(self.naviView.mas_bottom).offset(0);
        make.right.equalTo(self.naviView.mas_right).offset(0);
        
    }];

    
    self.editImage = [[UIImageView alloc]init];
    self.editImage.image = [UIImage imageNamed:@"editImage"];
    [self.naviView addSubview:self.editImage];
    //元素的布局
    [self.editImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.naviView.mas_bottom).offset(-10);
        make.right.equalTo(btn.mas_left).offset(-10);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
        
    }];
    
    
    self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.editBtn addTarget:self action:@selector(editButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.editBtn setBackgroundColor:[UIColor clearColor]];
    [self.naviView addSubview:self.editBtn];
    //元素的布局
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.editImage.mas_left).offset(-10);
        make.top.equalTo(self.editImage.mas_top).offset(-10);
        make.bottom.equalTo(self.naviView.mas_bottom).offset(0);
        make.right.equalTo(self.editImage.mas_right).offset(5);
        
    }];
}


- (void)addButtonAction:(UIButton*)sender
{
    WLImageListController *vc = [[WLImageListController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [vc saveImageWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imageArray removeAllObjects];
            self.imageArray = [NSMutableArray arrayWithArray:[WLSaveLocalHelper loadCustomImageArray]];
            
            if (self.imageArray.count > 0) {
                self.editImage.hidden = NO;
                self.editBtn.hidden = NO;
            }
            self.mainCollection.backgroundColor = ViewBackgroundColor;
            [self.mainCollection reloadData];
            
        });
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)editButtonAction:(UIButton*)sender
{
    NSLog(@"编辑");
    self.isEditing = YES;
    self.mainCollection.backgroundColor = ViewBackgroundColor;
    [self.mainCollection reloadData];
}


- (void)loadCustomData
{
    [self loadTwoEditItem];
    self.isEditing = NO;
    self.imageArray = [NSMutableArray arrayWithArray:[WLSaveLocalHelper loadCustomImageArray]];
    [self loadEmptyLikeView];
    
    if (self.imageArray.count == 0) {
        self.editImage.hidden = YES;
        self.editBtn.hidden = YES;
    }else{
        [self loadCustomView];
    }
    
    
}

- (void)loadEmptyLikeView
{
    
    CGFloat imageH = 60;
    CGFloat imageW = 60;
    CGFloat labelH = 40;
    CGFloat itemSpace = 10;
    
    self.noImageView = [[UIImageView alloc]init];
    self.noImageView.image = [UIImage imageNamed:@"noImage"];
    [self.view addSubview:self.noImageView];
    //元素的布局
    [self.noImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset((PhoneScreen_WIDTH-imageW)/2);
        make.top.equalTo(self.view.mas_top).offset((PhoneScreen_HEIGHT-imageH-labelH-64-itemSpace)/2);
        make.width.mas_equalTo(imageW);
        make.height.mas_equalTo(imageH);
    }];
    
    self.noLabel = [[UILabel alloc]init];
    self.noLabel.text = @"暂无题画";//设置文本
    self.noLabel.textColor = RGBCOLOR(200, 200, 200, 1.0);
    self.noLabel.font = [UIFont boldSystemFontOfSize:20];//字号设置
    self.noLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.noLabel];
    //设置UI布局约束
    [self.noLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.noImageView.mas_bottom).offset(itemSpace);//元素顶部约束
        make.leading.equalTo(self.view.mas_leading).offset(0);//元素左侧约束
        make.trailing.equalTo(self.view.mas_trailing).offset(0);//元素右侧约束
        make.height.mas_equalTo(labelH);//元素高度
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
    
    if (self.isEditing) {
        UIImageView *deleteImage = [[UIImageView alloc]init];
        deleteImage.image = [UIImage imageNamed:@"deleteImage"];
        [imageView addSubview:deleteImage];
        //元素的布局
        [deleteImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(imageView.mas_top).offset(10);
            make.right.equalTo(imageView.mas_right).offset(-10);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
            
        }];
        
        UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        imageView.userInteractionEnabled = YES;
        [clearBtn addTarget:self action:@selector(deleteImageAction:) forControlEvents:UIControlEventTouchUpInside];
        clearBtn.tag = 1000+indexPath.row;
        [imageView addSubview:clearBtn];
        //元素的布局
        [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(deleteImage.mas_left).offset(-10);
            make.top.equalTo(deleteImage.mas_top).offset(-10);
            make.bottom.equalTo(deleteImage.mas_bottom).offset(10);
            make.right.equalTo(deleteImage.mas_right).offset(10);
            
        }];
    }
    return cell;
}

- (void)deleteImageAction:(UIButton*)sender
{
    
    [self showAlert:@"是否删除此题画？" withBlock:^(BOOL sure) {
       
        if (sure) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSInteger index = sender.tag-1000;
                NSLog(@"index:%ld",index);
                NSString *imageName = self.imageArray[index];
                
                [[WLPublicTool shareTool] deleteImageWithName:imageName];
                [WLSaveLocalHelper deleteCustomImageWithName:imageName];
                [self.imageArray removeObjectAtIndex:index];
                [self.mainCollection reloadData];
                
                if (self.imageArray.count == 0) {
                    self.mainCollection.hidden = YES;
                    self.editImage.hidden = YES;
                    self.editBtn.hidden = YES;
                }else{
                    self.mainCollection.hidden = NO;
                }

                
            });
        }
    }];
    
    
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
