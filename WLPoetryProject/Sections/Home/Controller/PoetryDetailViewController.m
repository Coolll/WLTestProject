//
//  PoetryDetailViewController.m
//  WLPoetryProject
//
//  Created by 龙培 on 2018/4/23.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "PoetryDetailViewController.h"
#import "WLPoetryContentCell.h"

#import "RecitePoetryController.h"
#import "WLAnalysesView.h"
#import "WLLoginViewController.h"
#import "WLReadEffectCenter.h"
static const CGFloat leftSpace = 10;//诗句的左右间距
static const CGFloat topSpace = 15;//诗句与标题的上间距

@interface PoetryDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

/**
 *  诗词内容table
 **/
@property (nonatomic,strong) UITableView *mainTable;
/**
 *  诗词句子
 **/
@property (nonatomic,strong) NSArray *dataArray;
/**
 *  作者
 **/
@property (nonatomic,strong) UILabel *authorLabel;

/**
 *  是否收藏的图片
 **/
@property (nonatomic, strong) UIImageView *likeImage;
/**
 *  是否收藏
 **/
@property (nonatomic, assign) BOOL isLike;
/**
 *  喜欢的点击事件
 **/
@property (nonatomic, copy) LikeBlock likeBlock;

/**
 *  主图片背景
 **/
@property (nonatomic, strong) UIImageView *mainImageView;
/**
 *  文本颜色
 **/
@property (nonatomic,strong) UIColor *contentTextColor;

/**
 *  分析view
 **/
@property (nonatomic,strong) WLAnalysesView *analysesView;
/**
 *  当前是否展示分析视图
 **/
@property (nonatomic,assign) BOOL isShowAnalyseView;
/**
 *  鉴赏的image
 **/
@property (nonatomic,strong) UIImageView *analysesImage;



@end

@implementation PoetryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //背景图暂时取消 会影响滑动，微微有点卡顿
    self.view.backgroundColor = RGBCOLOR(243, 238, 214, 1.0);
    
    [self dealTextColor];
    
    self.titleForNavi = self.dataModel.name;
    [self loadMainBackImageView];//背景
    [self loadReadEffect];//特效
    
    [self addFullTitleLabel];//诗词名字 添加背景之后调用，否则会被背景图遮住

    [self loadCustomData];//加载数据
    
    [self addBackButtonForFullScreen];//返回按钮，需要最后添加
    
    
}

- (void)loadReadEffect{
    BOOL openEffect = [WLSaveLocalHelper fetchReadEffectOpen];
    if (openEffect) {
        NSString *effectType = [WLSaveLocalHelper fetchReadEffectType];
        if ([effectType isEqualToString:@"snow"]) {
            [[WLReadEffectCenter shareCenter] loadSnowEffectWithSuperView:self.view];
        }else if ([effectType isEqualToString:@"flower"]){
            [[WLReadEffectCenter shareCenter] loadFlowerEffectWithSuperView:self.view];
        }else if ([effectType isEqualToString:@"mapleLeaf"]){
            [[WLReadEffectCenter shareCenter] loadMapleLeafEffectWithSuperView:self.view];
        }else if ([effectType isEqualToString:@"plum"]){
            [[WLReadEffectCenter shareCenter] loadEffectWithSuperView:self.view withType:WLEffectTypePlum];
        }else if ([effectType isEqualToString:@"rain"]) {
            [[WLReadEffectCenter shareCenter] loadEffectWithSuperView:self.view withType:WLEffectTypeRain];
        }else if ([effectType isEqualToString:@"meteor"]) {
            [[WLReadEffectCenter shareCenter] loadEffectWithSuperView:self.view withType:WLEffectTypeMeteor];
        }
    }
}

