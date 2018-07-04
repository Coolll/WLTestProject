//
//  WLImageController.m
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/6/25.
//  Copyright © 2018年 龙培. All rights reserved.
//

static const CGFloat itemWidth = 80;
static const CGFloat imageW = 20;

#import "WLImageController.h"
#import "WLImagePoetryController.h"
#import "WLPoetryLabel.h"
#import <Photos/Photos.h>


@interface WLImageController ()
/**
 *  图片
 **/
@property (nonatomic, strong) UIImageView *mainImageView;

/**
 *  文本内容
 **/
@property (nonatomic,strong) UIView *poetryView;

/**
 *  诗词内容
 **/
@property (nonatomic,copy) NSString *originPoetry;
/**
 *  数据源
 **/
@property (nonatomic, copy) NSArray *contentArray;
/**
 *  当前点击的index
 **/
@property (nonatomic, assign) NSInteger currentIndex;

/**
 *  开始的点，结束的点
 **/
@property (nonatomic, assign) CGPoint beginPoint,endPoint;

/**
 *  视图的左侧、顶部距离
 **/
@property (nonatomic, strong) NSMutableArray *leftArray;
@property (nonatomic, strong) NSMutableArray *topArray;

/**
 *  上次的位置
 **/
@property (nonatomic, assign) CGFloat lastLeft,lastTop;

/**
 *  保存按钮
 **/
@property (nonatomic, strong) UIButton *saveButton;
@end

@implementation WLImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleForNavi = @"题画";
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadMainBackImageView];//背景
    [self addFullTitleLabel];//诗词名字 添加背景之后调用，否则会被背景图遮住
    [self addBackButtonForFullScreen];//返回按钮，需要最后添加
    
    [self loadCustomData];
    [self loadCustomView];
}

- (void)loadCustomData
{
    self.currentIndex = 0;
    self.leftArray = [NSMutableArray array];
    self.topArray = [NSMutableArray array];
}

- (void)loadCustomView
{
    self.poetryView.backgroundColor = [UIColor clearColor];
}

- (void)loadMainBackImageView
{
    //诗词主背景
    self.mainImageView = [[UIImageView alloc]init];
    self.mainImageView.image = [UIImage imageNamed:@"poetryBack.jpg"];
    [self.view addSubview:self.mainImageView];
    
    //元素的布局
    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        
    }];
    
}

- (void)loadPoetryContentAction:(UIButton*)sender
{
    NSLog(@"push to poetry content");
    
//    NSArray *imageArray = @[[UIImage imageNamed:@"classNine.jpg"]];
//    [self shareWithImageArray:imageArray];
    
    WLImagePoetryController *vc = [[WLImagePoetryController alloc]init];
    vc.poetryString = self.originPoetry;
    if (self.direction == PoetryDirectionHorizon) {
        vc.isVertical = NO;
    }
    [vc finishEditContentWithBlock:^(NSString *poetryContent,BOOL isVertical) {
        [self loadPoetryContent:poetryContent withIsVertical:isVertical];
    }];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 完成的诗词内容
- (void)loadPoetryContent:(NSString*)string withIsVertical:(BOOL)isVertical
{
   
    self.originPoetry = string;
    
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[WLPoetryLabel class]]) {
            [subView removeFromSuperview];
        }
    }
    
    [self.leftArray removeAllObjects];
    [self.topArray removeAllObjects];
    
    self.contentArray = [[PublicTool tool]poetrySeperateWithOrigin:string];
    if (isVertical) {
        self.direction = PoetryDirectionVerticalLeft;
    }else{
        self.direction = PoetryDirectionHorizon;
    }
    
    [self loadPoetryContentView];
}


#pragma mark - 创建诗词内容视图
- (void)loadPoetryContentView
{
    switch (self.direction) {
            
        case PoetryDirectionHorizon:
        {
            [self loadHorizonView];
        }
            break;
            
        case PoetryDirectionVerticalLeft:
        {
            [self loadVerticalLeftView];
        }
            break;
            
        case PoetryDirectionVerticalRight:
        {
            [self loadVerticalRightView];
        }
            break;
            
        default:
            break;
    }
}


