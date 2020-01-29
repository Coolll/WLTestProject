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


static const CGFloat leftSpace = 10;//诗句的左右间距
static const CGFloat topSpace = 15;//诗句与标题的上间距

@interface PoetryDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

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
 *  是否需要使用默认文本颜色
 **/
@property (nonatomic,assign) BOOL needUseDefaultColor;
/**
 *  文本颜色
 **/
@property (nonatomic,strong) UIColor *contentTextColor;



@end

@implementation PoetryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (kStringIsEmpty(self.dataModel.textColor)) {
        //静夜思 背景色为深色，文本改为白色
        self.needUseDefaultColor = YES;
    }else{
        NSString *string = self.dataModel.textColor;
        NSArray *array = [string componentsSeparatedByString:@","];
        if (array.count == 4) {
            NSInteger red = [[array objectAtIndex:0] integerValue];
            NSInteger green = [[array objectAtIndex:1] integerValue];
            NSInteger blue = [[array objectAtIndex:2] integerValue];
            CGFloat alpha = [[array objectAtIndex:3] floatValue];
            self.contentTextColor = RGBCOLOR(red, green, blue, alpha);
            self.needUseDefaultColor = NO;
        }else{
            self.needUseDefaultColor = YES;
        }
    }
    
    self.titleForNavi = self.dataModel.name;
    [self loadMainBackImageView];//背景
    [self addFullTitleLabel];//诗词名字 添加背景之后调用，否则会被背景图遮住

    [self loadCustomData];//加载数据
    
    [self addBackButtonForFullScreen];//返回按钮，需要最后添加
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
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
    
//    id userId = kUserID;
//    if (!userId) {
//        userId = @"";
//    }
//    NSString *userIdString = [NSString stringWithFormat:@"%@",userId];
    
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
    

//    [[NetworkHelper shareHelper] requestUserAllLikes:userIdString withCompletion:^(BOOL success, NSDictionary *dic, NSError *error) {
//
//        if (success) {
//
//            NSString *code = [NSString stringWithFormat:@"%@",[dic objectForKey:@"retCode"]];
//            if (![code isEqualToString:@"1000"]) {
//                NSString *tipMessage = [dic objectForKey:@"message"];
//                [self showHUDWithText:tipMessage];
//                return;
//            }
//
//            NSArray *dataArr = [dic objectForKey:@"data"];
//            if (dataArr.count == 0) {
//                self.isLike = NO;
//                [self loadLikeButton];
//                return;
//            }
//
//            BOOL isContain = NO;
//            for (NSNumber *poetryID in dataArr) {
//                NSString *poetryIdString = [NSString stringWithFormat:@"%@",poetryID];
//                //已经收藏了的诗词
//                if ([poetryIdString isEqualToString:self.dataModel.poetryID]) {
//                    self.isLike = YES;
//                    [self loadLikeButton];
//                    return;
//                }
//            }
//
//            if (!isContain) {
//                self.isLike = NO;
//                [self loadLikeButton];
//            }
//        }else{
//            //如果网络请求失败，则默认没有
//            self.isLike = NO;
//            [self loadLikeButton];
//        }
//
//    }];
    
    
   
    
    
}
#pragma mark - 初始化数据和视图

- (void)loadCustomData
{
    self.dataArray = [NSArray array];
    
    self.dataArray = [[WLPublicTool shareTool] poetrySeperateWithOrigin:self.dataModel.content];
    
    [self loadContentTableView];

}




- (void)loadMainBackImageView
{
    //诗词主背景
    self.mainImageView = [[UIImageView alloc]init];
    [self.view addSubview:self.mainImageView];
    self.mainImageView.contentMode = UIViewContentModeScaleToFill;
    self.mainImageView.backgroundColor = RGBCOLOR(243, 238, 214, 1.0);
    NSString *imageName = self.dataModel.backImageURL;
    if (imageName.length > 0 && ![imageName isEqualToString:@"<null>"] && ![imageName isEqualToString:@"(null)"]) {

        [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:imageName]];
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
    //背景色为深色时，文本颜色为白色
    if (!self.needUseDefaultColor) {
        if (self.contentTextColor) {
            self.titleFullLabel.textColor = self.contentTextColor;
            self.authorLabel.textColor = self.contentTextColor;
        }else{
            self.titleFullLabel.textColor = [UIColor whiteColor];
            self.authorLabel.textColor = [UIColor whiteColor];
        }
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
    
    //按钮放下层
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
    
}

#pragma mark - 收藏
- (void)likeAction:(UIButton*)sender
{
    
    id token = kUserToken;
    if (!token) {
        token = @"";
    }
    
    NSString *tokenString = [NSString stringWithFormat:@"%@",token];
    //如果本地没有token，那么就意味着用户没有登录，无法进行收藏
    if (tokenString.length == 0) {
        [self showHUDWithText:@"您尚未登录，请登录后重试"];
        return;
    }
    
    NSString *userId = kUserID;
    if (!userId || userId.length == 0) {
        userId = @"";
    }
    NSString *userIDString = [NSString stringWithFormat:@"%@",userId];
    
    if (self.isLike) {
        //如果之前是喜欢，点击按钮，则移除
        [[NetworkHelper shareHelper] dislikePoetry:userIDString poetryId:self.dataModel.poetryID withCompletion:^(BOOL success, NSDictionary *dic, NSError *error) {
            if (success) {
                NSString *codeString = [NSString stringWithFormat:@"%@",[dic objectForKey:@"retCode"]];
                if ([codeString isEqualToString:@"1000"]) {
                    self.isLike = !self.isLike;
                    
                    if (self.isLike) {
                        self.likeImage.image = [UIImage imageNamed:@"likePoetry"];
                    }else{
                        self.likeImage.image = [UIImage imageNamed:@"unlikePoetry"];
                    }
                    
                    
                }else{
                    
                    NSString *tipMessage = [dic objectForKey:@"message"];
                    [self showHUDWithText:tipMessage];
                }
                
            }else{
                [self showHUDWithText:@"请求失败，请稍后重试"];
                
            }
        }];

        
    }else{
        //如果之前未喜欢，点击按钮，则收藏
        [[NetworkHelper shareHelper] likePoetry:userIDString poetryId:self.dataModel.poetryID withCompletion:^(BOOL success, NSDictionary *dic, NSError *error) {
            if (success) {
                NSString *codeString = [NSString stringWithFormat:@"%@",[dic objectForKey:@"retCode"]];
                if ([codeString isEqualToString:@"1000"]) {
                    self.isLike = !self.isLike;
                    
                    if (self.isLike) {
                        self.likeImage.image = [UIImage imageNamed:@"likePoetry"];
                    }else{
                        self.likeImage.image = [UIImage imageNamed:@"unlikePoetry"];
                    }
                    
                    
                }else{
                    
                    NSString *tipMessage = [dic objectForKey:@"message"];
                    [self showHUDWithText:tipMessage];
                }
                
            }else{
                [self showHUDWithText:@"请求失败，请稍后重试"];

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
        contentCell = [[WLPoetryContentCell alloc]initWithFrame:CGRectMake(0, 0, PhoneScreen_WIDTH-2*leftSpace-20, cellHeight)];
    }
    contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    contentCell.backgroundColor = [UIColor clearColor];
    contentCell.contentString = self.dataArray[indexPath.row];
    if (!self.needUseDefaultColor) {
        if (self.contentTextColor) {
            contentCell.contentLabel.textColor = self.contentTextColor;
        }else{
            contentCell.contentLabel.textColor = [UIColor whiteColor];
        }
    }
    
    return contentCell;
}
#pragma mark - 点击事件

- (void)backAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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


@end