- (void)dealTextColor{
    NSString *colorConfig = [WLSaveLocalHelper fetchReadTextRGB];
    self.contentTextColor = RGBCOLOR(60, 60, 120, 1.0);
    
    if (kStringIsEmpty(colorConfig)) {

    }else{
        NSArray *array = [colorConfig componentsSeparatedByString:@","];
        if (array.count == 3) {
            NSInteger red = [[array objectAtIndex:0] integerValue];
            NSInteger green = [[array objectAtIndex:1] integerValue];
            NSInteger blue = [[array objectAtIndex:2] integerValue];
            self.contentTextColor = RGBCOLOR(red, green, blue, 1);
        }
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    self.mainImageView.contentMode  = UIViewContentModeScaleToFill;
    [super viewWillDisappear:animated];
    if (self.likeBlock) {
        //点击收藏/取消收藏后，我的收藏列表的数据需要更新
        self.likeBlock(self.isLike,self.dataModel.poetryID);
    }
    
    NSArray *userLikeList = [WLSaveLocalHelper fetchLikeList];

    if (self.isLike) {
        if (userLikeList.count == 0) {
            [WLSaveLocalHelper saveLikeList:[NSArray arrayWithObject:self.dataModel.poetryID]];
        }
        
        BOOL isContain = NO;
        for (NSString *poetryID in userLikeList) {
            NSString *poetryIDString = [NSString stringWithFormat:@"%@",poetryID];
            //已经收藏了的诗词
            if ([poetryIDString isEqualToString:self.dataModel.poetryID]) {
                isContain = YES;
            }
        }
        
        if (!isContain) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:userLikeList];
            [array insertObject:self.dataModel.poetryID atIndex:0];
            [WLSaveLocalHelper saveLikeList:[array copy]];
        }
    }else{
        
        //原来喜欢 现在不喜欢了，要移除掉
        BOOL isContain = NO;
        for (NSString *poetryID in userLikeList) {
            NSString *poetryIDString = [NSString stringWithFormat:@"%@",poetryID];
            //已经收藏了的诗词
            if ([poetryIDString isEqualToString:self.dataModel.poetryID]) {
                isContain = YES;
            }
        }
        
        if (isContain) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:userLikeList];
            [array removeObject:self.dataModel.poetryID];
            [WLSaveLocalHelper saveLikeList:[array copy]];
            
        }
    }
}

- (void)setDataModel:(PoetryModel *)dataModel
{
    _dataModel = dataModel;
    
    id token = kUserToken;
    if (!token) {
        token = @"";
    }
    
    NSString *tokenString = [NSString stringWithFormat:@"%@",token];
    //如果本地没有token，那么就意味着用户没有登录，不需要去拿收藏列表,该数据为未收藏
    if (tokenString.length == 0) {
        self.isLike = NO;
        [self loadLikeButton];
        return;
    }
        
    NSArray *userLikeList = [WLSaveLocalHelper fetchLikeList];
    if (userLikeList.count == 0) {
        self.isLike = NO;
        [self loadLikeButton];
        return;
    }
    
    BOOL isContain = NO;
    for (NSNumber *poetryID in userLikeList) {
        NSString *poetryIdString = [NSString stringWithFormat:@"%@",poetryID];
        //已经收藏了的诗词
        if ([poetryIdString isEqualToString:self.dataModel.poetryID]) {
            self.isLike = YES;
            [self loadLikeButton];
            return;
        }
    }
    
    if (!isContain) {
        self.isLike = NO;
        [self loadLikeButton];
    }
    
}
#pragma mark - 初始化数据和视图

- (void)loadCustomData
{
    self.dataArray = [NSArray array];
    
    self.dataArray = [[WLPublicTool shareTool] poetrySeperateWithOrigin:self.dataModel.content];
    
    self.isShowAnalyseView = NO;
    
    [self loadPoetryAnalysesInfo];
    
    [self loadContentTableView];
    
}
- (void)loadPoetryAnalysesInfo{
    
    __weak __typeof(self)weakSelf = self;
    [[NetworkHelper shareHelper] loadAnalysesWithPoetryId:self.dataModel.poetryID withCompletion:^(BOOL success, NSDictionary *dic, NSError *error) {
        NSLog(@"鉴赏信息:%@",dic);
        __strong __typeof(weakSelf)strongSelf = weakSelf;

        if (success) {
            NSString *codeString = [NSString stringWithFormat:@"%@",[dic objectForKey:@"retCode"]];
            if ([codeString isEqualToString:@"1000"]) {
                NSDictionary *dataDic = [dic objectForKey:@"data"];
                strongSelf.dataModel.addtionInfo = [dataDic objectForKey:@"addition_info"];
                strongSelf.dataModel.analysesInfo = [dataDic objectForKey:@"analyses_info"];
                strongSelf.dataModel.backgroundInfo = [dataDic objectForKey:@"background_info"];
                strongSelf.dataModel.transferInfo = [dataDic objectForKey:@"transfer_info"];
            }
        }
        
    }];
}