- (void)loadHorizonView
{
    CGFloat topSpace = 20;
    
    for (int i =0; i< self.contentArray.count; i++) {
        
        NSString *content = [NSString stringWithFormat:@"%@",self.contentArray[i]];
        
        WLPoetryLabel *contentLabel = [[WLPoetryLabel alloc]initWithContent:content];
        contentLabel.font = [UIFont systemFontOfSize:16.f];
        contentLabel.userInteractionEnabled = YES;
        contentLabel.tag = 1000+i;
        [self.view addSubview:contentLabel];
        
        CGFloat width = [PublicTool widthForTextString:content height:20 font:contentLabel.font];
        CGFloat height = 28;
        CGFloat itemSpace = 2;
        //元素的布局
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view.mas_left).offset((PhoneScreen_WIDTH-width)/2).priority(500);
            make.top.equalTo(self.titleFullLabel.mas_bottom).offset(topSpace).priority(100);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
            
        }];
        
        [self.leftArray addObject:[NSString stringWithFormat:@"%f",(PhoneScreen_WIDTH-width)/2]];
        [self.topArray addObject:[NSString stringWithFormat:@"%f",topSpace]];
        
        topSpace += height+itemSpace;
    }
    
    
}

- (void)loadVerticalLeftView
{
    CGFloat leftSpace = 20;
    
    for (int i =0; i< self.contentArray.count; i++) {
        
        NSString *content = [NSString stringWithFormat:@"%@",self.contentArray[i]];
        
        WLPoetryLabel *contentLabel = [[WLPoetryLabel alloc]initWithContent:content];
        contentLabel.font = [UIFont systemFontOfSize:16.f];
        contentLabel.userInteractionEnabled = YES;
        contentLabel.numberOfLines = 0;
        contentLabel.tag = 1000+i;
        [self.view addSubview:contentLabel];
        
        CGFloat width = 28;
        CGFloat height = [PublicTool heightForTextString:content width:width font:contentLabel.font];
        CGFloat itemSpace = 2;
        CGFloat topSpace = 80;
        //元素的布局
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view.mas_left).offset(leftSpace).priority(500);
            make.top.equalTo(self.titleFullLabel.mas_bottom).offset(topSpace).priority(100);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
            
        }];
        
        [self.leftArray addObject:[NSString stringWithFormat:@"%f",leftSpace]];
        [self.topArray addObject:[NSString stringWithFormat:@"%f",topSpace]];
        
        leftSpace += width+itemSpace;
    }
    
}

- (void)loadVerticalRightView
{
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    id touchView = touches.anyObject.view;
    if ([touchView isKindOfClass:[WLPoetryLabel class]]) {
        
        self.beginPoint = [touches.anyObject locationInView:self.view];
        WLPoetryLabel *label = (WLPoetryLabel*)touchView;
        self.currentIndex = label.tag;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.currentIndex > 0) {
        
        WLPoetryLabel *label = [self.view viewWithTag:self.currentIndex];
        CGFloat originLeft = [[self.leftArray objectAtIndex:self.currentIndex-1000] floatValue];
        CGFloat originTop = [[self.topArray objectAtIndex:self.currentIndex-1000] floatValue];
        CGPoint point = [touches.anyObject locationInView:self.view];
        
        CGFloat xOffset = point.x-self.beginPoint.x;
        CGFloat yOffset = point.y-self.beginPoint.y;
        
        [label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(originLeft+xOffset).priority(600);
            make.top.equalTo(self.titleFullLabel.mas_bottom).offset(originTop+yOffset).priority(200);
            self.lastTop = originTop+yOffset;
            self.lastLeft = originLeft+xOffset;
        }];
        
    }
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSInteger index = self.currentIndex-1000;
    //结束的时候，把位置信息更新了，否则下次移动的时候，位置不对了
    if (index < self.leftArray.count  && index < self.topArray.count) {
        [self.leftArray replaceObjectAtIndex:self.currentIndex-1000 withObject:[NSString stringWithFormat:@"%f",self.lastLeft]];
        [self.topArray replaceObjectAtIndex:self.currentIndex-1000 withObject:[NSString stringWithFormat:@"%f",self.lastTop]];
    }
   

    self.currentIndex = 0;
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.currentIndex = 0;
}