- (void)loadMainBackImageView
{
    //诗词主背景
    self.mainImageView = [[UIImageView alloc]init];
    [self.view addSubview:self.mainImageView];
    self.mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.mainImageView.backgroundColor = RGBCOLOR(243, 238, 214, 1.0);
//    NSString *imageName = self.dataModel.backImageURL;
    NSString *imageName = [WLSaveLocalHelper fetchReadImageURLOrRGB];

    if (imageName.length > 0 && ![imageName isEqualToString:@"<null>"] && ![imageName isEqualToString:@"(null)"]) {
        //这里暂时取消动态化的图片
        if ([imageName hasPrefix:@"http"] || [imageName hasPrefix:@"https"]) {
            [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:imageName]];
        }else if ([imageName containsString:@","]){
            NSArray *array = [imageName componentsSeparatedByString:@","];
            if (array.count == 3) {
                NSInteger red = [[array objectAtIndex:0] integerValue];
                NSInteger green = [[array objectAtIndex:1] integerValue];
                NSInteger blue = [[array objectAtIndex:2] integerValue];
                self.mainImageView.backgroundColor = RGBCOLOR(red, green, blue, 1);
            }else{
                self.mainImageView.image = [UIImage imageNamed:@"poetryBack.jpg"];
            }
        }else{
            self.mainImageView.image = [UIImage imageNamed:@"poetryBack.jpg"];
        }
    }else{
        self.mainImageView.image = [UIImage imageNamed:@"poetryBack.jpg"];
    }
    
    
    //元素的布局
    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.leading.equalTo(self.view.mas_leading).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.trailing.equalTo(self.view.mas_trailing).offset(0);
    }];
    
}


- (void)loadContentTableView
{
    self.authorLabel.text = self.dataModel.author;
    
    if (self.contentTextColor) {
        self.titleFullLabel.textColor = self.contentTextColor;
        self.authorLabel.textColor = self.contentTextColor;
    }else{
        self.titleFullLabel.textColor = RGBCOLOR(60, 60, 120, 1);
        self.authorLabel.textColor = RGBCOLOR(60, 60, 120, 1);
    }
    
    self.mainTable.backgroundColor = [UIColor clearColor];
}

- (void)clickLikeWithBlock:(LikeBlock)block
{
    if (block) {
        self.likeBlock = block;
    }
}

- (void)loadLikeButton
{
    //按钮放在下层
    UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    likeBtn.backgroundColor = [UIColor whiteColor];
    likeBtn.layer.cornerRadius = 20.f;
    likeBtn.alpha = 0.7;
    [likeBtn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:likeBtn];
    
    self.likeImage = [[UIImageView alloc]init];
    if (self.isLike) {
        self.likeImage.image = [UIImage imageNamed:@"likePoetry"];
    }else{
        self.likeImage.image = [UIImage imageNamed:@"unlikePoetry"];
    }
    [self.view addSubview:self.likeImage];
    
    
    if (@available(iOS 11.0, *)) {
        //元素的布局
        [self.likeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(35);
            make.trailing.equalTo(self.view.mas_trailing).offset(-20);
            make.width.mas_equalTo(20);//元素宽度
            make.height.mas_equalTo(20);//元素高度
            
        }];
    }else{
        //设置UI布局约束
        [self.likeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.view.mas_top).offset(24);//元素顶部约束
            make.trailing.equalTo(self.view.mas_trailing).offset(-20);//元素右侧约束
            make.width.mas_equalTo(20);//元素宽度
            make.height.mas_equalTo(20);//元素高度
        }];
    }
    
    
    //设置UI布局约束
    [likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.likeImage.mas_top).offset(-10);//元素顶部约束
        make.trailing.equalTo(self.likeImage.mas_trailing).offset(10);//元素右侧约束
        make.bottom.equalTo(self.likeImage.mas_bottom).offset(10);//元素底部约束
        make.leading.equalTo(self.likeImage.mas_leading).offset(-10);
    }];
    
    //按钮放下层
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.backgroundColor = [UIColor whiteColor];
    shareBtn.layer.cornerRadius = 20.f;
    shareBtn.alpha = 0.7;
    [shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    
    UIImageView *shareImage = [[UIImageView alloc]init];
    shareImage.image = [UIImage imageNamed:@"shareIcon"];
    [self.view addSubview:shareImage];
    //设置UI布局约束
    [shareImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.likeImage.mas_bottom).offset(30);//元素顶部约束
        make.leading.equalTo(self.likeImage.mas_leading).offset(0);//元素左侧约束
        make.width.mas_equalTo(20);//元素宽度
        make.height.mas_equalTo(20);//元素高度
    }];
    

    //设置UI布局约束
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(shareImage.mas_top).offset(-10);//元素顶部约束
        make.trailing.equalTo(shareImage.mas_trailing).offset(10);//元素右侧约束
        make.bottom.equalTo(shareImage.mas_bottom).offset(10);//元素底部约束
        make.leading.equalTo(shareImage.mas_leading).offset(-10);
    }];
    
    //背诵按钮
    UIButton *reciteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reciteBtn.backgroundColor = [UIColor whiteColor];
    reciteBtn.layer.cornerRadius = 20.f;
    reciteBtn.alpha = 0.7;
    [reciteBtn addTarget:self action:@selector(reciteAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reciteBtn];
    
    UIImageView *reciteImage = [[UIImageView alloc]init];
    reciteImage.image = [UIImage imageNamed:@"reciteIcon"];
    [self.view addSubview:reciteImage];
    //设置UI布局约束
    [reciteImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(shareImage.mas_bottom).offset(30);//元素顶部约束
        make.leading.equalTo(self.likeImage.mas_leading).offset(0);//元素左侧约束
        make.width.mas_equalTo(20);//元素宽度
        make.height.mas_equalTo(20);//元素高度
    }];
   
    //设置UI布局约束
    [reciteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(reciteImage.mas_top).offset(-10);//元素顶部约束
        make.trailing.equalTo(reciteImage.mas_trailing).offset(10);//元素右侧约束
        make.bottom.equalTo(reciteImage.mas_bottom).offset(10);//元素底部约束
        make.leading.equalTo(reciteImage.mas_leading).offset(-10);
    }];
    
     //赏析按钮
     UIButton *analysesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     analysesBtn.backgroundColor = [UIColor whiteColor];
     analysesBtn.layer.cornerRadius = 20.f;
     analysesBtn.alpha = 0.7;
     [analysesBtn addTarget:self action:@selector(analysesAction:) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:analysesBtn];
     
     self.analysesImage = [[UIImageView alloc]init];
     self.analysesImage.image = [UIImage imageNamed:@"analyses"];
     [self.view addSubview:self.analysesImage];
     //设置UI布局约束
     [self.analysesImage mas_makeConstraints:^(MASConstraintMaker *make) {
         
         make.top.equalTo(reciteImage.mas_bottom).offset(30);//元素顶部约束
         make.leading.equalTo(self.likeImage.mas_leading).offset(0);//元素左侧约束
         make.width.mas_equalTo(20);//元素宽度
         make.height.mas_equalTo(20);//元素高度
     }];
    
     //设置UI布局约束
     [analysesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(self.analysesImage.mas_top).offset(-10);//元素顶部约束
         make.trailing.equalTo(self.analysesImage.mas_trailing).offset(10);//元素右侧约束
         make.bottom.equalTo(self.analysesImage.mas_bottom).offset(10);//元素底部约束
         make.leading.equalTo(self.analysesImage.mas_leading).offset(-10);
     }];

    
}