- (void)saveAction:(UIButton*)sender
{
    self.isShowBack = NO;
    self.poetryView.hidden = YES;
    self.saveButton.hidden = YES;
    
    UIImage *allImage = [self fullScreenShot];
    
    
    [self saveImageToLocal:allImage];
    
}

- (void)saveImageToLocal:(UIImage*)image
{
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        
        PHAssetCollection *collect = [[PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil] lastObject];
        
        PHAssetCollectionChangeRequest *collectRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collect];
        
        PHObjectPlaceholder *placeHolder = [collectRequest placeholderForCreatedAssetCollection];
        
        [collectRequest addAssets:@[placeHolder]];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        if (success) {
            NSLog(@"成功");
        }else{
            NSLog(@"失败：%@",error);
        }
        
    }];
}

//截取全屏 高效 支持Retina屏
- (UIImage*)fullScreenShot
{
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            CGContextConcatCTM(context, [window transform]);
            CGContextTranslateCTM(context, -[window bounds].size.width*[[window layer] anchorPoint].x, -[window bounds].size.height*[[window layer] anchorPoint].y);
            [[window layer] renderInContext:context];
            CGContextRestoreGState(context);
            
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}
#pragma mark - 属性
- (UIView*)poetryView
{
    if (!_poetryView) {
        _poetryView = [[UIView alloc]init];
        _poetryView.userInteractionEnabled = YES;
        self.mainImageView.userInteractionEnabled = YES;
        [self.mainImageView addSubview:_poetryView];
        //元素的布局
        [_poetryView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.titleFullLabel.mas_bottom).offset(20);
            make.right.equalTo(self.view.mas_right).offset(-20);
            make.width.mas_equalTo(itemWidth);
            make.height.mas_equalTo(itemWidth);
        }];
        
        UIImageView *poetryImage = [[UIImageView alloc]init];
        poetryImage.image = [UIImage imageNamed:@"poetryContent"];
        [_poetryView addSubview:poetryImage];
        //元素的布局
        [poetryImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_poetryView.mas_left).offset((itemWidth-imageW)/2);
            make.top.equalTo(_poetryView.mas_top).offset(15);
            make.width.mas_equalTo(imageW);
            make.height.mas_equalTo(imageW);
            
        }];
        
        UILabel *tipLabel = [[UILabel alloc]init];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.text = @"诗词内容";
        tipLabel.font = [UIFont systemFontOfSize:14.f];
        [_poetryView addSubview:tipLabel];
        //元素的布局
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_poetryView.mas_left).offset(0);
            make.top.equalTo(poetryImage.mas_bottom).offset(10);
            make.right.equalTo(_poetryView.mas_right).offset(0);
            make.height.mas_equalTo(20);
            
        }];
        
        UIButton *contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [contentBtn addTarget:self action:@selector(loadPoetryContentAction:) forControlEvents:UIControlEventTouchUpInside];
        contentBtn.enabled = YES;
        [_poetryView addSubview:contentBtn];
        //元素的布局
        [contentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_poetryView.mas_left).offset(0);
            make.top.equalTo(_poetryView.mas_top).offset(0);
            make.bottom.equalTo(_poetryView.mas_bottom).offset(0);
            make.right.equalTo(_poetryView.mas_right).offset(0);
            
        }];
    }
    return _poetryView;
}
#pragma mark 完成按钮
- (UIButton*)saveButton
{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _saveButton.layer.cornerRadius = 40.f;
        [_saveButton setTitle:@"完成" forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainImageView addSubview:_saveButton];
        
        if (@available(iOS 11.0, *)) {
            //设置UI布局约束
            [_saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-69);//元素顶部约束
                make.leading.equalTo(self.view.mas_leading).offset(15);//元素左侧约束
                make.trailing.equalTo(self.view.mas_trailing).offset(-15);//元素右侧约束
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-20);//元素底部约束
            }];
        }else{
            //设置UI布局约束
            [_saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(self.view.mas_bottom).offset(-69);//元素顶部约束
                make.leading.equalTo(self.view.mas_leading).offset(15);//元素左侧约束
                make.trailing.equalTo(self.view.mas_trailing).offset(-15);//元素右侧约束
                make.bottom.equalTo(self.view.mas_bottom).offset(-20);//元素底部约束
            }];
        }
        
        
    }
    
    return _saveButton;
    
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