#pragma mark - 收藏
- (void)likeAction:(UIButton*)sender
{
    
    id token = kUserToken;
    if (!token) {
        token = @"";
    }
    
    NSString *tokenString = [NSString stringWithFormat:@"%@",token];
    //如果本地登录状态不是1，那么就意味着用户没有登录，无法进行收藏
    if (![kLoginStatus isEqualToString:@"1"]) {
//        [self presentToLogin];
        [self showHUDWithText:@"登录后即可收藏～"];
        return;
    }
    
    NSString *userId = kUserID;
    if (!userId || userId.length == 0) {
        userId = @"";
    }
    NSString *userIDString = [NSString stringWithFormat:@"%@",userId];
    __weak __typeof(self)weakSelf = self;


    if (self.isLike) {
        //如果之前是喜欢，点击按钮，则移除
        [[NetworkHelper shareHelper] dislikePoetry:userIDString poetryId:self.dataModel.poetryID withCompletion:^(BOOL success, NSDictionary *dic, NSError *error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;

            if (success) {
                NSString *codeString = [NSString stringWithFormat:@"%@",[dic objectForKey:@"retCode"]];
                if ([codeString isEqualToString:@"1000"]) {
                    strongSelf.isLike = !strongSelf.isLike;
                    
                    if (strongSelf.isLike) {
                        strongSelf.likeImage.image = [UIImage imageNamed:@"likePoetry"];
                    }else{
                        strongSelf.likeImage.image = [UIImage imageNamed:@"unlikePoetry"];
                    }
                    
                }else{
                    
                    NSString *tipMessage = [dic objectForKey:@"message"];
                    [strongSelf showHUDWithText:tipMessage];
                }
                
            }else{
                [strongSelf showHUDWithText:@"请求失败，请稍后重试"];
                
            }
        }];

        
    }else{
        //如果之前未喜欢，点击按钮，则收藏
        [[NetworkHelper shareHelper] likePoetry:userIDString poetryId:self.dataModel.poetryID withCompletion:^(BOOL success, NSDictionary *dic, NSError *error) {
            
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (success) {
                NSString *codeString = [NSString stringWithFormat:@"%@",[dic objectForKey:@"retCode"]];
                if ([codeString isEqualToString:@"1000"]) {
                    strongSelf.isLike = !strongSelf.isLike;
                    
                    if (strongSelf.isLike) {
                        strongSelf.likeImage.image = [UIImage imageNamed:@"likePoetry"];
                    }else{
                        strongSelf.likeImage.image = [UIImage imageNamed:@"unlikePoetry"];
                    }
                    
                    
                }else{
                    
                    NSString *tipMessage = [dic objectForKey:@"message"];
                    [strongSelf showHUDWithText:tipMessage];
                }
                
            }else{
                [strongSelf showHUDWithText:@"请求失败，请稍后重试"];
            }
        }];
    }

    
}

- (void)shareAction:(UIButton*)sender
{
    UIImage *image =  [self fullScreenShot];
    [self shareWithImageArray:@[image]];
    
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

- (void)reciteAction:(UIButton*)sender
{
    NSLog(@"背诵");
    RecitePoetryController *vc = [[RecitePoetryController alloc]init];
    vc.dataArray = self.dataArray;
    vc.dataModel = self.dataModel;
    [vc loadCustomView];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)analysesAction:(UIButton*)sender{
    NSLog(@"赏析");
    
    if (self.isShowAnalyseView) {
        [self hideAnalyseView];
        self.analysesImage.image = [UIImage imageNamed:@"analyses"];
    }else{
        //如果本地没有token，那么就意味着用户没有登录
        if (![kLoginStatus isEqualToString:@"1"]) {
//            [self presentToLogin];
            [self showHUDWithText:@"登录后即可查看～"];
            return;
        }


        if (kStringIsEmpty(self.dataModel.analysesInfo) && kStringIsEmpty(self.dataModel.addtionInfo) && kStringIsEmpty(self.dataModel.transferInfo) && kStringIsEmpty(self.dataModel.backgroundInfo)) {
            [self requestAnalysesInfo];
        }else{
            [self loadAnalyseView];
        }

    }

}

- (void)requestAnalysesInfo{
    __weak __typeof(self)weakSelf = self;
    [[NetworkHelper shareHelper] loadAnalysesWithPoetryId:self.dataModel.poetryID withCompletion:^(BOOL success, NSDictionary *dic, NSError *error) {
        NSLog(@"鉴赏信息:%@",dic);
        __strong __typeof(weakSelf)strongSelf = weakSelf;

        if (success) {
            NSString *codeString = [NSString stringWithFormat:@"%@",[dic objectForKey:@"retCode"]];
            if ([codeString isEqualToString:@"1000"]) {
                NSDictionary *dataDic = [dic objectForKey:@"data"];
                strongSelf.dataModel.addtionInfo = [dataDic objectForKey:@"addition_info"];
                strongSelf.dataModel.analysesInfo = [dataDic objectForKey:@"analyses_info"];
                strongSelf.dataModel.backgroundInfo = [dataDic objectForKey:@"background_info"];
                strongSelf.dataModel.transferInfo = [dataDic objectForKey:@"transfer_info"];
                [strongSelf loadAnalyseView];
            }else{
                [strongSelf showHUDWithText:@"网络请求失败，请稍后重试"];
            }
        }
        
    }];
}

- (void)presentToLogin{
    WLLoginViewController *vc = [[WLLoginViewController alloc]init];
    vc.showType = @"present";
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];

}

- (void)loadAnalyseView{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.analysesView) {
            self.analysesView = [[WLAnalysesView alloc]init];
            self.analysesView.analysesInfo = self.dataModel.analysesInfo;
            self.analysesView.additionInfo = self.dataModel.addtionInfo;
            self.analysesView.transferInfo = self.dataModel.transferInfo;
            self.analysesView.backgroundInfo = self.dataModel.backgroundInfo;
            [self.analysesView configureView];
            [self.view addSubview:self.analysesView];
        }
        
        [UIView animateWithDuration:0.35 animations:^{
            self.analysesView.transform = CGAffineTransformMakeTranslation(0, -PhoneScreen_HEIGHT/2);
        } completion:^(BOOL finished) {
            
            [self.mainTable mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.view.mas_leading).offset(leftSpace);
                make.top.equalTo(self.authorLabel.mas_bottom).offset(topSpace);
                make.bottom.equalTo(self.view.mas_centerY);
                make.trailing.equalTo(self.view.mas_trailing).offset(-leftSpace);
            }];

        }];
        
        self.isShowAnalyseView = YES;
        self.analysesImage.image = [UIImage imageNamed:@"analyses_selected"];

    });
}

- (void)hideAnalyseView{
        
    [UIView animateWithDuration:0.35 animations:^{
        self.analysesView.transform = CGAffineTransformIdentity;
    }];
    self.isShowAnalyseView = NO;
    self.analysesImage.image = [UIImage imageNamed:@"analyses"];
    
    [self.mainTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(leftSpace);
        make.top.equalTo(self.authorLabel.mas_bottom).offset(topSpace);
        make.bottom.equalTo(self.view.mas_bottom).offset(-topSpace);
        make.trailing.equalTo(self.view.mas_trailing).offset(-leftSpace);
    }];



}
#pragma mark - TableView 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataArray.count) {
        NSString *content = self.dataArray[indexPath.row];
        return [WLPoetryContentCell heightForContent:content withWidth:(PhoneScreen_WIDTH-2*leftSpace-20)];
    }
    
    return 0;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WLPoetryContentCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"WLPoetryContentCell"];
    if (!contentCell) {
        
        CGFloat cellHeight = 0;
        if (indexPath.row < self.dataArray.count) {
            NSString *content = self.dataArray[indexPath.row];
            cellHeight = [WLPoetryContentCell heightForContent:content withWidth:(PhoneScreen_WIDTH-2*leftSpace-20)];
        }
        contentCell = [[WLPoetryContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WLPoetryContentCell"];
        contentCell.frame = CGRectMake(0, 0, PhoneScreen_WIDTH-2*leftSpace-20, cellHeight);
    }
    contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    contentCell.backgroundColor = [UIColor clearColor];
    contentCell.contentString = self.dataArray[indexPath.row];
    contentCell.contentLabel.textColor = self.contentTextColor;
    
    return contentCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [self hideAnalyseView];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    
    return  NO;
}
#pragma mark - 点击事件

- (void)backAction:(UIButton *)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}



#pragma mark - Property
- (UITableView*)mainTable
{
    if (!_mainTable) {
        
        _mainTable = [[UITableView alloc]init];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTable.showsVerticalScrollIndicator= NO;
        [self.view addSubview:_mainTable];
        //元素的布局
        [_mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.view.mas_leading).offset(leftSpace);
            make.top.equalTo(self.authorLabel.mas_bottom).offset(topSpace);
            make.bottom.equalTo(self.view.mas_bottom).offset(-topSpace);
            make.trailing.equalTo(self.view.mas_trailing).offset(-leftSpace);
            
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideAnalyseView)];
        tap.delegate = self;
        [_mainTable addGestureRecognizer:tap];

    }
    return _mainTable;
}

- (UILabel *)authorLabel
{
    if (!_authorLabel) {
        _authorLabel = [[UILabel alloc]init];
        _authorLabel.textAlignment = NSTextAlignmentCenter;
        _authorLabel.textColor = RGBCOLOR(60, 60, 60, 1.0);
        _authorLabel.font = [AppConfig config].authorFont;
        [self.view addSubview:_authorLabel];
        //元素的布局
        [_authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.view.mas_leading).offset(leftSpace);
            make.top.equalTo(self.titleFullLabel.mas_bottom).offset(topSpace);
            make.trailing.equalTo(self.view.mas_trailing).offset(-leftSpace);
            make.height.mas_equalTo(24);
            
        }];
    }
    return _authorLabel;
}

- (void)dealloc{
    NSLog(@"detail dealloc");

}

@end
